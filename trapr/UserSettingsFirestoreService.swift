//
//  UserSettingsFirestoreService.swift
//  trapr
//
//  Created by Andrew Tokeley on 3/01/19.
//  Copyright © 2019 Andrew Tokeley . All rights reserved.
//

import Foundation

class UserSettingsFirestoreService: FirestoreEntityService<UserSettings>, UserSettingsServiceInterface {
    
    let userService = ServiceFactory.sharedInstance.userService
    
    func get(completion: ((UserSettings?, Error?) -> Void)?) {
        
        if let id = userService.currentUser?.id {
            super.get(id: id) { (userSettings, error) in
                if let userSettings = userSettings {
                    completion?(userSettings, error)
                } else {
                    // return a default user settings result
                    completion?(UserSettings(email: id), nil)
                }
            }
        } else {
            completion?(nil, FirestoreEntityServiceError.entityNotFound)
        }
    }
    
    func add(userSettings: UserSettings, completion: ((Error?) -> Void)?) {
        let _ = super.add(entity: userSettings) { (userSettings, error) in
            completion?(error)
        }
    }
    
    
}
