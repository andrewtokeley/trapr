//
//  UserSettingsServiceInterface.swift
//  trapr
//
//  Created by Andrew Tokeley on 3/01/19.
//  Copyright © 2019 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol UserSettingsServiceInterface {
    
    /// Gets the user defined settings for the current user
    func get(completion: ((UserSettings?, Error?) -> Void)?)
    
    func add(userSettings: UserSettings, completion: ((Error?) -> Void)?)
}
