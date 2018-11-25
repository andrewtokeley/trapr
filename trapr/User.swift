//
//  User.swift
//  trapr
//
//  Created by Andrew Tokeley on 19/10/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import FirebaseFirestore

enum UserFields: String {
    case email = "email"
    case displayName = "displayName"
    case lastAuthenticated = "lastAuthenticated"
    case lastOpenedApp = "lastOpenedApp"
    case roles = "roles"
    case imageUrl = "imageUrl"
}

/**
 A user who is registered with the app.
 */
class User: DocumentSerializable {
    
    //MARK: - Primary Key
    var id: String?
    
    //MARK: - Document Fields
    var displayName: String?
    
    /**
     Date at which the user logged was authenticated by the app
     */
    var lastAuthenticated: Date?
    
    /**
     Date the user last opened the app
     */
    var lastOpenedApp: Date?
    
    /**
     Reference to the image for the user's profile
     */
    var imageUrl: String?
    
    /**
     The roles the user is a member of. Use isInRole(UserRole:) to simplify checking membership.
     */
    var roles: [String]
    
    //MARK: - Public Functions
    
    /**
     Returns true if the user is in the given role
     */
    func isInRole(role: UserRole) -> Bool {
        if role == .admin && roles.contains("admin") { return true }
        else if role == .contributor && roles.contains("contributor") { return true }
        else if role == .editor && roles.contains("editor") { return true }
        return false
    }
    
    //MARK: - DocumentSerializable
    
    var dictionary: [String: Any] {

        var result = [String: Any]()
    
        // there will always be at least one role
        result[UserFields.roles.rawValue] = roles
    
        // optional fields, only return in dictionary if they're non nil
        if let _ = displayName { result[UserFields.displayName.rawValue] = displayName! }
        if let _ = lastAuthenticated { result[UserFields.lastAuthenticated.rawValue] = lastAuthenticated! }
        if let _ = lastOpenedApp { result[UserFields.lastOpenedApp.rawValue] = lastOpenedApp! }
        if let _ = imageUrl { result[UserFields.imageUrl.rawValue] = imageUrl! }
    
        return result
    }
    
    init(email: String) {
        self.id = email
        self.roles = [UserRole.contributor.rawValue]
    }
    
    required init?(dictionary: [String: Any]) {
        
        // check for mandatory fields
        guard
            let roles = dictionary[UserFields.roles.rawValue] as? [String]
        else {
            return nil
        }
        
        self.roles = roles
        
        // all remaining fields are optional
        
        if let displayName = dictionary[UserFields.displayName.rawValue] as? String {
            self.displayName = displayName
        }
        if let lastAuthenticated = dictionary[UserFields.lastAuthenticated.rawValue] as? Timestamp {
            self.lastAuthenticated = lastAuthenticated.dateValue()
        }
        if let lastOpenedApp = dictionary[UserFields.lastOpenedApp.rawValue] as? Timestamp {
            self.lastOpenedApp = lastOpenedApp.dateValue()
        }
        if let imageUrl = dictionary[UserFields.imageUrl.rawValue] as? String {
            self.imageUrl = imageUrl
        }
        
    }
}
