//
//  VisitFirestoreService.swift
//  trapr
//
//  Created by Andrew Tokeley on 10/11/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift // temporary until we get rid of sync calls
import FirebaseFirestore

class VisitFirestoreService: FirestoreEntityService<_Visit>, VisitServiceInterface {
    
    func add(visit: _Visit, completion: ((_Visit?, Error?) -> Void)?) {
        let _ = super.add(entity: visit) { (visit, error) in
            completion?(visit, error)
        }
    }
    
    func deleteAll(completion: ((Error?) -> Void)?) {
        super.deleteAllEntities { (error) in
            completion?(error)
        }
    }
    
    func delete(visit: _Visit, completion: ((Error?) -> Void)?) {
        super.delete(entity: visit) { (error) in
            completion?(error)
        }
    }
    
    func delete(visitsOn routeId: String, completion: ((Error?) -> Void)?) {
        // get all visits on the route
        super.get(whereField: VisitFields.routeId.rawValue, isEqualTo: routeId) { (visits, error) in
            // delete them!
            super.delete(entities: visits, completion: { (error) in
                completion?(error)
            })
        }
    }
    
    func delete(visitSummary: VisitSummary, completion: ((Error?) -> Void)?) {
        // get all the visits in the VisitSummary
        self.get(recordedOn: visitSummary.dateOfVisit, routeId: visitSummary.route.id) { (visits, error) in
            super.delete(entities: visits, completion: { (error) in
                completion?(error)
            })
        }
    }
    
    func save(visit: _Visit, completion: ((_Visit?, Error?) -> Void)?) {
        super.update(entity: visit) { (error) in
            completion?(visit, error)
        }
    }
    
    func hasVisits(stationId: String, trapTypeId: String, completion: ((Bool, Error?) -> Void)?) {
    
        self.collection.whereField(VisitFields.stationId.rawValue, isEqualTo: stationId).whereField(VisitFields.trapTypeId.rawValue, isEqualTo: trapTypeId).getDocuments { (snapshot, error) in
            completion?(snapshot?.count ?? 0 > 0, error)
        }
    }
    
    func get(routeId: String, completion: (([_Visit], Error?) -> Void)?) {
        super.get(whereField: VisitFields.routeId.rawValue, isEqualTo: routeId) { (visits, error) in
            completion?(visits, error)
        }
    }
    
    func get(recordedOn date: Date, completion: (([_Visit], Error?) -> Void)?) {
        let start = Timestamp(date: date.dayStart())
        let end = Timestamp(date: date.dayEnd())
        
        super.get(whereField: VisitFields.visitDate.rawValue, isGreaterThan: start, andLessThan: end) { (visits, error) in
            completion?(visits, error)
        }
    }
    
    func get(recordedBetween dateStart: Date, dateEnd: Date, completion: (([_Visit], Error?) -> Void)?) {
        
        let start = Timestamp(date: dateStart)
        let end = Timestamp(date: dateEnd)
        
        super.get(whereField: VisitFields.visitDate.rawValue, isGreaterThan: start, andLessThan: end) { (visits, error) in
            completion?(visits, error)
        }
    }
    
    func get(recordedOn date: Date, routeId: String, completion: (([_Visit], Error?) -> Void)?) {
        
        let start = date.dayStart()
        let end = date.dayEnd()
        
        self.get(recordedBetween: start, dateEnd: end) { (visits, error) in
            
            // further filter by routeId (Firestore can't do date range + other field filter)
            let visitsForRoute = visits.filter({ (visit) -> Bool in
                visit.routeId == routeId
            })
            completion?(visitsForRoute, error)
        }
    }
    
    func get(recordedOn date: Date, routeId: String, trapTypeId: String, completion: (([_Visit], Error?) -> Void)?) {
        
        let start = date.dayStart()
        let end = date.dayEnd()
        
        self.get(recordedBetween: start, dateEnd: end) { (visits, error) in
            
            // further filter by routeId (Firestore can't do date range + other field filter)
            let visitsFiltered = visits.filter({ (visit) -> Bool in
                visit.routeId == routeId && visit.trapTypeId == trapTypeId
            })
            completion?(visitsFiltered, error)
        }
    }
    
    func get(recordedBetween dateStart: Date, dateEnd: Date, routeId: String, completion: (([_Visit], Error?) -> Void)?) {
        
        let start = dateStart
        let end = dateEnd
        
        self.get(recordedBetween: start, dateEnd: end) { (visits, error) in
            
            // further filter by routeId (Firestore can't do date range + other field filter)
            let visitsFiltered = visits.filter({ (visit) -> Bool in
                visit.routeId == routeId
            })
            completion?(visitsFiltered, error)
        }
    }
    
