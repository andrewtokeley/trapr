//
//  Visit.swift
//  trapr
//
//  Created by Andrew Tokeley  on 11/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

class Visit: Object {
    
    // Primary key
    dynamic var id: String = UUID().uuidString
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // These are the natural primary keys
    dynamic var trap: Trap?
    dynamic var visitDateTime: Date = Date()
    
    dynamic var lure: Lure?
    dynamic var baitAdded: Int = 0
    dynamic var baitEaten: Int = 0
    dynamic var baitRemoved: Int = 0
    dynamic var catchNumber: Int = 0
    dynamic var catchSpecies: Species?
    dynamic var notes: String?
    
    convenience init(trap: Trap) {
        self.init(trap: trap, date: Date())
    }
    
    convenience init(trap: Trap, date: Date) {
        self.init()
        self.trap = trap
        self.visitDateTime = date
        self.lure = trap.type?.defaultLure
    }
}
