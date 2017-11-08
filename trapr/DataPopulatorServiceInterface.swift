//
//  DataPopulatorInterface.swift
//  trapr
//
//  Created by Andrew Tokeley  on 23/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol DataPopulatorServiceInterface: ServiceInterface {
    
    func replaceAllDataWithTestData()
    
    func deleteAllData()
    
    func addLookupData()
    
    func createTrapline(code: String, numberOfStations: Int) -> Trapline
}
