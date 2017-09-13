//
//  VisitServiceInterface.swift
//  trapr
//
//  Created by Andrew Tokeley  on 13/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol VisitServiceInterface {
    
    /**
     Record a new Visit to a specific Trap
     
     - parameters:
        - trap: the Trap where the Visit is being recorded
     
     - returns:
    A Visit instance that references the newly created visit
     */
    func addVisit(to trap: Trap) -> Visit
    
    /**
     Gets all Visits recorded on a specific Trapline

     - parameters:
        - date: the date at which Visits were recorded
     
     - returns:
     Array of Visits, or nil if no Visits have been recorded on the Trapline
     */
    func getVisits(recordedOn date: Date) -> [Visit]?
    
    /**
     Get a summary of each visit recorded on any day in the date range
     
     - parameters:
        - startDate: Visits from and including this date will be returned
        - endDate: Visits up to and including this date will be returned
     
     - returns:
     Array of VisitSummary objects, or nil if no Visits have been recorded between the date range
     */
    func getVisitSummaries(recordedBetween startDate: Date, endDate: Date) -> [VisitSummary]?

}
