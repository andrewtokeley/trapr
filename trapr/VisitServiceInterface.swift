//
//  VisitServiceInterface.swift
//  trapr
//
//  Created by Andrew Tokeley  on 13/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol VisitServiceInterface {
    
    /**
    */
    func extend(visit: Visit, completion: ((VisitEx?) -> Void)?)

    /**
     Record a new Visit
     
     - parameters:
        - visit: the Visit to add to the repository
        - completion: closure with parameters, Visit, Error, where the Visit is a reference to the newly created Visit
     */
    func add(visit: Visit, completion: ((Visit?, Error?) -> Void)?)
    
    /**
     Deletes the Visit
     
     - parameters:
        - vist: the visit to delete
        - completion: closure with parameters, Error
     */
    func delete(visit: Visit, completion: ((Error?) -> Void)?)

    /**
     Deletes all Visits on all routes the current user has access to.
     
     - parameters:
        - completion: closure with parameter, Error
     */
    func deleteAll(completion: ((Error?) -> Void)?)
    
    /**
    Delete all visits ever recorded on the given route, regardless of date and user.
     */
    func delete(routeId: String, completion: ((Error?) -> Void)?)

    /// Delete all visits defined in the visit summary
    func delete(visitSummary: VisitSummary, completion: ((Error?) -> Void)?)
    
    /// Delete all visits on the given route and day
    func delete(routeId: String, date: Date, completion: ((Error?) -> Void)?)
    
    /// Save a new visit to the data store.
    func save(visit: Visit, completion: ((Visit?, Error?) -> Void)?)
    
    /// Gets all visit records for routes the logged in user has access to. Note this is intended to be used only to prime the cache and get records from the server.
    func get(source: FirestoreSource, completion: (([Visit]) -> Void)?)

    /**
     Get a visit record with the given id. There is not check here to see if the user has access to the route the visit was made on.
     
     - parameters:
        - id: the id of the Visit. Visit's have a auto-generated id, so you need to have retrieved the visit from the datastore in order to delete it.
        - completion: closure with parameters, Visit and Error
    */
    func get(id: String, completion: ((Visit?, Error?) -> Void)?)
    
    
    /**
     Returns whether any visits have been recorded against this trap. Useful in cases where you want to check whether a trap can be deleted
     
     - parameters:
        - stationId: station to check
        - trap: the trap to check
        - completion: block with result
     */
    func hasVisits(stationId: String, trapTypeId: String, completion: ((Bool, Error?) -> Void)?)
    
    /// Get all visits created on Route, whether they were created by the current user or not
    func get(routeId: String, completion: (([Visit], Error?) -> Void)?)
    
    /**
     Gets all Visits recorded on a specific Trapline

     - parameters:
        - date: the date on which Visits were recorded
     
     - returns:
     Array of Visits, or nil if no Visits have been recorded on this date
     */
    func get(recordedOn date: Date, completion: (([Visit], Error?) -> Void)?)
    
    func get(recordedOn date: Date, routeId: String, completion: (([Visit], Error?) -> Void)?)
    
    func get(recordedOn date: Date, routeId: String, stationId: String, trapTypeId: String, completion: (([Visit], Error?) -> Void)?)
    
    /**
     Gets all Visits recorded between the date range
     
     - parameters:
     - dateStart: the start of the date range
     - dateEnd: the end of the date range
     
     - returns:
     Array of Visits, or nil if no Visits have been recorded within the date range
     */
    func get(recordedBetween dateStart: Date, dateEnd: Date, completion: (([Visit], Error?) -> Void)?)
    
    func get(recordedBetween dateStart: Date, dateEnd: Date, routeId: String, completion: (([Visit], Error?) -> Void)?)
    
    func get(recordedBetween dateStart: Date, dateEnd: Date, routeId: String, trapTypeId: String, completion: (([Visit], Error?) -> Void)?)
    
    
    func get(recordedBetween dateStart: Date, dateEnd: Date, stationId: String, trapTypeId: String, completion: (([Visit], Error?) -> Void)?)
    
    func getMostRecentVisit(routeId: String, completion: ((Visit?) -> Void)?)
    
    /**
     Get a summary of the visits recorded on the specified day
     
     - parameters:
     - date: Visits on this date will be considered
     - route: Route
     
     - returns:
     A VisitSummary object, or nil if no Visits have been recorded on date
     */
    //func getSummary(date: Date, routeId: String, completion: ((VisitSummary?, Error?) -> Void)?)
    
    /**
     Get a summary of each visit recorded on any day in the date range
     
     - parameters:
        - startDate: Visits from and including this date will be returned
        - endDate: Visits up to and including this date will be returned
        - isHidden: Whether to return hidden routes
     - returns:
     Array of VisitSummary objects, or nil if no Visits have been recorded between the date range
     */
    //func getSummaries(recordedBetween startDate: Date, endDate: Date, includeHidden: Bool, completion: (([VisitSummary], Error?) -> Void)?)
    
    /**
     Get a summary of the visits recorded on a route within a given date range
     
     - parameters:
     - startDate: Visits from and including this date will be returned
     - endDate: Visits up to and including this date will be returned
     - route: the Route to search for visits
     - returns:
     Array of VisitSummary objects
     */
    //func getSummaries(recordedBetween startDate: Date, endDate: Date, routeId: String, completion: (([VisitSummary], Error?) -> Void)?)
    
    /**
     Return a selection of statistical summaries across a set of VisitSummary instances
    */
    //func getStatistics(visitSummaries: [VisitSummary], completion: ((VisitSummariesStatistics?, Error?) -> Void)?)
    
    /**
    Returns a summary of the most recent visits for a given Route
    */
    //func getSummaryMostRecent(routeId: String, completion: ((VisitSummary?, Error?) -> Void)?)
    
    
    func visitsExistForRoute(routeId: String, completion: ((Bool, Error?) -> Void)?)
    func killCounts(monthOffset: Int, routeId: String, completion: (([String: Int]) -> Void)?)
    func poisonCount(monthOffset: Int, routeId: String, completion: ((Int) -> Void)?)
    func updateDate(visitId: String, date: Date, completion: ((Error?) -> Void)?)
    
}
