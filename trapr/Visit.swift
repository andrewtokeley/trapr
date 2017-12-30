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
    dynamic var route: Route?
    
    dynamic var trapOperatingStatusRaw: Int = 0
    var trapOperatingStatus: TrapOperatingStatus {
        return TrapOperatingStatus(rawValue: trapOperatingStatusRaw) ?? .open
    }
    
    dynamic var lure: Lure?
    dynamic var baitAdded: Int = 0
    dynamic var baitEaten: Int = 0
    dynamic var baitRemoved: Int = 0
    
    dynamic var trapSetStatusRaw: Int = 0
    var trapSetStatus: TrapSetStatus {
        return TrapSetStatus(rawValue: trapSetStatusRaw) ?? .stillSet
    }
    
    dynamic var catchSpecies: Species?
    dynamic var notes: String?
    
    /**
     Computed property that allows visits to be ordered by Station then Trap order.
     
     For example, LW01_0
     
     Note, realm still won't be able to sort on this as it's not persisted to the database
    */
    var order: String {
        let code = trap?.station?.longCode ?? "_"
        let trapOrder = String(trap?.type?.order ?? 0)
        return "\(code)_\(trapOrder)"
    }
    
    convenience init(date: Date, route: Route, trap: Trap) {
        self.init()
        self.visitDateTime = date
        self.trap = trap
        self.route = route
        self.lure = trap.type?.defaultLure
    }
}
