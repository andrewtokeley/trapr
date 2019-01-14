//
//  VisitService.swift
//  trapr
//
//  Created by Andrew Tokeley  on 13/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

class VisitService: RealmService, VisitServiceInterface {
    
    /// not implemented for Realm
    func extend(visit: _Visit, completion: ((VisitEx?) -> Void)?) {
    }
    
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

    
    func deleteVisits(visitSummary: VisitSummary) {
        try! realm.write {
            realm.delete(visitSummary.visits)
        }
    }
    
    func deleteVisits(route: Route) {
        if let visits = getVisits(route: route) {
            try! realm.write {
                realm.delete(visits)
            }
        }
    }
    
    func save(visit: Visit) -> Visit {
        var updated: Visit!
        try! realm.write {
            updated = realm.create(Visit.self, value: visit, update: true)
        }
        return updated
    }
    
    func hasVisits(trap: Trap) -> Bool {
        return realm.objects(Visit.self).filter("trap = %@", trap).count != 0
    }
    
    func getVisits(route: Route, station: Station) -> [Visit] {
        
        let visits = Array(realm.objects(Visit.self).filter("route.id = %@", route.id).sorted(byKeyPath: "visitDateTime", ascending: false)).filter { (visit) -> Bool in
            return visit.trap?.station == station
        }
        return visits
    }
    
    func getVisits(route: Route) -> Results<Visit>? {
        return realm.objects(Visit.self).filter("route.id = %@", route.id).sorted(byKeyPath: "visitDateTime", ascending: false)
    }
    
    func getById(id: String) -> Visit? {
        return realm.object(ofType: Visit.self, forPrimaryKey: id)
    }

    func getVisits(recordedBetween dateStart: Date, dateEnd: Date) -> Results<Visit>? {
        
        return realm.objects(Visit.self).filter("visitDateTime BETWEEN {%@, %@}", dateStart, dateEnd).sorted(byKeyPath: "visitDateTime", ascending: false)
    }
    
    func getVisits(recordedBetween dateStart: Date, dateEnd: Date, route: Route) -> Results<Visit>? {
        
        return realm.objects(Visit.self).filter("visitDateTime BETWEEN {%@, %@} AND route.id = %@", dateStart, dateEnd, route.id).sorted(byKeyPath: "visitDateTime", ascending: false)
    }
    
    func getVisits(recordedBetween dateStart: Date, dateEnd: Date, route: Route, trap: Trap) -> Results<Visit>? {
        
        return realm.objects(Visit.self).filter("visitDateTime BETWEEN {%@, %@} AND route.id = %@ AND trap = %@", dateStart, dateEnd, route.id, trap).sorted(byKeyPath: "visitDateTime", ascending: false)
    }
    
    func getVisits(recordedBetween dateStart: Date, dateEnd: Date, trap: Trap) -> Results<Visit>? {
        return realm.objects(Visit.self).filter("visitDateTime BETWEEN {%@, %@} AND trap = %@", dateStart, dateEnd, trap).sorted(byKeyPath: "visitDateTime", ascending: false)
    }
    
    func getVisits(recordedOn date: Date) -> Results<Visit>? {
        
        let dateStart = date.dayStart()
        let dateEnd = date.dayEnd()
        
        return getVisits(recordedBetween: dateStart, dateEnd: dateEnd)
    }
    
    func getVisits(recordedOn date: Date, route: Route) -> Results<Visit>? {
        
        let dateStart = date.dayStart()
        let dateEnd = date.dayEnd()
        
        return getVisits(recordedBetween: dateStart, dateEnd: dateEnd, route: route)
    }
    
    func getVisits(recordedOn date: Date, route: Route, trap: Trap) -> Results<Visit>? {
        
        let dateStart = date.dayStart()
        let dateEnd = date.dayEnd()
        
        return getVisits(recordedBetween: dateStart, dateEnd: dateEnd, route: route, trap: trap)
    }

    
    func getVisitSummary(date: Date, route: Route) -> VisitSummary {

        let visitSummary = VisitSummary(dateOfVisit: date, route: route)
        
        if let visits = getVisits(recordedOn: date, route: route) {
            visitSummary.visits = Array(visits)
        }
        
        return visitSummary
    }

