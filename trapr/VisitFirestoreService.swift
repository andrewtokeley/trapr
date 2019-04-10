//
//  VisitFirestoreService.swift
//  trapr
//
//  Created by Andrew Tokeley on 10/11/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import FirebaseFirestore

class VisitFirestoreService: FirestoreEntityService<Visit>, VisitServiceInterface {
    
    private lazy var trapTypeService = { ServiceFactory.sharedInstance.trapTypeFirestoreService }()
    private lazy var stationService = { ServiceFactory.sharedInstance.stationFirestoreService }()
    private lazy var speciesService = { ServiceFactory.sharedInstance.speciesFirestoreService }()
    private lazy var userService = { ServiceFactory.sharedInstance.userService }()
    private lazy var routeUserSettingsService = { ServiceFactory.sharedInstance.routeUserSettingsFirestoreService }()
    
    func extend(visit: Visit, completion: ((VisitEx?) -> Void)?) {
        
        if let visitEx = VisitEx(visit: visit) {
        
            self.stationService.get(stationId: visit.stationId) { (station, error) in
                visitEx.stationName = station?.longCode
                
                self.trapTypeService.get(id: visit.trapTypeId, completion: { (trapType, error) in
                    visitEx.trapTypeName = trapType?.name
                    
                    let dispatchGroup = DispatchGroup()
                    
                    dispatchGroup.enter()
                    if let speciesId = visit.speciesId {
                        self.speciesService.get(id: speciesId, completion: { (species, error) in
                            visitEx.speciesName = species?.name
                            dispatchGroup.leave()
                        })
                    } else {
                        dispatchGroup.leave()
                    }
                    
                    visitEx.order = station!.id! + trapType!.id!
                    
                    dispatchGroup.notify(queue: .main, execute: {
                        completion?(visitEx)
                    })
                })
            }
        } else {
            completion?(nil)
        }
    }
    
    func get(source: FirestoreSource = .cache, completion: (([Visit]) -> Void)?) {
        // get the routes the user has access to
        self.routeUserSettingsService.get(source: source) { (routeUserSettings, error) in
            let routeIds = routeUserSettings.filter({ $0.routeId != nil }).map { $0.routeId! }

            // get the visits on these routes
            self.get(routeIds: routeIds, source: source, completion: { (visits, error) in
                if let _ = error {
                    completion?([Visit]())
                } else {
                    completion?(visits)
                }
            })
        }
    }
    
   func get(routeId: String, completion: (([Visit], Error?) -> Void)?) {
        super.get(whereField: VisitFields.routeId.rawValue, isEqualTo: routeId) { (visits, error) in
            completion?(visits, error)
        }
    }
    
