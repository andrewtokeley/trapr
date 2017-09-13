//
//  VisitService.swift
//  trapr
//
//  Created by Andrew Tokeley  on 13/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

class VisitService: VisitServiceInterface {
    
    func addVisit(to trap: Trap) -> Visit {
        return Visit()
    }
    
    func getVisits(recordedOn date: Date) -> [Visit]? {
        return nil
    }
    
    func getVisitSummaries(recordedBetween startDate: Date, endDate: Date) -> [VisitSummary]? {
        return nil
    }
    
}

class VisitServiceMock: VisitServiceInterface {
    
    func addVisit(to trap: Trap) -> Visit {
        let visit = Visit()
        visit.visitDateTime = Date()
        return visit
    }
    
    func getVisits(recordedOn date: Date) -> [Visit]? {
        return nil
    }
    
    func getVisitSummaries(recordedBetween startDate: Date, endDate: Date) -> [VisitSummary]? {
        
        var visitSummaries = [VisitSummary]()
        
        visitSummaries.append(VisitSummary(trapLinesDescription: "LW", dateOfVisit: Date()))
        visitSummaries.append(VisitSummary(trapLinesDescription: "GC, E, U", dateOfVisit: Date().add(0,-1,0)))
        visitSummaries.append(VisitSummary(trapLinesDescription: "LW", dateOfVisit: Date().add(0,-2,0)))
        visitSummaries.append(VisitSummary(trapLinesDescription: "GC, E, U", dateOfVisit: Date().add(0,-3,0)))
        
        return visitSummaries
    }
    
}
