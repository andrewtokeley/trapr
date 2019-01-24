//
//  DataPopulatorInterface.swift
//  trapr
//
//  Created by Andrew Tokeley  on 23/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol DataPopulatorServiceInterface {
    
    /**
     Merges all Trapline data, including, Regions, Traplines, Stations, Traps, Routes and Visits. It will not merge any lookup data.
     
     - parameters:
        - completion: block called during processing. Block is passed, progress update text (String), progress percentage complete (Double) and and Errors.
     
     - remarks:
     This method is idempotent and can be run multiple times with no risk of duplicating data on the server
     */
    //func mergeAllRealmDataToServer(completion: ((String, Double, Error?) -> Void)?)
    
    /**
     Add a specific instance of traline and stations to store. Only intended to be used for testing.
     */
    func createTraplineWithStations(trapline: _Trapline, stations: [_Station], completion: ((Error?) -> Void)?)
    
    /**
     Test method that creates a test trapline. Only intended to be used for testing.
     */
    func createTrapline(code: String, numberOfStations: Int, numberOfTrapsPerStation: Int, completion: ((_Trapline?) -> Void)?)
    
}
