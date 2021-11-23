//
//  TrapPosition.swift
//  trapr
//
//  Created by Andrew Tokeley on 28/11/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

enum TrapSetStatus: Int {
    /// Still set with bait
    case stillSet = 0
    /// Sprung and bait gone
    case sprungAndEmpty
    /// Still set and the bait gone
    case setBaitEaten
    /// Where's the trap?!
    case trapGone
    /// Something else,
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
        return [.stillSet, .sprungAndEmpty, .setBaitEaten, .trapGone, .other]
    }
    
    /// Returns the default TrapSetStatus for a given trap.
    static func defaultForTrapType(type: TrapTypeCode) -> TrapSetStatus {
        switch type {
        case .doc200:
            return .stillSet
        case .possumMaster:
            return .setBaitEaten
        case .timms:
            return .stillSet
        case .sa4:
            return .stillSet
        default:
            return .stillSet
        }
    }
    
    static func validForVisit(balance: Int, eaten: Int, removed: Int) -> [TrapSetStatus] {
        
        let hasPositiveBalance = balance > 0
        let hasEaten = eaten > 0
        let hasRemoved = removed > 0
        
        if (hasEaten && !hasRemoved) {
            // the bait was eaten so could only have been...
            return [.sprungAndEmpty, .setBaitEaten, .other]
        } else if (!hasEaten && hasRemoved) {
            // you removed mouldy bait so could only have been...
            return [.stillSet, .other]
        } else if (!hasEaten && !hasRemoved && hasPositiveBalance) {
            // you didn't remove anything but there was a bait balance
            return [.stillSet, .trapGone, .other]
        } else if (hasEaten && hasRemoved) {
            // the UI should prevent this from happening since we only call this for single bait traps.
            return []
        }
        
        // in all other cases just assume it's OK for now!
        return all
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
