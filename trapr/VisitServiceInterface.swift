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
    
    /**
     Gets all Visits recorded on a specific Trapline

     - parameters:
        - date: the date on which Visits were recorded
     
     - returns:
     Array of Visits, or nil if no Visits have been recorded on this date
     */
    func getVisits(recordedOn date: Date) -> Results<Visit>
    
    /**
     Gets all Visits recorded between the date range
     
     - parameters:
     - dateStart: the start of the date range
     - dateEnd: the end of the date range
     
     - returns:
     Array of Visits, or nil if no Visits have been recorded within the date range
     */
    func getVisits(recordedBetween dateStart: Date, dateEnd: Date) -> Results<Visit>
    
    
    /**
     Get a summary of the visits recorded on the specified day
     
     - parameters:
     - date: Visits on this date will be considered
     
     - returns:
     A VisitSummary object, or nil if no Visits have been recorded on date
     */
    func getVisitSummary(date: Date) -> VisitSummary?
    
    /**
     Get a summary of each visit recorded on any day in the date range
     
     - parameters:
        - startDate: Visits from and including this date will be returned
        - endDate: Visits up to and including this date will be returned
     
     - returns:
     Array of VisitSummary objects, or nil if no Visits have been recorded between the date range
     */
    func getVisitSummaries(recordedBetween startDate: Date, endDate: Date) -> [VisitSummary]

    /**
     Get a summary of each visit recorded on any day in the date range
     
     - parameters:
     - startDate: Visits from and including this date will be returned
     - endDate: Visits up to and including this date will be returned
     - mostRecentOnly: whether to only return the most recent visit for each combination of traplines
     
     - returns:
     Array of VisitSummary objects, or nil if no Visits have been recorded between the date range
     */
    func getVisitSummaries(recordedBetween startDate: Date, endDate: Date, mostRecentOnly: Bool) -> [VisitSummary]
    
}
