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
    
    func getLureBalance(stationId: String, trapTypeId: String, asAtDate: Date, completion: ((Int) -> Void)?)
    
    func updateActiveState(station: _Station, trapTypeId: String, active: Bool, completion: ((_Station?, Error?) -> Void)?)
    func removeTrapType(station: _Station, trapTypeId: String, completion: ((_Station?, Error?) -> Void)?)
    func add(station: _Station, completion: ((_Station?, Error?) -> Void)?)
    func add(stations: [_Station], completion: (([_Station], Error?) -> Void)?)
    func addTrapTypeToStation(station: _Station, trapTypeId: String, completion:  (([_Station], Error?) -> Void)?)
    func associateStationWithTrapline(stationId: String, traplineId: String, completion: ((Error?) -> Void)?)
    func get(source: FirestoreSource,completion: (([_Station]) -> Void)?)
    func get(completion: (([_Station]) -> Void)?)
    func get(stationId: String, completion: ((_Station?, Error?) -> Void)?)
    func get(stationIds: [String], completion: (([_Station], Error?) -> Void)?)
    func get(regionId: String, completion: (([_Station]) -> Void)?)
    func get(routeId: String, completion: (([_Station]) -> Void)?)
    func get(traplineId: String, completion: (([_Station]) -> Void)?)
    
    func searchStations(searchTerm: String, regionId: String, completion: (([_Station]) -> Void)?)
    
    func delete(stationId: String, completion: ((Error?) -> Void)?)
    func deleteAll(completion: ((Error?) -> Void)?)
    func reverseOrder(stations: [_Station]) -> [_Station]
    func isStationCentral(station: _Station, completion: ((Bool) -> Void)?)
    func getStationSequence(fromStationId: String, toStationId: String,  completion: (([_Station], Error?) -> Void)?)
    func getActiveOrHistoricTraps(route: _Route, station: _Station, date: Date, completion: (([_TrapType]) -> Void)?)
    func getMissingStations(completion: (([String]) -> Void)?)
    
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
    
    // To be deprecated
    func delete(station: Station)
    func searchStations(searchTerm: String, region: Region?) -> [Station]
    func getAll() -> [Station]
    func getAll(region: Region?) -> [Station]
    func getDescription(stations: [Station], includeStationCodes: Bool) -> String
    func reverseOrder(stations: [Station]) -> [Station]
    func isStationCentral(station: Station) -> Bool
    func getStationSequence(_ from: Station, _ to:Station) -> [Station]?
    
    /**
     Return all the station's traps (on the route) which are not archived or are archived but have a visit recorded for them on the specified date
     */
    func getActiveOrHistoricTraps(route: Route, station: Station, date: Date) -> [Trap]
    
    /**
    Returns any missing Stations based on the station code, which is assummed to be sequenctial on it's trapline. The function returns an array of Station long descriptions, for example, AB04.
    */
    func getMissingStations() -> [String]
    
}
