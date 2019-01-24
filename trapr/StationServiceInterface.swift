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
    
    func add(station: _Station, completion: ((_Station?, Error?) -> Void)?)
    func add(stations: [_Station], completion: (([_Station], Error?) -> Void)?)
    func addTrapTypeToStation(station: _Station, trapTypeId: String, completion:  (([_Station], Error?) -> Void)?)
    func associateStationWithTrapline(stationId: String, traplineId: String, completion: ((Error?) -> Void)?)
    
    func delete(stationId: String, completion: ((Error?) -> Void)?)
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
    func description(stations: [_Station], includeStationCodes: Bool) -> String
    
    func get(source: FirestoreSource,completion: (([_Station]) -> Void)?)
    func get(completion: (([_Station]) -> Void)?)
    func get(stationId: String, completion: ((_Station?, Error?) -> Void)?)
    func get(stationIds: [String], completion: (([_Station], Error?) -> Void)?)
    func get(regionId: String, completion: (([_Station]) -> Void)?)
    func get(routeId: String, completion: (([_Station]) -> Void)?)
    func get(traplineId: String, completion: (([_Station]) -> Void)?)
    
    func getActiveOrHistoricTraps(route: _Route, station: _Station, date: Date, completion: (([_TrapType]) -> Void)?)
    
    func getStationSequence(fromStationId: String, toStationId: String,  completion: (([_Station], Error?) -> Void)?)
    
    func getMissingStations(completion: (([String]) -> Void)?)
    
    func getLureBalance(stationId: String, trapTypeId: String, asAtDate: Date, completion: ((Int) -> Void)?)
    
    func isStationCentral(station: _Station, completion: ((Bool) -> Void)?)
    
    func removeTrapType(station: _Station, trapTypeId: String, completion: ((_Station?, Error?) -> Void)?)
    
    func reverseOrder(stations: [_Station]) -> [_Station]
    
    
    func searchStations(searchTerm: String, regionId: String, completion: (([_Station]) -> Void)?)
    
    
    func updateActiveState(station: _Station, trapTypeId: String, active: Bool, completion: ((_Station?, Error?) -> Void)?)
    
}
