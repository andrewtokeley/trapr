//
//  Visit.swift
//  trapr
//
//  Created by Andrew Tokeley  on 11/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

enum TrapStatus: Int {
    case open = 0
    case closed
    case unserviceable
    
    var name: String {
        switch self {
        case .open: return "Open"
        case .closed: return "Closed"
        case .unserviceable: return "Unserviceable"
        }
    }
    
    static var all: [TrapStatus] {
        return [.open, .closed, .unserviceable]
    }
    static var count: Int {
        return all.count
    }
    
    var statusDescription: String {
        switch self {
        case .open: return "The trap is set and functional."
        case .closed: return "The trap is not currently set but is functional."
        case .unserviceable: return "the trap is not currently in full functioning order and can also include missing traps. The reason for the unserviceable trap should be recorded in the ‘Comments’ field."
        }
    }
}

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
    
    dynamic var trapStatusRaw: Int = 0
    var trapStatus: TrapStatus {
        return TrapStatus(rawValue: trapStatusRaw) ?? .open
    }
    
    dynamic var lure: Lure?
    dynamic var baitAdded: Int = 0
    dynamic var baitEaten: Int = 0
    dynamic var baitRemoved: Int = 0
    dynamic var catchSpecies: Species?
    dynamic var notes: String?
    
    convenience init(date: Date, route: Route, trap: Trap) {
        self.init()
        self.visitDateTime = date
        self.trap = trap
        self.route = route
        self.lure = trap.type?.defaultLure
    }
}
