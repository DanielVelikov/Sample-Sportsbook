//
//  Injected.swift
//  SampleApp
//
//  Created by Daniel Velikov on 5.02.24.
//

import Foundation
import FirebaseAuth


class Injected {
    var account: Account?
    var authService: Auth
    
    
    var email: String? { account?.email }
    var alias: String? { account?.alias }
    var uuid: String { account?.user?.uid ?? "Missing" }
    
    var accountStatus: Account.Status {
        guard account?.user == nil else { return .hasSession }
        
        return email != nil ? .hasLocalData : .noData
    }
    
    init(account: Account?, authService: Auth) {
        self.account = account
        self.authService = authService
    }
    
    // MARK: - Public
    func updateAccount(with account: Account) {
        self.account = account
    }
    
    func resetAccount() {
        self.account = nil
    }
}
