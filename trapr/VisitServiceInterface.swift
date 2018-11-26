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
     */
    func add(visit: Visit)
    func add(visit: _Visit, completion: ((_Visit?, Error?) -> Void)?)
    
    func delete(visit: Visit)
    func delete(visit: _Visit, completion: ((Error?) -> Void)?)

    func deleteAll(completion: ((Error?) -> Void)?)
    
    /**
     Delete all visits for a particular route.
    */
    func deleteVisits(route: Route)
    
    /**
    Delete all visits for the given route.
     */
    func delete(visitsOn routeId: String, completion: ((Error?) -> Void)?)
    
    func deleteVisits(visitSummary: VisitSummary)
    func delete(visitSummary: VisitSummary, completion: ((Error?) -> Void)?)
    
    func save(visit: Visit) -> Visit
    func save(visit: _Visit, completion: ((_Visit?, Error?) -> Void)?)
    
    func getById(id: String) -> Visit?
    func get(id: String, completion: ((_Visit?, Error?) -> Void)?)
    
    /**
     Returns whether any visits have been recorded against this trap. Useful in cases where you want to check whether a trap can be deleted
     
     - parameters:
     - trap: the trap to check
     
     - returns:
     True if visits exists, otherwise false
     */
    func hasVisits(trap: Trap) -> Bool
    func hasVisits(stationId: String, trapTypeId: String, completion: ((Bool, Error?) -> Void)?)
    
    func getVisits(route: Route, station: Station) -> [Visit]
    
    func getVisits(route: Route) -> Results<Visit>?
    func get(routeId: String, completion: (([_Visit], Error?) -> Void)?)
    
    /**
     Gets all Visits recorded on a specific Trapline

     - parameters:
        - date: the date on which Visits were recorded
     
     - returns:
     Array of Visits, or nil if no Visits have been recorded on this date
     */
    func getVisits(recordedOn date: Date) -> Results<Visit>?
    func get(recordedOn date: Date, completion: (([_Visit], Error?) -> Void)?)
    
    func getVisits(recordedOn date: Date, route: Route) -> Results<Visit>?
    func get(recordedOn date: Date, routeId: String, completion: (([_Visit], Error?) -> Void)?)
    
    func getVisits(recordedOn date: Date, route: Route, trap: Trap) -> Results<Visit>?
    func get(recordedOn date: Date, routeId: String, trapTypeId: String, completion: (([_Visit], Error?) -> Void)?)
    
    /**
     Gets all Visits recorded between the date range
     
     - parameters:
     - dateStart: the start of the date range
     - dateEnd: the end of the date range
     
     - returns:
     Array of Visits, or nil if no Visits have been recorded within the date range
     */
    func getVisits(recordedBetween dateStart: Date, dateEnd: Date) -> Results<Visit>?
    func get(recordedBetween dateStart: Date, dateEnd: Date, completion: (([_Visit], Error?) -> Void)?)
    
    func getVisits(recordedBetween dateStart: Date, dateEnd: Date, route: Route) -> Results<Visit>?
    func get(recordedBetween dateStart: Date, dateEnd: Date, routeId: String, completion: (([_Visit], Error?) -> Void)?)
    
    func getVisits(recordedBetween dateStart: Date, dateEnd: Date, route: Route, trap: Trap) -> Results<Visit>?
    func get(recordedBetween dateStart: Date, dateEnd: Date, routeId: String, trapTypeId: String, completion: (([_Visit], Error?) -> Void)?)
    
    func getVisits(recordedBetween dateStart: Date, dateEnd: Date, trap: Trap) -> Results<Visit>?
    func get(recordedBetween dateStart: Date, dateEnd: Date, trapTypeId: String, completion: (([_Visit], Error?) -> Void)?)
    
    /**
     Get a summary of the visits recorded on the specified day
     
     - parameters:
     - date: Visits on this date will be considered
     - route: Route
     
     - returns:
     A VisitSummary object, or nil if no Visits have been recorded on date
     */
    func getVisitSummary(date: Date, route: Route) -> VisitSummary
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
    func getVisitSummaries(recordedBetween startDate: Date, endDate: Date, includeHidden: Bool) -> [VisitSummary]
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
    func getVisitSummaries(recordedBetween startDate: Date, endDate: Date, route: Route) -> [VisitSummary]
    //func getSummaries(recordedBetween startDate: Date, endDate: Date, routeId: String, completion: (([VisitSummary], Error?) -> Void)?)
    
    /**
     Return a selection of statistical summaries across a set of VisitSummary instances
    */
    func getStatistics(visitSummaries: [VisitSummary]) -> VisitSummariesStatistics?
    //func getStatistics(visitSummaries: [VisitSummary], completion: ((VisitSummariesStatistics?, Error?) -> Void)?)
    
    /**
    Returns a summary of the most recent visits for a given Route
    */
    func getVisitSummaryMostRecent(route: Route) -> VisitSummary?
    //func getSummaryMostRecent(routeId: String, completion: ((VisitSummary?, Error?) -> Void)?)
    
    func visitsExistForRoute(route: Route) -> Bool
    func visitsExistForRoute(routeId: String, completion: ((Bool, Error?) -> Void)?)
    
    func killCounts(monthOffset: Int, route: Route) -> [Species: Int]
    func killCounts(monthOffset: Int, route: Route, completion: (([Species: Int]) -> Void)?)
    
    func poisonCount(monthOffset: Int, route: Route) -> Int
    func poisonCount(monthOffset: Int, route: Route, completion: ((Int) -> Void)?)
    
    func updateDate(visit: Visit, date: Date)
    func updateDate(visitId: String, date: Date, completion: ((Error?) -> Void)?)
    
}
