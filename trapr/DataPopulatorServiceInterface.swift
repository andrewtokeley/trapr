//
//  DataPopulatorInterface.swift
//  trapr
//
//  Created by Andrew Tokeley  on 23/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol DataPopulatorServiceInterface: RealmServiceInterface {
    
    /**
     This method should be called whenever the apps starts to ensure all the lookup data is present. It is non-destructive.
     */
    func createOrUpdateLookupData()
    
    /**
     This method will delete everything, then import the latest embedded Trap/Visit data.
    */
    func resetAllData()
    
    /**
     This method merges the latest embedded Trap/Visit data into the app. It does not remove existing data but will update existing traps/visits with new property values, if required.
     */
    func mergeWithV1Data()
    
    func mergeWithV1Data(progress: ((Float) -> Void)?, completion: ((ImportSummary) -> Void)?)
    
    /**
     This method will delete everything, then import some random test data
     */
    func replaceAllDataWithTestData()

    /**
     Test method that creates a test trapline - useful for unit testing, not intended to be used by app
    */
    func createTrapline(code: String, numberOfStations: Int) -> Trapline

    /**
     Test method that creates a test trapline - useful for unit testing, not intended to be used by app
     */
    func createTrapline(code: String, numberOfStations: Int, numberOfTrapsPerStation: Int) -> Trapline
    
    /**
     Test method that creates a test visit - useful for unit testing, not intended to be used by app
     */
    func createVisit(_ added: Int, _ removed: Int, _ eaten: Int, _ date: Date, _ route: Route, _ trap: Trap)
}
