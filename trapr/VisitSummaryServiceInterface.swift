//
//  VisitSummaryServiceInterface.swift
//  trapr
//
//  Created by Andrew Tokeley on 15/11/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol VisitSummaryServiceInterface {
    
    func createNewVisitSummary(date: Date, routeId: String, completion: ((_VisitSummary?, Error?) -> Void)?)
    
    /**
    Get a summary of the visits recorded on the specified day
    
    - parameters:
        - date: Visits on this date will be considered
        - routeId: id of the route the visits we recorded on
        - completion: closure through which results of the request are passed
    
    - returns:
    A VisitSummary object, or nil if no Visits have been recorded on date
    */
    func get(date: Date, routeId: String, completion: ((_VisitSummary?, Error?) -> Void)?)
    
    func get(recordedBetween startDate: Date, endDate: Date, routeId: String, completion: (([_VisitSummary], Error?) -> Void)?)
    
    func get(mostRecentOn routeId: String, completion: ((_VisitSummary?, Error?) -> Void)?)

    func getStatistics(from visitSummaries: [_VisitSummary], completion: ((VisitSummariesStatistics?, Error?) -> Void)?)
}

