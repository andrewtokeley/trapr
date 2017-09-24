//
//  Service.swift
//  trapr
//
//  Created by Andrew Tokeley  on 22/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

class Service {
    
    var realm: Realm!
    
    init(realm: Realm) {
        self.realm = realm
    }
    
}
