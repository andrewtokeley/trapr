//
//  VisitServiceInterface.swift
//  trapr
//
//  Created by Andrew Tokeley  on 13/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

protocol VisitServiceInterface {
    
    /**
     Record a new Visit
     
     - parameters:
        - visit: the Visit to add to the repository
        - completion: closure with parameters, Visit, Error, where the Visit is a reference to the newly created Visit
     */
    func add(visit: _Visit, completion: ((_Visit?, Error?) -> Void)?)
    
    /**
     Deletes the Visit
     
     - parameters:
        - vist: the visit to delete
        - completion: closure with parameters, Error
     */
    func delete(visit: _Visit, completion: ((Error?) -> Void)?)

    /**
     Deletes all Visits from the data store
     
     - parameters:
        - completion: closure with parameter, Error
     */
    func deleteAll(completion: ((Error?) -> Void)?)
    
    /**
    Delete all visits ever recorded on the given route, regardless of date.
     */
    func delete(routeId: String, completion: ((Error?) -> Void)?)

    /// Delete all visits defined in the visit summary
    func delete(visitSummary: _VisitSummary, completion: ((Error?) -> Void)?)
    
    /// Delete all visits on the given route and day
    func delete(routeId: String, date: Date, completion: ((Error?) -> Void)?)
    
    /// Save a new visit to the data store.
    func save(visit: _Visit, completion: ((_Visit?, Error?) -> Void)?)
    
    /**
     Get a visit record with the given id.
     
     - parameters:
        - id: the id of the Visit. Visit's have a auto-generated id, so you need to have retrieved the visit from the datastore in order to delete it.
        - completion: closure with parameters, Visit and Error
    */
    func get(id: String, completion: ((_Visit?, Error?) -> Void)?)
    
    /**
     Returns whether any visits have been recorded against this trap. Useful in cases where you want to check whether a trap can be deleted
     
     - parameters:
        - stationId: station to check
        - trap: the trap to check
        - completion: block with result
     */
    func hasVisits(stationId: String, trapTypeId: String, completion: ((Bool, Error?) -> Void)?)
    
    /// Get all visits ever created on Route
    func get(routeId: String, completion: (([_Visit], Error?) -> Void)?)
    
    /**
     Gets all Visits recorded on a specific Trapline

     - parameters:
        - date: the date on which Visits were recorded
     
     - returns:
     Array of Visits, or nil if no Visits have been recorded on this date
     */
    func get(recordedOn date: Date, completion: (([_Visit], Error?) -> Void)?)
    
    func get(recordedOn date: Date, routeId: String, completion: (([_Visit], Error?) -> Void)?)
    
    func get(recordedOn date: Date, routeId: String, stationId: String, trapTypeId: String, completion: (([_Visit], Error?) -> Void)?)
    
    /**
     Gets all Visits recorded between the date range
     
     - parameters:
     - dateStart: the start of the date range
     - dateEnd: the end of the date range
     
     - returns:
     Array of Visits, or nil if no Visits have been recorded within the date range
     */
    func get(recordedBetween dateStart: Date, dateEnd: Date, completion: (([_Visit], Error?) -> Void)?)
    
    func get(recordedBetween dateStart: Date, dateEnd: Date, routeId: String, completion: (([_Visit], Error?) -> Void)?)
    
    func get(recordedBetween dateStart: Date, dateEnd: Date, routeId: String, trapTypeId: String, completion: (([_Visit], Error?) -> Void)?)
    
    
    func get(recordedBetween dateStart: Date, dateEnd: Date, stationId: String, trapTypeId: String, completion: (([_Visit], Error?) -> Void)?)
    
    func getMostRecentVisit(routeId: String, completion: ((_Visit?) -> Void)?)
    
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
    
    func add(visit: Visit)
    func delete(visit: Visit)
    func deleteVisits(visitSummary: VisitSummary)
    func getById(id: String) -> Visit?
    func hasVisits(trap: Trap) -> Bool
    func getVisits(route: Route, station: Station) -> [Visit]
    func getVisits(route: Route) -> Results<Visit>?
    func getVisits(recordedOn date: Date) -> Results<Visit>?
    func getVisits(recordedOn date: Date, route: Route) -> Results<Visit>?
    func getVisits(recordedOn date: Date, route: Route, trap: Trap) -> Results<Visit>?
    func getVisits(recordedBetween dateStart: Date, dateEnd: Date) -> Results<Visit>?
    func getVisits(recordedBetween dateStart: Date, dateEnd: Date, route: Route) -> Results<Visit>?
    func getVisits(recordedBetween dateStart: Date, dateEnd: Date, route: Route, trap: Trap) -> Results<Visit>?
    func getVisits(recordedBetween dateStart: Date, dateEnd: Date, trap: Trap) -> Results<Visit>?
    func getVisitSummary(date: Date, route: Route) -> VisitSummary
    func getVisitSummaries(recordedBetween startDate: Date, endDate: Date, includeHidden: Bool) -> [VisitSummary]
    func getVisitSummaries(recordedBetween startDate: Date, endDate: Date, route: Route) -> [VisitSummary]
    func getStatistics(visitSummaries: [VisitSummary]) -> VisitSummariesStatistics?
    func getVisitSummaryMostRecent(route: Route) -> VisitSummary?
    func visitsExistForRoute(route: Route) -> Bool
    func killCounts(monthOffset: Int, route: Route) -> [Species: Int]
    func save(visit: Visit) -> Visit
    func deleteVisits(route: Route)
    func poisonCount(monthOffset: Int, route: Route) -> Int
    func updateDate(visit: Visit, date: Date)

}
