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
}
