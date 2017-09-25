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
    dynamic var baitAdded: Int = 0
    dynamic var baitEaten: Int = 0
    dynamic var baitRemoved: Int = 0
    dynamic var catchNumber: Int = 0
    dynamic var notes: String?
    dynamic var visitDateTime: Date = Date()
    dynamic var catchSpecies: Species?
    dynamic var trap: Trap?
    
    convenience init(trap: Trap) {
        self.init(trap: trap, date: Date())
    }
    
    convenience init(trap: Trap, date: Date) {
        self.init()
        self.trap = trap
        self.visitDateTime = date
    }
}
