//
//  Profile.swift
//  trapr
//
//  Created by Andrew Tokeley on 16/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

class Settings: Object {

    // Primary key
    dynamic var id: String = UUID().uuidString
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // Full name of the trapper using the app on device
    dynamic var username: String?
 
    dynamic var emailVisitsRecipient: String?
    dynamic var emailOrdersRecipient: String?
    
    // Version of app
    dynamic var appVersion: String?
    
    // Version of Realm database
    dynamic var realmVersion: String?
}
