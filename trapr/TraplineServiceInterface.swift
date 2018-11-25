//
//  TraplineServiceInterface.swift
//  trapr
//
//  Created by Andrew Tokeley  on 17/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

protocol TraplineServiceInterface {
    
    func add(trapline: _Trapline, completion: ((_Trapline?, Error?) -> Void)?) -> String
    func addStation(trapline: _Trapline, station: _Station, completion: ((Error?) -> Void)?)
    func addTrap(station: _Station, trap: _TrapType, completion: ((Error?) -> Void)?)
    func delete(trapline: _Trapline, completion: ((Error?) -> Void)?)
    func deleteAll(completion: ((Error?) -> Void)?)
    func get(completion: (([_Trapline]) -> Void)?)
    func get(regionId: String, completion: (([_Trapline]) -> Void)?)
    //func get(traplineCode: String, completion: ((_Trapline?) -> Void)?)
    func get(regionId: String, traplineCode: String, completion: ((_Trapline?) -> Void)?)
    func getRecentTraplines(completion: (([_Trapline]) -> Void)?)
    func extractTraplineReferencesFromStations(stations: [_Station]) -> [String]
    func extractTraplineCodesFromStations(stations: [_Station]) -> [String]
    
    //MARK: - to be removed
    
    func add(trapline: Trapline) throws
    func addStation(trapline: Trapline, station: Station)
    func addTrap(station: Station, trap: Trap)
    func delete(trapline: Trapline)
    func getTraplines() -> [Trapline]?
    func getTraplines(from stations: [Station]) -> [Trapline] 
    func getTraplines(region: Region) -> [Trapline]?
    func getTrapline(region: Region, code: String) -> Trapline?
    func getTrapline(code: String) -> Trapline?
    func getRecentTraplines() -> [Trapline]?
    
}
