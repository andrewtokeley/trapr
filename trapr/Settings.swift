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
    @objc dynamic var id: String = UUID().uuidString
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // Full name of the trapper using the app on device
    @objc dynamic var username: String?
    @objc dynamic var emailVisitsRecipient: String?
    @objc dynamic var emailOrdersRecipient: String?
    
    // Version of app
    @objc dynamic var appVersion: String?
    
    // Version of Realm database
    @objc dynamic var realmVersion: String?
    
    var documentDirectory: URL {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return URL(fileURLWithPath: documentDirectory)
    }
    
}
