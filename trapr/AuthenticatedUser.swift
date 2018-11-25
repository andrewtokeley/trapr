//
//  AuthenticatedUser.swift
//  trapr
//
//  Created by Andrew Tokeley on 26/10/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//


import Foundation

/**
 Platform agnostic representation of an authenticated user.
 */
class AuthenticatedUser {
    var email: String
    var displayName: String?
    
    init(email: String) {
        self.email = email
    }
}
