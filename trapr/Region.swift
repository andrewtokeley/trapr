//
//  Region.swift
//  trapr
//
//  Created by Andrew Tokeley on 27/05/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

/**
 A region is a geographic area in which traplines are located.
 */
class Region: Object {
    
    convenience init(code: String, name: String) {
        self.init()
        self.code = code
        self.name = name
    }
    
    override static func primaryKey() -> String? {
        return "code"
    }
    
    /**
     The name of the region. e.g. "EHRP" for East Harbour Regional Park
     */
    @objc dynamic var code: String?
    
    /**
     The name of the region. e.g. "East Harbour Regional Park"
     */
    @objc dynamic var name: String?
}
