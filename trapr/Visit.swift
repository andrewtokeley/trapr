//
//  Visit.swift
//  trapr
//
//  Created by Andrew Tokeley  on 11/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

class Visit {
    var baitAdded: Int = 0
    var baitEaten: Int = 0
    var baitRemoved: Int = 0
    var catchNumber: Int = 0
    var notes: String?
    var visitDateTime: Date?
    var catchSpecies: Species?
    var trap: Trap?
}
