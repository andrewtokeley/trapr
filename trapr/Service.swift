//
//  Service.swift
//  trapr
//
//  Created by Andrew Tokeley  on 22/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

enum ServiceError: Error {
    case PrimaryKeyViolation
}

class Service {
    
    var realm: Realm!
    var isTestService: Bool {
        var result = false
        if let url = self.realm.configuration.fileURL {
            result = url.lastPathComponent == DataFiles.testFile.rawValue
        }
        return result
    }
    
    init(realm: Realm) {
        self.realm = realm
    }
    
}
