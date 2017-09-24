//
//  DataService.swift
//  trapr
//
//  Created by Andrew Tokeley  on 18/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

import Foundation
import RealmSwift

class DataService {
    
    private let CURRENT_SCHEMA_VERSION = 1
    private let TEST_REALM_NAME = "traprTestRealm"
    private let REALM_NAME = "traprRealm"
    
    private var documentDirectory: URL {
        let url = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return URL(fileURLWithPath: url)
    }
    
    lazy var realm: Realm = {

        // return default data store
        self.configuration.fileURL = self.documentDirectory
            .appendingPathComponent(self.REALM_NAME)
        
        return try! Realm(configuration: self.configuration)
    }()

    lazy var realmTestInstance: Realm = {

        self.configuration.fileURL = self.documentDirectory
            .appendingPathComponent(self.TEST_REALM_NAME)
        
        return try! Realm(configuration: self.configuration)
    }()
    
    private lazy var configuration: Realm.Configuration = {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        return config
        
    }()
}
