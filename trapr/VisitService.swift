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
    
    func delete(visit: Visit) {
        try! realm.write {
            realm.delete(visit)
        }
    }

    func save(visit: Visit) {
        try! realm.write {
            realm.create(Visit.self, value: visit, update: true)
        }
    }
    
    func getVisits(recordedBetween dateStart: Date, dateEnd: Date) -> Results<Visit> {
        
        return realm.objects(Visit.self).filter("visitDateTime BETWEEN {%@, %@}", dateStart, dateEnd)
    }
    
    func getVisits(recordedBetween dateStart: Date, dateEnd: Date, route: Route) -> Results<Visit> {
        
        return realm.objects(Visit.self).filter("visitDateTime BETWEEN {%@, %@} AND route = %@", dateStart, dateEnd, route)
    }
    
    func getVisits(recordedBetween dateStart: Date, dateEnd: Date, route: Route, trap: Trap) -> Results<Visit> {
        
        return realm.objects(Visit.self).filter("visitDateTime BETWEEN {%@, %@} AND route = %@ AND trap = %@", dateStart, dateEnd, route, trap)
    }
    
    func getVisits(recordedOn date: Date) -> Results<Visit> {
        
        let dateStart = date.dayStart()
        let dateEnd = date.dayEnd()
        
        return getVisits(recordedBetween: dateStart, dateEnd: dateEnd)
    }
    
    func getVisits(recordedOn date: Date, route: Route) -> Results<Visit> {
        
        let dateStart = date.dayStart()
        let dateEnd = date.dayEnd()
        
        return getVisits(recordedBetween: dateStart, dateEnd: dateEnd, route: route)
    }
    
    func getVisits(recordedOn date: Date, route: Route, trap: Trap) -> Results<Visit> {
        
        let dateStart = date.dayStart()
        let dateEnd = date.dayEnd()
        
        return getVisits(recordedBetween: dateStart, dateEnd: dateEnd, route: route, trap: trap)
    }

    
    func getVisitSummary(date: Date, route: Route) -> VisitSummary {

        let visitSummary = VisitSummary(dateOfVisit: date, route: route)
        
        let visits = getVisits(recordedOn: date, route: route)
        visitSummary.visits = Array(visits)
        
        return visitSummary
    }

    func getVisitSummaries(recordedBetween startDate: Date, endDate: Date) -> [VisitSummary] {

        var summaries = [VisitSummary]()

        // For each Route
        let routeService = ServiceFactory.sharedInstance.routeService
        let allRoutes = routeService.getAll()
        
        for route in allRoutes {
            
            // Get the visits recorded for this route - if none, no summary will be created
            let visits = getVisits(recordedBetween: startDate, dateEnd: endDate, route: route)
            
            // Find the unique days where visits were recorded
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy"
            var uniqueDates = [String]()
            for visit in visits {
                let visitDate = dateFormatter.string(from: visit.visitDateTime)
                if !uniqueDates.contains(visitDate) {
                    uniqueDates.append(visitDate)
                }
            }

            // Create a VisitSummary for each day's visit
            for aDate in uniqueDates {
                
                if let date = dateFormatter.date(from: aDate) {
                    let summary = getVisitSummary(date: date, route: route)
                    summary.visits = Array(visits)
                    summaries.append(summary)
                }
            }
        }
        
        return summaries
    }
}
