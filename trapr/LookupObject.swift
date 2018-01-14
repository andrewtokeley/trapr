//
//  LookupObject.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/11/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

class LookupObject: Object {
    
    override static func primaryKey() -> String? {
        return "code"
    }
    
    @objc dynamic var code: String?
    @objc dynamic var name: String?
    @objc dynamic var order: Int = 0
    
    convenience init(code: String, name: String, order: Int) {
        self.init()
        self.code = code
        self.name = name
        self.order = order
    }
}
