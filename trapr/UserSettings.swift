//
//  UserSettings.swift
//  trapr
//
//  Created by Andrew Tokeley on 3/01/19.
//  Copyright © 2019 Andrew Tokeley . All rights reserved.
//

import Foundation

enum UserSettingsFields: String {
    case handlerEmail = "handlerEmail"
    case orderEmail = "orderEmail"
}

class UserSettings: DocumentSerializable {
    
    // Primary key will be email address
    var id: String?
    
    var handlerEmail: String?
    var orderEmail: String?
    
    //MARK: - DocumentSerializable
    
    var dictionary: [String: Any] {
        
        var result = [String: Any]()
        
        // optional fields, only return in dictionary if they're non nil
        if let _ = handlerEmail { result[UserSettingsFields.handlerEmail.rawValue] = handlerEmail! }
        if let _ = orderEmail { result[UserSettingsFields.orderEmail.rawValue] = orderEmail! }
        
        return result
    }
    
    /// Initialise UserSettings instance with defaults
    init(email: String) {
        self.id = email
        
        // set some defaults
        self.handlerEmail = "gale@windywelly.com"
        
    }
    
    required init?(dictionary: [String: Any]) {
        if let handlerEmail = dictionary[UserSettingsFields.handlerEmail.rawValue] as? String {
            self.handlerEmail = handlerEmail
        }
        if let orderEmail = dictionary[UserSettingsFields.orderEmail.rawValue] as? String {
            self.orderEmail = orderEmail
        }
    }
}
