//
//  RouteStatisticsInterface.swift
//  trapr
//
//  Created by Andrew Tokeley on 13/07/20.
//  Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol TrapStatisticsServiceInterface {

    /**
     Retrieve the statistics for the given trap as defined by the *Route*, *Station* and *TrapType*.
     */
    func get(routeId: String, stationId: String, trapTypeId: String, completion: ((TrapStatistics?, Error?) -> Void)?)
    
    /**
     Retrieve the combined statistics across all traps of a given *TrapType* on a *Route*.
     */
    func get(routeId: String, trapTypeId: String, completion: ((TrapStatistics?, Error?) -> Void)?)
    
    
}
