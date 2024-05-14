//
//  AuthModel.swift
//  SampleApp
//
//  Created by Daniel Velikov on 13.02.24.
//

import Foundation
import FirebaseAuth

class AuthModel<Service: AuthenticationService, Coordinator: BaseCoordinator & AccountObserver>: ObservableObject, AuthViewModel {
    let service: Service
    weak var coordinator: Coordinator?
    
    @Published var variant: AuthVariant = .signIn
    @Published var requestStatus: RequestStatus = .notStarted
    @Published var email: String
    @Published var password: String = ""
    @Published var alias: String = ""
    @Published var hasValidEmail = false
    @Published var hasValidPassword = false
    
    var accountObserver: AccountObserver? { coordinator }
    
    init(coordinator: Coordinator?, service: Service, variant: AuthVariant, email: String?) {
        self.coordinator = coordinator
        self.service = service
        self.variant = variant
        self.email = email ?? ""
    }
    
    func validate(_ credential: Credential) {
        switch credential {
        case .email:
            hasValidEmail = NSRegularExpression.email.matches(in: email)
        case .password:
            hasValidPassword = password.count > 5
        }
    }
    
    func resetInput() {
        email = ""
        password = ""
        alias = ""
    }
    
    func isEnabled() -> Bool {
        let hasValidAlias = variant == .register ? alias.isNotEmpty : true
        return hasValidEmail && hasValidPassword && hasValidAlias
    }
}
