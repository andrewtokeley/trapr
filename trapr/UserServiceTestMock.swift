//
//  UserServiceTestMock.swift
//  trapr
//
//  Created by Andrew Tokeley on 16/02/19.
//  Copyright © 2019 Andrew Tokeley . All rights reserved.
//

import Foundation

class UserServiceTestMock: UserServiceInterface {
    
    init() {
        currentUser = User(email: "tester@andrewtokeley.com")
        currentUser?.roles.append(UserRole.tester.rawValue)
    }
    
    var currentUser: User?
    
    func get(email: String, completion: ((User?, Error?) -> Void)?) {
        //
    }
    
    func getUserStats(completion: ((UserStatistics?, Error?) -> Void)?) {
        //
    }
    
    func registerAuthenticatedUser(authenticatedUser: AuthenticatedUser, completion: ((User?, Error?) -> Void)?) {
        completion?(currentUser, nil)
    }
    
    func update(user: User, completion: ((Error?) -> Void)?) {
        //
    }
    
    func updateLastOpenedApp(user: User, lastOpenedApp: Date, completion: ((Error?) -> Void)?) {
        //
    }
    
    func delete(user: User, completion: ((Error?) -> Void)?) {
        //
    }
    
    func deleteAllUsers(completion: ((Error?) -> Void)?) {
        //
    }
    
    
}
