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
    func mergeAllRealmDataToServer(completion: ((String, Double, Error?) -> Void)?)
    
    /**
     Add a specific instance of traline and stations to store. Only intended to be used for testing.
     */
    func createTraplineWithStations(trapline: _Trapline, stations: [_Station], completion: ((Error?) -> Void)?)
    
    /**
     Test method that creates a test trapline. Only intended to be used for testing.
     */
    func createTrapline(code: String, numberOfStations: Int, numberOfTrapsPerStation: Int, completion: ((_Trapline?) -> Void)?)
    
    /**
     This method should be called whenever the apps starts to ensure all the lookup data is present. It is non-destructive.
     */
    //func createOrUpdateLookupData()
    
    //func createOrUpdateLookupData(completion: (() -> Void)?)
    
    /**
     This method will delete everything, then import the latest embedded Trap/Visit data.
     */
    //func resetAllData()
    
    
    /**
     This method merges the latest embedded Trap/Visit data into the app. It does not remove existing data but will update existing traps/visits with new property values, if required.
     */
    //func mergeWithV1Data()
    
    //func mergeWithV1Data(progress: ((Float) -> Void)?, completion: ((ImportSummary) -> Void)?)
    
    /**
     Merges the data stored in the app's embedded CSV file into the remote Firestore database.
     */
    //func mergeDataFromCSVToDatastore(progress: ((Float) -> Void)?, completion: ((ImportSummary) -> Void)?)
    
    /**
     Delete all data from the datastore and then adds all default lookup data
     
     - parameters:
        - completion: this block is called when the datastore has been restored
     */
    //func restoreDatabase(completion: (() -> Void)?)
    
    /**
     Delete all data from the datastore and then adds all default lookup data
     */
    //func restoreDatabase()
    
    /**
     Test method that creates a test trapline - useful for unit testing, not intended to be used by app
    */
    //func createTrapline(code: String, numberOfStations: Int) -> Trapline

    
    
    
    //func createTrapline(code: String, numberOfStations: Int, numberOfTrapsPerStation: Int) -> Trapline
    

    /**
     Test method that creates a test visit - useful for unit testing, not intended to be used by app
     */
    //func createVisit(_ added: Int, _ removed: Int, _ eaten: Int, _ date: Date, _ route: Route, _ trap: Trap)
}
