//
//  TrapPosition.swift
//  trapr
//
//  Created by Andrew Tokeley on 28/11/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

//includes; ‘Still Set’, ‘Sprung and Empty’, ‘Still
//Set Bait Eaten’ and ‘Other’.

enum TrapSetStatus: Int {
    case stillSet = 0
    case sprungAndEmpty
    case setBaitEaten
    case trapGone
    case other
    
    var walkTheLineCode: Int {
        switch self {
        case .stillSet: return 1
        case .sprungAndEmpty: return 2
        case .setBaitEaten: return 3
        case .trapGone: return 5
        case .other: return 8
        }
    }
    
    var name: String {
        switch self {
        case .stillSet: return "Still set with Bait"
        case .sprungAndEmpty: return "Sprung and empty"
        case .setBaitEaten: return "Still set, bait eaten"
        case .trapGone: return "Trap gone"
        case .other: return "Other"
        }
    }
    
    static var all: [TrapSetStatus] {
        return [.stillSet, .sprungAndEmpty, .setBaitEaten, .other]
    }
    static var count: Int {
        return all.count
    }
    
//    var statusDescription: String {
//        switch self {
//        case .open: return "The trap is set and functional."
//        case .closed: return "The trap is not currently set but is functional."
//        case .unserviceable: return "the trap is not currently in full functioning order and can also include missing traps. The reason for the unserviceable trap should be recorded in the ‘Comments’ field."
//        }
//    }
}