    func get(recordedBetween dateStart: Date, dateEnd: Date, routeId: String, trapTypeId: String, completion: (([_Visit], Error?) -> Void)?) {
        
        let start = dateStart
        let end = dateEnd
        
        self.get(recordedBetween: start, dateEnd: end) { (visits, error) in
            
            // further filter by routeId (Firestore can't do date range + other field filter)
            let visitsFiltered = visits.filter({ (visit) -> Bool in
                visit.routeId == routeId && visit.trapTypeId == trapTypeId
            })
            completion?(visitsFiltered, error)
        }
    }
    
    func get(recordedBetween dateStart: Date, dateEnd: Date, trapTypeId: String, completion: (([_Visit], Error?) -> Void)?) {
        
        let start = dateStart
        let end = dateEnd
        
        self.get(recordedBetween: start, dateEnd: end) { (visits, error) in
            
            // further filter by routeId (Firestore can't do date range + other field filter)
            let visitsFiltered = visits.filter({ (visit) -> Bool in
                visit.trapTypeId == trapTypeId
            })
            completion?(visitsFiltered, error)
        }
    }
    
//    func getSummary(date: Date, routeId: String, completion: ((VisitSummary?, Error?) -> Void)?) {
//    }
//    
//    func getSummaries(recordedBetween startDate: Date, endDate: Date, includeHidden: Bool, completion: (([VisitSummary], Error?) -> Void)?) {    }
//    func getSummaries(recordedBetween startDate: Date, endDate: Date, routeId: String, completion: (([VisitSummary], Error?) -> Void)?) {    }
//    
//    func getStatistics(visitSummaries: [VisitSummary], completion: ((VisitSummariesStatistics?, Error?) -> Void)?) {
//        
//    }
//    func getSummaryMostRecent(routeId: String, completion: ((VisitSummary?, Error?) -> Void)?) {    }

    func visitsExistForRoute(routeId: String, completion: ((Bool, Error?) -> Void)?) {
        
    }
    
    func killCounts(monthOffset: Int, route: Route, completion: (([Species : Int]) -> Void)?) {
        
    }
    
    func poisonCount(monthOffset: Int, route: Route, completion: ((Int) -> Void)?) {
        
    }
    
    func updateDate(visitId: String, date: Date, completion: ((Error?) -> Void)?) {
        
    }
    
    
    // Not implemented for Firestore
    func getVisits(route: Route, station: Station) -> [Visit] { return [Visit]() }
    func add(visit: Visit) {}
    func delete(visit: Visit) {}
    func deleteVisits(route: Route) {}
    func deleteVisits(visitSummary: VisitSummary) {    }
    func save(visit: Visit) -> Visit { return Visit() }
    func getById(id: String) -> Visit? { return nil }
    func hasVisits(trap: Trap) -> Bool { return false }
    func getVisits(route: Route) -> Results<Visit>? { return nil }
    func getVisits(recordedOn date: Date) -> Results<Visit>? { return nil }
    func getVisits(recordedOn date: Date, route: Route) -> Results<Visit>? { return nil }
    func getVisits(recordedOn date: Date, route: Route, trap: Trap) -> Results<Visit>? { return nil }
    func getVisits(recordedBetween dateStart: Date, dateEnd: Date) -> Results<Visit>? { return nil }
    func getVisits(recordedBetween dateStart: Date, dateEnd: Date, route: Route) -> Results<Visit>? { return nil }
    func getVisits(recordedBetween dateStart: Date, dateEnd: Date, route: Route, trap: Trap) -> Results<Visit>? { return nil    }
    func getVisits(recordedBetween dateStart: Date, dateEnd: Date, trap: Trap) -> Results<Visit>? { return nil }
    func getVisitSummary(date: Date, route: Route) -> VisitSummary { return VisitSummary(dateOfVisit: Date(), route: Route(name: "", stations: [Station()])) }
    func getVisitSummaries(recordedBetween startDate: Date, endDate: Date, includeHidden: Bool) -> [VisitSummary] { return [VisitSummary(dateOfVisit: Date(), route: Route(name: "", stations: [Station()]))] }
    func getVisitSummaries(recordedBetween startDate: Date, endDate: Date, route: Route) -> [VisitSummary] { return [VisitSummary(dateOfVisit: Date(), route: Route(name: "", stations: [Station()]))] }
    func getStatistics(visitSummaries: [VisitSummary]) -> VisitSummariesStatistics? { return nil }
    func getVisitSummaryMostRecent(route: Route) -> VisitSummary? {
        return nil
    }
    func visitsExistForRoute(route: Route) -> Bool {
        return false
    }
    func killCounts(monthOffset: Int, route: Route) -> [Species : Int] {
        return [Species: Int]()
    }
    func poisonCount(monthOffset: Int, route: Route) -> Int {
        return 0
    }
    func updateDate(visit: Visit, date: Date) {
        
    }
}