    func getVisitSummaries(recordedBetween startDate: Date, endDate: Date, route: Route) -> [VisitSummary] {
        
        var summaries = [VisitSummary]()
        
        // Get the visits recorded for this route - if none, no summary will be created
        if let visits = getVisits(recordedBetween: startDate, dateEnd: endDate, route: route) {
        
            // Find the unique days where visits were recorded
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "ddMMyyyy"
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
                    if let dayVisits = getVisits(recordedOn: date, route: route) {
                        summary.visits = Array(dayVisits)
                        summaries.append(summary)
                    }
                }
            }
        }
        
        return summaries
    }
    
    func getVisitSummaries(recordedBetween startDate: Date, endDate: Date, includeHidden: Bool = false) -> [VisitSummary] {

        var summaries = [VisitSummary]()
        
        // For each Route
        let routeService = ServiceFactory.sharedInstance.routeService
        let allRoutes = routeService.getAll(includeHidden: includeHidden)
        
        for route in allRoutes {
        
            let summariesForRoute = getVisitSummaries(recordedBetween: startDate, endDate: endDate, route: route)
            summaries.append(contentsOf: summariesForRoute)
        }
        
        return summaries
    }
    
    // Not sure if we need this!
    func getStatistics(visitSummaries: [VisitSummary]) -> VisitSummariesStatistics? {
    
//        // ignore times that are outliers, under 2 mins. These are clearly not manual times.
//        let orderedSummaries = visitSummaries.filter({ $0.timeTaken > 120 }).sorted(by: { $0.timeTaken < $1.timeTaken }, stable: true)
//        let totalTimeTaken = visitSummaries.reduce(0, { $0 + $1.timeTaken })
//        let averageTimeTaken = totalTimeTaken/Double(orderedSummaries.count)
//        if let fastestTime = orderedSummaries.first?.timeTaken {
//            // TODO
//            return VisitSummariesStatistics()
//        }
        
        return nil
    }
    
    func getVisitSummaryMostRecent(route: Route) -> VisitSummary? {
        return getVisitSummaries(recordedBetween: Date().add(0, 0, -100), endDate: Date(), route: route).sorted(by: {
            (v1, v2) in
            v1.dateOfVisit > v2.dateOfVisit
        }).first
    }
    
    func visitsExistForRoute(route: Route) -> Bool {
        if let _ = realm.objects(Visit.self).filter("route.id = %@", route.id).first {
            return true
        }
        return false
    }
    
    func poisonCount(monthOffset: Int, route: Route) -> Int {
        
        var count: Int = 0
        
        let dayInMonth = Date().add(0, monthOffset, 0)
        let dayInNextMonth = dayInMonth.add(0, 1, 0)
        
        if let startOfMonth = Date.dateFromComponents(1, dayInMonth.month, dayInMonth.year)?.dayStart() {
            if let endOfMonth = Date.dateFromComponents(1, dayInNextMonth.month, dayInNextMonth.year)?.dayStart().add(-1,0, 0) {
                
                if let visits = getVisits(recordedBetween: startOfMonth, dateEnd: endOfMonth, route: route) {
                
                    for visit in visits {
                        if visit.trap?.type?.killMethod == .poison {
                            count += visit.baitAdded
                        }
                    }
                }
            }
        }
        return count
    }
    
    func killCounts(monthOffset: Int, route: Route) -> [Species: Int] {
        
        var counts = [Species: Int]()
        
        let dayInMonth = Date().add(0, monthOffset, 0)
        let dayInNextMonth = dayInMonth.add(0, 1, 0)
        
        if let startOfMonth = Date.dateFromComponents(1, dayInMonth.month, dayInMonth.year)?.dayStart() {
            if let endOfMonth = Date.dateFromComponents(1, dayInNextMonth.month, dayInNextMonth.year)?.dayStart() {
                print ("from \(startOfMonth) to \(endOfMonth)")
                if let visits = getVisits(recordedBetween: startOfMonth, dateEnd: endOfMonth, route: route) {
                
                    for visit in visits {
                        if let species = visit.catchSpecies {
                            if let _ = counts[species] {
                                counts[species]! += 1
                            } else {
                                counts[species] = 1
                            }
                        }
                    }
                }
            }
        }
        return counts
    }
    
    func updateDate(visit: Visit, date: Date) {
        try! realm.write {
            if let newDate = visit.visitDateTime.setDate(date.day, date.month, date.year) {
                visit.visitDateTime = newDate
            }
        }
    }
    
    // not implemented for Realm
    func add(visit: _Visit, completion: ((_Visit?, Error?) -> Void)?) {}
    func delete(routeId: String, date: Date, completion: ((Error?) -> Void)?) {}
    func delete(visit: _Visit, completion: ((Error?) -> Void)?) {}
    func deleteAll(completion: ((Error?) -> Void)?) {}
    func delete(routeId: String, completion: ((Error?) -> Void)?) {}
    func delete(visitSummary: _VisitSummary, completion: ((Error?) -> Void)?) {}
    func save(visit: _Visit, completion: ((_Visit?, Error?) -> Void)?) {}
    func get(id: String, completion: ((_Visit?, Error?) -> Void)?) {}
    func hasVisits(stationId: String, trapTypeId: String, completion: ((Bool, Error?) -> Void)?) {}
    func get(routeId: String, completion: (([_Visit], Error?) -> Void)?) {}
    func get(recordedOn date: Date, completion: (([_Visit], Error?) -> Void)?) {}
    func get(recordedOn date: Date, routeId: String, completion: (([_Visit], Error?) -> Void)?) {}
    func get(recordedOn date: Date, routeId: String, stationId: String, trapTypeId: String, completion: (([_Visit], Error?) -> Void)?) {}
    func get(recordedBetween dateStart: Date, dateEnd: Date, completion: (([_Visit], Error?) -> Void)?) {}
    func get(recordedBetween dateStart: Date, dateEnd: Date, routeId: String, completion: (([_Visit], Error?) -> Void)?) {}
    func get(recordedBetween dateStart: Date, dateEnd: Date, routeId: String, trapTypeId: String, completion: (([_Visit], Error?) -> Void)?) {}
    func get(recordedBetween dateStart: Date, dateEnd: Date, stationId: String, trapTypeId: String, completion: (([_Visit], Error?) -> Void)?) {}
    func getMostRecentVisit(routeId: String, completion: ((_Visit?) -> Void)?) {}
//    func getSummary(date: Date, routeId: String, completion: ((VisitSummary?, Error?) -> Void)?) {}
//    func getSummaries(recordedBetween startDate: Date, endDate: Date, includeHidden: Bool, completion: (([VisitSummary], Error?) -> Void)?) {}
//    func getSummaries(recordedBetween startDate: Date, endDate: Date, routeId: String, completion: (([VisitSummary], Error?) -> Void)?) {}
//    func getStatistics(visitSummaries: [VisitSummary], completion: ((VisitSummariesStatistics?, Error?) -> Void)?) {}
//    func getSummaryMostRecent(routeId: String, completion: ((VisitSummary?, Error?) -> Void)?) {}
    func visitsExistForRoute(routeId: String, completion: ((Bool, Error?) -> Void)?) {}
    func killCounts(monthOffset: Int, routeId: String, completion: (([String : Int]) -> Void)?) {}
    func poisonCount(monthOffset: Int, routeId: String, completion: ((Int) -> Void)?) {}
    func updateDate(visitId: String, date: Date, completion: ((Error?) -> Void)?) {}
    
}
