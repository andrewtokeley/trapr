//
//  StationServiceInterface.swift
//  trapr
//
//  Created by Andrew Tokeley on 10/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol StationServiceInterface {
    
    func getAll() -> [Station] 
    func getTraplines(from stations: [Station]) -> [Trapline]
    func getDescription(stations: [Station], includeStationCodes: Bool) -> String
    func reverseOrder(stations: [Station]) -> [Station]
    func isStationCentral(station: Station) -> Bool
    func getStationSequence(_ from: Station, _ to:Station) -> [Station]?
    
    /**
    Returns any missing Stations based on the station code, which is assummed to be sequenctial on it's trapline. The function returns an array of Station long descriptions, for example, AB04.
    */
    func getMissingStations() -> [String]
    
}
