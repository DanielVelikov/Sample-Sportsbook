//
//  AuthView.swift
//  SampleApp
//
//  Created by Daniel Velikov on 11.02.24.
//

import SwiftUI
import FirebaseAuth

struct AuthView<T: AuthViewModel>: CoordinatorModelView {
    enum FocusField {
        case email
        case password
    }
    
    @FocusState private var focusField: FocusField?
    @ObservedObject private(set) var model: T
    
    init(model: T) {
        self.model = model
    }
    
    var body: some View {
        GeometryReader { geoReader in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .center) {
                    Text(model.variant.welcomeText)
                        .padding(.top, 32)
                        .font(.system(size: 36, weight: .semibold))
                    Spacer()
                    VStack(alignment: .leading, spacing: 25) {
                        InputView(
                            "Email",
                            input: $model.email,
                            variant: .email
                        )
                        .focused($focusField, equals: .email)
                        .font(.system(size: 22, weight: .medium))
                        .modifier(DividerModifier(color: model.hasValidEmail ? .accentColor : .main))
                        .animation(.easeInOut(duration: 0.25), value: model.hasValidEmail)
                        
                        InputView(
                            "Password",
                            input: $model.password,
                            variant: .secure
                        )
                        .focused($focusField, equals: .email)
                        .font(.system(size: 22, weight: .medium))
                        .modifier(DividerModifier(color: model.hasValidPassword ? .accentColor : .main))
                        .animation(.easeInOut(duration: 0.25), value: model.hasValidPassword)
                        
                        if model.variant == .register {
                            InputView(
                                "Alias",
                                input: $model.alias,
                                variant: .plain
                            )
                            .focused($focusField, equals: .email)
                            .font(.system(size: 22, weight: .medium))
                            .modifier(DividerModifier(color: model.alias.isNotEmpty ? .accentColor : .main))
                            .animation(.easeInOut(duration: 0.25), value: model.alias.isNotEmpty)
                        }
                        
                        if case .error = model.requestStatus {
                            Text("Something went wrong. Please try again!")
                                .foregroundStyle(.main)
                                .fixedSize(horizontal: false, vertical: true)
                                .font(.system(size: 20))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.init(vertical: 12, horizontal: 25))
                                .transition(.asymmetric(insertion: .opacity, removal: .identity))
                                .background(.red)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .onTapGesture {
                                    model.requestStatus = .notStarted
                                }
                        }
                    }
                    
                    Spacer()
                    Button {
                        focusField = nil
                        model.authenticate()
                    } label: {
                        ZStack {
                            Text("Continue")
                                .font(.system(size: 24))
                                .opacity(model.requestStatus == .inProgress ? 0.0 : 1.0)
                            ProgressView()
                                .progressViewStyle(.circular)
                                .opacity(model.requestStatus != .inProgress ? 0.0 : 1.0)
                                .tint(.accent)
                        }
                        .animation(.easeInOut, value: model.requestStatus)
                    }
                    .tint(.main)
                    .foregroundStyle(.accent)
                    .buttonStyle(.borderedProminent)
                    .disabled(model.isEnabled() == false)
                    
                    Spacer()
                    VStack(spacing: 5) {
                        Text(model.variant.footerText)
                            .foregroundStyle(.main)
                        Button(model.variant.footerActionText) {
                            onMain {
                                model.variant.toggle()
                                model.resetInput()
                                focusField = nil
                            }
                        }
                    }
                    .padding(.bottom, 15)
                }
                .frame(minHeight: geoReader.size.height)
            }
        }
        .padding(.init(vertical: 50, horizontal: 40))
        .animation(.easeInOut, value: focusField)
        .animation(.easeInOut, value: model.requestStatus == .error)
        .animation(.easeInOut, value: model.variant)
        .contentShape(.rect)
        .onAppear {
            guard model.email.isNotEmpty else { return }
            model.validate(.email)
        }
        .onChange(of: focusField) { (value) in
            guard model.requestStatus == .error, value != nil else { return }
            model.requestStatus = .notStarted
        }
        .onChange(of: model.email) { (email) in
            model.validate(.email)
        }
        .onChange(of: model.password) { (_) in
            model.validate(.password)
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                
                Button("Done") {
                    focusField = nil
                }
            }
        }
    }
}

#Preview {
    AuthView(model: AuthModel(
        coordinator: AppCoordinator(
            navigationController: .init(),
            injected: .init(
                account: nil,
                authService: Auth.auth()
            )
        ),
        service: Auth.auth(),
        variant: .register, email: nil)
    )
}
