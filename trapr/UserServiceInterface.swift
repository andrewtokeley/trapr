//
//  UserServiceInterface.swift
//  trapr
//
//  Created by Andrew Tokeley on 19/10/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

public enum UserRole: String {
    case admin
    case contributor
    case editor
}

protocol UserServiceInterface {
    
    /**
     Local reference to the current User. Note this value can be nil if the user hasn't yet authenticated with the app, or the app's authentication cache has expired.
     */
    var currentUser: User? { get }
    
    /**
     Returns a User object for the given email address, or nil if user does not exist
     */
    func get(email: String, completion: ((User?, Error?) -> Void)?)
    
    /**
     Returns the number of registered users in the system.
     */
    func getUserStats(completion: ((UserStatistics?, Error?) -> Void)?)
    
    /**
     Register that a new user has authenticated to the app. For example, when someone has successfully logged in via Google. This method will ensure a user record is added/update to the database. If the supplied user email
    */
    func registerAuthenticatedUser(authenticatedUser: AuthenticatedUser, completion: ((User?, Error?) -> Void)?)
    
//    /**
//     Get a User by their email address. This is typically called to verify whether a user already exists
//     */
//    func getUserByEmail(email: String, completion: @escaping(User?) -> Void)
//    
    /**
    Update the given user record in the database. If the user already exists (by matching on email), it's fields are merged with the existing record, otherwise a new user record is created.
    */
    func update(user: User, completion: ((Error?) -> Void)?)
    
    /**
    Updates the lastOpenedApp field on the CurrentUser record
     */
    func updateLastOpenedApp(user: User, lastOpenedApp: Date, completion: ((Error?) -> Void)?)
    
    /**
     Permanently deletes the user's record from the database. This does not affect any of the visits created by the user, but will force a new database record to be created the next time they open the app.
     */
    func delete(user: User, completion: ((Error?) -> Void)?)
    
    func deleteAllUsers(completion: ((Error?) -> Void)?)
}
