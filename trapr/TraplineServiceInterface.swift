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
    
    func add(trapline: Trapline, completion: ((Trapline?, Error?) -> Void)?) -> String
    //func addStation(trapline: Trapline, station: Station, completion: ((Error?) -> Void)?)
    //func addTrap(station: Station, trap: TrapType, completion: ((Error?) -> Void)?)
    
    func delete(trapline: Trapline, completion: ((Error?) -> Void)?)
    
    /// Delete the trapline
    func delete(traplineId: String, completion: ((Error?) -> Void)?)
    
    /// Delete all the selected traplines
    func delete(traplineIds: [String], completion: ((Error?) -> Void)?)
    
    func deleteAll(completion: ((Error?) -> Void)?)
    func extractTraplineReferencesFromStations(stations: [Station]) -> [String]
    func extractTraplineCodesFromStations(stations: [Station]) -> [String]
    func get(stations: [Station], completion: (([Trapline], Error?) -> Void)?)
    func get(traplineId: String, completion: ((Trapline?, Error?) -> Void)?)
    func get(completion: (([Trapline]) -> Void)?)
    func get(source: FirestoreSource, completion: (([Trapline]) -> Void)?)
    func get(regionId: String, completion: (([Trapline]) -> Void)?)
    //func get(traplineCode: String, completion: ((Trapline?) -> Void)?)
    func get(regionId: String, traplineCode: String, completion: ((Trapline?) -> Void)?)
    func getRecentTraplines(completion: (([Trapline]) -> Void)?)
    
    
}
