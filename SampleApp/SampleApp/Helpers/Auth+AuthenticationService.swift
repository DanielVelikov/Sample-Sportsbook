//
//  Auth+AuthenticationService.swift
//  SampleApp
//
//  Created by Daniel Velikov on 13.02.24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseDatabase

enum AccountDetailsKey: String {
    case alias
}

enum AuthError {
    case custom(Error)
}

extension Auth: AuthenticationService {
    private var service: Auth { Auth.auth() }
    private var usersReference: DatabaseReference { Database.database().reference().child("users") }
    
    func register(email: String, password: String, alias: String) async throws -> Account {
        let result = try await service.createUser(withEmail: email, password: password)
        
        let details: [String: Any] = [
            "alias": alias
        ]
        
        try await storeAccountDetails(id: result.user.uid, data: details)
        
        UserDefaults.store(data: email, key: .email)
        UserDefaults.store(data: alias, key: .alias)
        
        return .init(user: result.user, email: email, alias: alias)
    }
    
    func signIn(email: String, password: String) async throws -> Account {
        let result = try await service.signIn(withEmail: email, password: password)
        let details = try await fetchAccountDetails(id: result.user.uid)
        
        let alias = details[AccountDetailsKey.alias.rawValue] as? String ?? ""
        
        UserDefaults.store(data: email, key: .email)
        UserDefaults.store(data: alias, key: .alias)
        
        return .init(user: result.user, email: email, alias: alias)
    }
    
    func storeAccountDetails(id: String, data: [String: Any]) async throws {
        try await usersReference.child(id).setValue(data)
    }
    
    func fetchAccountDetails(id: String) async throws -> [String: Any] {
        try await usersReference.child(id).getData().value as? [String: Any] ?? [:]
    }
}
