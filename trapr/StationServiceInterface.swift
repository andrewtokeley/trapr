//
//  StationServiceInterface.swift
//  trapr
//
//  Created by Andrew Tokeley on 10/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol StationServiceInterface {
    
    func add(station: _Station, completion: ((_Station?, Error?) -> Void)?)
    func add(stations: [_Station], completion: (([_Station], Error?) -> Void)?)
    
    func associateStationWithTrapline(stationId: String, traplineId: String, completion: ((Error?) -> Void)?)
    
    func get(completion: (([_Station]) -> Void)?)
    func get(regionId: String, completion: (([_Station]) -> Void)?)
    func get(routeId: String, completion: (([_Station]) -> Void)?)
    func get(traplineId: String, completion: (([_Station]) -> Void)?)
    
    func searchStations(searchTerm: String, regionId: String, completion: (([_Station]) -> Void)?)
    
    func delete(stationId: String, completion: ((Error?) -> Void)?)
    func deleteAll(completion: ((Error?) -> Void)?)
    
    func describe(stations: [_Station], includeStationCodes: Bool, completion: ((String) -> Void)?)
    func reverseOrder(stations: [_Station]) -> [_Station]
    func isStationCentral(station: _Station, completion: ((Bool) -> Void)?)
    func getStationSequence(_ from: _Station, _ to:_Station,  completion: (([_Station]?) -> Void)?)
    func getActiveOrHistoricTraps(route: _Route, station: _Station, date: Date, completion: (([_TrapType]?) -> Void)?)
    func getMissingStations(completion: (([String]) -> Void)?)
    func getDescription(stations: [_Station], includeStationCodes: Bool) -> String
    
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
