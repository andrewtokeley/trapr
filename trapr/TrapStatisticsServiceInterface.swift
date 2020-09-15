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
    func getTrapStatistics(routeId: String, stationId: String, trapTypeId: String, completion: ((TrapStatistics?, Error?) -> Void)?)
    
    /**
     Retrieve all *TrapStatistic* records on a route for a given *TrapType*. The result is a dictionary where the key is the station code (i.e. LW01) and the value is the trap statistic for the trap at that station of the given *TrapType*.
     */
    func getTrapStatistics(routeId: String, trapTypeId: String?, completion: (([String: TrapStatistics], Error?) -> Void)?)
        
    /**
     Retrieve *TrapStatistics* records for each station on a route. Results are aggregated across all traps at each station.
     */
    func getTrapStatistics(routeId: String, completion: (([String: TrapStatistics], Error?) -> Void)?)
    
}
