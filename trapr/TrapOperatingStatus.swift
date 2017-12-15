//
//  TrapStatus.swift
//  trapr
//
//  Created by Andrew Tokeley on 28/11/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

enum TrapOperatingStatus: Int {
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
    
    static var all: [TrapOperatingStatus] {
        return [.open, .closed, .unserviceable]
    }
    static var count: Int {
        return all.count
    }
    
    var statusDescription: String {
        switch self {
        case .open: return "The trap is set and functional."
        case .closed: return "The trap is not currently set but is functional."
        case .unserviceable: return "The trap is not currently in full functioning order and can also include missing traps. The reason for the unserviceable trap should be recorded in the ‘Comments’ field."
        }
    }
}
