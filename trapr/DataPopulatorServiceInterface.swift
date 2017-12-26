//
//  DataPopulatorInterface.swift
//  trapr
//
//  Created by Andrew Tokeley  on 23/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol DataPopulatorServiceInterface: RealmServiceInterface {
    
    func replaceAllDataWithTestData()
    
    func deleteAllTestData()
    
    func createTrapline(code: String, numberOfStations: Int) -> Trapline
    func createTrapline(code: String, numberOfStations: Int, numberOfTrapsPerStation: Int) -> Trapline
    
    func mergeWithV1Data()
    
    func createVisit(_ added: Int, _ removed: Int, _ eaten: Int, _ date: Date, _ route: Route, _ trap: Trap)
}
