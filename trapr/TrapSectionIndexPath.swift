//
//  TrapSectionIndexPath.swift
//  trapr
//
//  Created by Andrew Tokeley  on 24/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

/**
 Index path to a specific trap within an array of traplines
 */
class TrapIndexPath {
    
    var traplineIndex: Int
    var stationIndex: Int
    var trapIndex: Int
    
    init (traplineIndex: Int, stationIndex: Int, trapIndex: Int) {
        self.traplineIndex = traplineIndex
        self.stationIndex = stationIndex
        self.trapIndex = trapIndex
    }
    
}
