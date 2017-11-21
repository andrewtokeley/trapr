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

public enum DataFiles: String {
    case testFile = "traprTestRealm.realm"
    case productionFile = "traprRealm.realm"
}

class DataService {
    
    static let sharedInstance = DataService()
    
    private let CURRENT_SCHEMA_VERSION:UInt64 = 10
    
    private var documentDirectory: URL {
        let url = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        return URL(fileURLWithPath: url)
    }
    
    lazy var realm: Realm = {

        // return default data store
        self.configuration.fileURL = self.documentDirectory
            .appendingPathComponent(DataFiles.productionFile.rawValue)
        
        return try! Realm(configuration: self.configuration)
    }()

    lazy var realmTestInstance: Realm = {

        self.configuration.fileURL = self.documentDirectory
            .appendingPathComponent(DataFiles.testFile.rawValue)
        
        return try! Realm(configuration: self.configuration)
    }()
    
    private lazy var configuration: Realm.Configuration = {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: self.CURRENT_SCHEMA_VERSION,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                
                if (oldSchemaVersion < 2) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
                
                if (oldSchemaVersion < 3) {
                    // primary key was aded for Visit objects
                    migration.enumerateObjects(ofType: Visit.className()) { oldObject, newObject in
                        // add a primary key value
                        newObject!["id"] = UUID().uuidString
                    }
                }
                if (oldSchemaVersion < 4) {
                    
                    // primary key was aded for Species objects
                    migration.enumerateObjects(ofType: Species.className()) { oldObject, newObject in
                        // add a primary key value
                        newObject!["id"] = UUID().uuidString
                    }
                    // primary key was aded for TrapType objects
                    migration.enumerateObjects(ofType: TrapType.className()) { oldObject, newObject in
                        // add a primary key value
                        newObject!["id"] = UUID().uuidString
                    }
                    // primary key was aded for Trap objects
                    migration.enumerateObjects(ofType: Trap.className()) { oldObject, newObject in
                        // add a primary key value
                        newObject!["id"] = UUID().uuidString
                    }
                    // primary key was aded for Trap objects
                    migration.enumerateObjects(ofType: Station.className()) { oldObject, newObject in
                        // add a primary key value
                        newObject!["id"] = UUID().uuidString
                    }
                }
                
                if (oldSchemaVersion < 5) {
                    
                    // populate new code (primary key) property of species
                    migration.enumerateObjects(ofType: Species.className()) { oldObject, newObject in
                        var code = ""
                        
                        if let name = oldObject!["name"] as? String {
                            switch name {
                            case "Possum Master":
                                code = "POS"
                                break
                            case "Rat":
                                code = "RAT"
                                break
                            case "Mouse":
                                code = "NOU"
                                break
                            case "Hedgehog":
                                code = "HED"
                                break
                            default:
                                code = UUID().uuidString
                            }
                        }
                        newObject!["code"] = code
                    }
                }
                
                if (oldSchemaVersion < 6) {
                     migration.enumerateObjects(ofType: Species.className()) { oldObject, newObject in
                        
                        var code = ""
                        
                        if let name = oldObject!["name"] as? String {
                            // Fix the code for Possum species (will be a UUID now)
                            if name == "Possum" {
                                newObject!["code"] = "POS"
                            }
                        }
                                
                    }
                    
                    // populate new code (primary key) property of TrapType
                    migration.enumerateObjects(ofType: TrapType.className()) { oldObject, newObject in
                        
                        var code = ""
                        
                        if let name = oldObject!["name"] as? String {
                            switch name {
                            case "Possum Master":
                                code = "PMA"
                                break
                            case "Pelifeed":
                                code = "PEL"
                                break
                            case "DOC200":
                                code = "D200"
                                break
                            case "Hedgehog":
                                code = "HED"
                                break
                            default:
                                code = UUID().uuidString
                            }
                        }
                        newObject!["code"] = code
                    }
                }
                if (oldSchemaVersion < 10) {
                    // Route model get an Id column
                    migration.enumerateObjects(ofType: Route.className()) { oldObject, newObject in
                        // add a primary key value
                        newObject!["id"] = UUID().uuidString
                    }
                }
                if (oldSchemaVersion < self.CURRENT_SCHEMA_VERSION) {
                }
        })
        return config
        
    }()
}