    /// Get all visits created on the selected Routes, whether they were created by the current user or not
    private func get(routeIds: [String], source: FirestoreSource = .cache, completion: (([Visit], Error?) -> Void)?) {
        
        var routeVisits = [Visit]()
        let dispatchGroup = DispatchGroup()
        for routeId in routeIds {
            dispatchGroup.enter()
            super.get(whereField: VisitFields.routeId.rawValue, isEqualTo: routeId, source: source) { (visits, error) in
                routeVisits.append(contentsOf: visits)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion?(routeVisits, nil)
        }
    }
    
    func get(recordedOn date: Date, completion: (([Visit], Error?) -> Void)?) {
        let start = Timestamp(date: date.dayStart())
        let end = Timestamp(date: date.dayEnd())
        
        super.get(whereField: VisitFields.visitDate.rawValue, isGreaterThan: start, andLessThan: end) { (visits, error) in
            completion?(visits, error)
        }
    }
    
    func get(recordedBetween dateStart: Date, dateEnd: Date, completion: (([Visit], Error?) -> Void)?) {
        
        let start = Timestamp(date: dateStart)
        let end = Timestamp(date: dateEnd)
        
        super.get(whereField: VisitFields.visitDate.rawValue, isGreaterThan: start, andLessThan: end) { (visits, error) in
            completion?(visits, error)
        }
    }
    
    func get(recordedOn date: Date, routeId: String, completion: (([Visit], Error?) -> Void)?) {
        
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
    
    func get(recordedOn date: Date, routeId: String, stationId: String, trapTypeId: String, completion: (([Visit], Error?) -> Void)?) {
        
        let start = date.dayStart()
        let end = date.dayEnd()
        
        self.get(recordedBetween: start, dateEnd: end) { (visits, error) in
            
            // further filter by routeId, stationId and RouteId (Firestore can't do date range + other field filter)
            let visitsFiltered = visits.filter({ (visit) -> Bool in
                visit.routeId == routeId && visit.trapTypeId == trapTypeId && visit.stationId == stationId
            })
            completion?(visitsFiltered, error)
        }
    }
    
    func get(recordedBetween dateStart: Date, dateEnd: Date, routeId: String, completion: (([Visit], Error?) -> Void)?) {
        
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
    
    func get(recordedBetween dateStart: Date, dateEnd: Date, routeId: String, trapTypeId: String, completion: (([Visit], Error?) -> Void)?) {
        
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
    
    func get(recordedBetween dateStart: Date, dateEnd: Date, stationId: String, trapTypeId: String, completion: (([Visit], Error?) -> Void)?) {
        
        let start = dateStart
        let end = dateEnd
        
        self.get(recordedBetween: start, dateEnd: end) { (visits, error) in
            
            // further filter by station and traptype (Firestore can't do date range + other field filter)
            let visitsFiltered = visits.filter({ (visit) -> Bool in
                visit.trapTypeId == trapTypeId && visit.stationId == stationId
            })
            completion?(visitsFiltered, error)
        }
    }
    
    func getMostRecentVisit(routeId: String, completion: ((Visit?) -> Void)?) {
        super.get(whereField: VisitFields.routeId.rawValue, isEqualTo: routeId, orderByField: VisitFields.visitDate.rawValue, limit: 1000, completion: { (visits, error) in
            completion?(visits.last)
        })
    }
    
    func get(id: String, completion: ((Visit?, Error?) -> Void)?) {
        super.get(id: id) { (visit, error) in
            completion?(visit, error)
        }
    }
    
    func add(visit: Visit, completion: ((Visit?, Error?) -> Void)?) {
        let _ = super.add(entity: visit) { (visit, error) in
            completion?(visit, error)
        }
    }
    
    func deleteAll(completion: ((Error?) -> Void)?) {
        self.get { (visits) in
            super.delete(entities: visits, completion: { (error) in
                completion?(error)
            })
        }
    }
    
    func delete(visit: Visit, completion: ((Error?) -> Void)?) {
        super.delete(entity: visit) { (error) in
            completion?(error)
        }
    }
    
    func delete(routeId: String, completion: ((Error?) -> Void)?) {
        // get all visits on the route
        super.get(whereField: VisitFields.routeId.rawValue, isEqualTo: routeId) { (visits, error) in
            // delete them!
            super.delete(entities: visits, completion: { (error) in
                completion?(error)
            })
        }
    }
    
    func delete(visitSummary: VisitSummary, completion: ((Error?) -> Void)?) {
        self.delete(routeId: visitSummary.routeId!, date: visitSummary.dateOfVisit) { (error) in
            completion?(error)
        }
    }
    
    func delete(routeId: String, date: Date, completion: ((Error?) -> Void)?) {
        self.get(recordedOn: date, routeId: routeId) { (visits, error) in
            super.delete(entities: visits, completion: { (error) in
                completion?(error)
            })
        }
    }
    
    func save(visit: Visit, completion: ((Visit?, Error?) -> Void)?) {
        super.update(entity: visit) { (error) in
            completion?(visit, error)
        }
    }
    
    func hasVisits(stationId: String, trapTypeId: String, completion: ((Bool, Error?) -> Void)?) {
    
        self.collection.whereField(VisitFields.stationId.rawValue, isEqualTo: stationId).whereField(VisitFields.trapTypeId.rawValue, isEqualTo: trapTypeId).getDocuments { (snapshot, error) in
            completion?(snapshot?.count ?? 0 > 0, error)
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
    
    func killCounts(monthOffset: Int, routeId: String, completion: (([String : Int]) -> Void)?) {
        
//        var counts = [String: Int]()
//
//        let dayInMonth = Date().add(0, monthOffset, 0)
//        let dayInNextMonth = dayInMonth.add(0, 1, 0)
//
//        if let startOfMonth = Date.dateFromComponents(1, dayInMonth.month, dayInMonth.year)?.dayStart(), let endOfMonth = Date.dateFromComponents(1, dayInNextMonth.month, dayInNextMonth.year)?.dayStart() {
//            print ("from \(startOfMonth) to \(endOfMonth)")
//
//            self.get(recordedBetween: startOfMonth, dateEnd: endOfMonth, routeId: routeId) { (visits, error) in
//                for visit in visits {
//                    if let speciesId = visit.speciesId {
//                        if let _ = counts[speciesId] {
//                            counts[speciesId]! += 1
//                        } else {
//                            counts[speciesId] = 1
//                        }
//                    }
//                }
//                completion?(counts)
//            }
//        } else {
//            completion?([String: Int]())
//        }
        completion?([String: Int]())
    }
    
    func poisonCount(monthOffset: Int, routeId: String, completion: ((Int) -> Void)?) {
        
//        var count: Int = 0
//
//        let dayInMonth = Date().add(0, monthOffset, 0)
//        let dayInNextMonth = dayInMonth.add(0, 1, 0)
//
//        if let startOfMonth = Date.dateFromComponents(1, dayInMonth.month, dayInMonth.year)?.dayStart(), let endOfMonth = Date.dateFromComponents(1, dayInNextMonth.month, dayInNextMonth.year)?.dayStart().add(-1,0, 0) {
//
//            self.get(recordedBetween: startOfMonth, dateEnd: endOfMonth, routeId: routeId) { (visits, error) in
//
//                for visit in visits {
//
//                    if visit.trap?.type?.killMethod == .poison {
//                        count += visit.baitAdded
//                    }
//                }
//
//                completion?(count)
//            }
//        } else {
//            completion?(0)
//        }
    completion?(0)
    }
    
    func updateDate(visitId: String, date: Date, completion: ((Error?) -> Void)?) {
        //TODO!
    }

}
