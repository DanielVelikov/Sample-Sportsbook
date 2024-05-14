//
//  UserModel.swift
//  SampleApp
//
//  Created by Daniel Velikov on 11.02.24.
//

import Foundation
import FirebaseAuth

struct UserModel {
    var user: User?
    var isLoggedIn: Bool { user != nil }
}
