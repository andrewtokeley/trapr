//
//  VisitService.swift
//  trapr
//
//  Created by Andrew Tokeley  on 13/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

class VisitService: Service, VisitServiceInterface {
    
    func add(visit: Visit) {
        try! realm.write {
            realm.add(visit)
        }
    }
    
    func getVisits(recordedBetween dateStart: Date, dateEnd: Date) -> Results<Visit> {
        
        return realm.objects(Visit.self).filter("visitDateTime BETWEEN {%@, %@}", dateStart, dateEnd)
    }
    
    func getVisits(recordedOn date: Date) -> Results<Visit> {
        
        let dateStart = date.dayStart()
        let dateEnd = date.dayEnd()
        
        return getVisits(recordedBetween: dateStart, dateEnd: dateEnd)
    }
    
    func getVisitSummary(date: Date) -> VisitSummary? {
        
        var visitSummary: VisitSummary?
        
        let visits = getVisits(recordedOn: date)
        
        if visits.count != 0 {
            
            var traplines = [Trapline]()
            
            for visit in visits {
                
                if let trapline = visit.trap?.station?.trapline {
                    if !traplines.contains(trapline) {
                        traplines.append(trapline)
                    }
                }
            }
            visitSummary = VisitSummary(traplines: traplines, dateOfVisit: date)
        }
        return visitSummary
    }
    
    func getVisitSummaries(recordedBetween startDate: Date, endDate: Date) -> [VisitSummary] {
        
        var summaries = [VisitSummary]()
        
        // Get the days the contain some visits
        let visits = getVisits(recordedBetween: startDate, dateEnd: endDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        var uniqueDates = [String]()
        
        for visit in visits {
            let visitDate = dateFormatter.string(from: visit.visitDateTime)
            if !uniqueDates.contains(visitDate) {
                uniqueDates.append(visitDate)
            }
        }
        
        for aDate in uniqueDates {
            
            if let date = dateFormatter.date(from: aDate) {
                if let summary = getVisitSummary(date: date) {
                    summaries.append(summary)
                }
            }
        }
        
        return summaries
    }
    
}
