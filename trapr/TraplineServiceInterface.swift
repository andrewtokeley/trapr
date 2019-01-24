//
//  TraplineServiceInterface.swift
//  trapr
//
//  Created by Andrew Tokeley  on 17/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol TraplineServiceInterface {
    
    func add(trapline: _Trapline, completion: ((_Trapline?, Error?) -> Void)?) -> String
    func addStation(trapline: _Trapline, station: _Station, completion: ((Error?) -> Void)?)
    func addTrap(station: _Station, trap: _TrapType, completion: ((Error?) -> Void)?)
    func delete(trapline: _Trapline, completion: ((Error?) -> Void)?)
    func deleteAll(completion: ((Error?) -> Void)?)
    func extractTraplineReferencesFromStations(stations: [_Station]) -> [String]
    func extractTraplineCodesFromStations(stations: [_Station]) -> [String]
    func get(stations: [_Station], completion: (([_Trapline], Error?) -> Void)?)
    func get(traplineId: String, completion: ((_Trapline?, Error?) -> Void)?)
    func get(completion: (([_Trapline]) -> Void)?)
    func get(source: FirestoreSource, completion: (([_Trapline]) -> Void)?)
    func get(regionId: String, completion: (([_Trapline]) -> Void)?)
    //func get(traplineCode: String, completion: ((_Trapline?) -> Void)?)
    func get(regionId: String, traplineCode: String, completion: ((_Trapline?) -> Void)?)
    func getRecentTraplines(completion: (([_Trapline]) -> Void)?)
    
    
}
