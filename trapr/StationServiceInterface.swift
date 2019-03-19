//
//  StationServiceInterface.swift
//  trapr
//
//  Created by Andrew Tokeley on 10/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol StationServiceInterface {
    
    func add(station: Station, completion: ((Station?, Error?) -> Void)?)
    func add(stations: [Station], completion: (([Station], Error?) -> Void)?)
    func addTrapTypeToStation(station: Station, trapTypeId: String, completion:  (([Station], Error?) -> Void)?)
    func associateStationWithTrapline(stationId: String, traplineId: String, completion: ((Error?) -> Void)?)
    
    /// Delete selected station
    func delete(stationId: String, completion: ((Error?) -> Void)?)
    
    /// Delete the selected stationIds.
    func delete(stationIds: [String], completion: ((Error?) -> Void)?)
    
    /// Delete every single station in the app
    func deleteAll(completion: ((Error?) -> Void)?)
    
    /**
     Returns a description, through the completion block, for an array of stations. e.g. LW01-11, N01-05 or LW, N if not including station codes.
     
     - parameters:
     - stationIds: the station ids of the stations of interest
     - includeStationCodes: whether to include station codes. If true result might look like LW01-11, N01-05, otherwise simply LW, N.
     - completion: block containing the description with and then without codes or an error.
     */
    func description(stationIds: [String], completion: ((String?, String?, Error?) -> Void)?)
    
    /**
     Returns a description, through the completion block, for an array of stations. e.g. LW01-11, N01-05 or LW, N if not including station codes.
     
     - parameters:
     - stations: the stations of interest
     - includeStationCodes: whether to include station codes. If true result might look like LW01-11, N01-05, otherwise simply LW, N.
     - completion: block containing results or error.
     */
    func description(stations: [Station], includeStationCodes: Bool) -> String
  
    /// Get all stations
    func get(source: FirestoreSource,completion: (([Station]) -> Void)?)
    
    /// Get all stations
    func get(completion: (([Station]) -> Void)?)
    
    /// Get station by id
    func get(stationId: String, completion: ((Station?, Error?) -> Void)?)
    
    /// Get stations by ids
    func get(stationIds: [String], completion: (([Station], Error?) -> Void)?)
    
    /// Get all the stations in the region
    func get(regionId: String, completion: (([Station]) -> Void)?)
    
    /// Get stations on the specified route.
    func get(routeId: String, completion: (([Station]) -> Void)?)
    
    /// Get stations on trapline
    func get(traplineId: String, completion: (([Station]) -> Void)?)
    
    
    func getActiveOrHistoricTraps(route: Route, station: Station, date: Date, completion: (([TrapType]) -> Void)?)
    
    func getStationSequence(fromStationId: String, toStationId: String,  completion: (([Station], Error?) -> Void)?)
    
    /// Return the ids of stations that we would expect to see on this line that are missing
    func getMissingStationIds(trapline: Trapline, completion: (([String]) -> Void)?)
    
    /// Return the ids of stations that we would expect to see across all lines
    func getMissingStationIds(completion: (([String]) -> Void)?)
    
    func getLureBalance(stationId: String, trapTypeId: String, asAtDate: Date, completion: ((Int) -> Void)?)
    
    func isStationCentral(station: Station, completion: ((Bool) -> Void)?)
    
    func removeTrapType(station: Station, trapTypeId: String, completion: ((Station?, Error?) -> Void)?)
    
    func reverseOrder(stations: [Station]) -> [Station]
    
    
    func searchStations(searchTerm: String, regionId: String, completion: (([Station]) -> Void)?)
    
    
    func updateActiveState(station: Station, trapTypeId: String, active: Bool, completion: ((Station?, Error?) -> Void)?)
    
}
