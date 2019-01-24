//
//  FirestoreDataPopulatorService.swift
//  trapr_production
//
//  Created by Andrew Tokeley on 3/11/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import FirebaseFirestore

class DataPopulatorFirestoreService: FirestoreService, DataPopulatorServiceInterface {
    
    let speciesService = ServiceFactory.sharedInstance.speciesFirestoreService
    let userService = ServiceFactory.sharedInstance.userService
    let trapTypeService = ServiceFactory.sharedInstance.trapTypeFirestoreService
    let lureService = ServiceFactory.sharedInstance.lureFirestoreService
    let traplineService = ServiceFactory.sharedInstance.traplineFirestoreService
    let stationService = ServiceFactory.sharedInstance.stationFirestoreService
    let regionService = ServiceFactory.sharedInstance.regionFirestoreService
    let visitService = ServiceFactory.sharedInstance.visitFirestoreService
    let routeService = ServiceFactory.sharedInstance.routeFirestoreService
    
//    let realmRouteService = ServiceFactory.sharedInstance.routeService
//    let realmVisitService = ServiceFactory.sharedInstance.visitService
//    let realmRegionService = ServiceFactory.sharedInstance.regionService
//    let realmTraplineService = ServiceFactory.sharedInstance.traplineService
//    
//    private func progress(_ stepsDone: Int, _ stepsTotal: Int) -> Double {
//        if stepsTotal == 0 {
//            return 0
//        } else {
//            return Double(stepsDone)/Double(stepsTotal)
//        }
//    }
//    
//    func mergeAllRealmDataToServer(completion: ((String, Double, Error?) -> Void)?) {
//    
//        var totalStepsToComplete = 0
//        var totalStepsCompleted = 0
//        
//        // Regions
//        if let realmRegions = realmRegionService.getRegions() {
//            totalStepsToComplete += realmRegions.count
//            for realmRegion in realmRegions {
//                if let region = ModelConverter.Region(realmRegion) {
//                    regionService.add(lookup: region) { (error) in
//                        totalStepsCompleted += 1
//                        completion?("region \(region.name).", self.progress(totalStepsCompleted, totalStepsToComplete), error)
//                    }
//                }
//            }
//        }
//
//        // Traplines
//        if let realmTraplines = realmTraplineService.getTraplines() {
//            totalStepsToComplete += realmTraplines.count
//            for realmTrapline in realmTraplines {
//                if let trapline = ModelConverter.Trapline(realmTrapline) {
//                    let traplineId = self.traplineService.add(trapline: trapline) { (trapline, error) in
//                        totalStepsCompleted += 1
//                        if let trapline = trapline {
//                            completion?("trapline \(trapline.id!).", self.progress(totalStepsCompleted, totalStepsToComplete), error)
//                        } else {
//                            completion?("ERROR trapline", self.progress(totalStepsCompleted, totalStepsToComplete), error)
//                        }
//                    }
//
//                    // Stations
//                    totalStepsToComplete += realmTrapline.stations.count
//                    for realmStation in realmTrapline.stations {
//                        
//                        if let station = ModelConverter.Station(station: realmStation, traplineIdFS: traplineId) {
//
//                            self.stationService.add(station: station) { (station, error) in
//                                totalStepsCompleted += 1
//                                if let station = station {
//                                    completion?("station \(station.id!).", self.progress(totalStepsCompleted, totalStepsToComplete), error)
//                                } else {
//                                    completion?("ERROR station", self.progress(totalStepsCompleted, totalStepsToComplete), error)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//
//        // Routes
//        let realmRoutes = realmRouteService.getAll()
//        
//        totalStepsToComplete += realmRoutes.count
//        for realmRoute in realmRoutes {
//            if let route = ModelConverter.Route(realmRoute) {
//                let _ = routeService.add(route: route) { (route, error) in
//                    totalStepsCompleted += 1
//                    if let route = route {
//                        completion?("route \(route.id!).", self.progress(totalStepsCompleted, totalStepsToComplete), error)
//                    } else {
//                        completion?("ERROR route", self.progress(totalStepsCompleted, totalStepsToComplete), error)
//                    }
//                }
//                
//                // Associate Stations with Route
//                totalStepsToComplete += realmRoute.stations.count
//                for realmStation in realmRoute.stations {
//                    
//                    // need to get a reference to the trapline of this station, in order to get the Firestore ID for it
//                    if let trapline = ModelConverter.Trapline(realmStation.trapline!) {
//                        
//                        if let station = ModelConverter.Station(station: realmStation, traplineIdFS: trapline.id!) {
//                            
//                            station.routeId = route.id!
//                            self.stationService.add(station: station) { (station, error) in
//                                totalStepsCompleted += 1
//                                if let error = error {
//                                    completion?("ERROR station", self.progress(totalStepsCompleted, totalStepsToComplete), error)
//                                } else {
//                                    completion?("associating station \(station!.id!) with route \(route.id!).", self.progress(totalStepsCompleted, totalStepsToComplete), error)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            
//            // Visits
//            if let realmVisits = realmVisitService.getVisits(route: realmRoute) {
//                for realmVisit in realmVisits {
//                    if let visit = ModelConverter.Visit(realmVisit) {
//                        self.visitService.add(visit: visit) { (visit, error) in
//                            totalStepsCompleted += 1
//                            if let visit = visit {
//                                completion?("updated visit \(visit.id!).", self.progress(totalStepsCompleted, totalStepsToComplete), error)
//                            } else {
//                                completion?("ERROR updating visit", self.progress(totalStepsCompleted, totalStepsToComplete), error)
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    func createTraplineWithStations(trapline: _Trapline, stations: [_Station], completion: ((Error?) -> Void)?) {        
            let _ = self.traplineService.add(trapline: trapline) { (trapline, error) in
                if let trapline = trapline {
                    for station in stations {
                        station.traplineId = trapline.id
                    }
                    self.stationService.add(stations: stations, completion: { (stations, error) in
                        completion?(error)
                    })
                } else {
                    completion?(FirestoreEntityServiceError.addFailed)
                }
            }
    }
    
    func createTrapline(code: String, numberOfStations: Int, numberOfTrapsPerStation: Int, completion: ((_Trapline?) -> Void)?) {
        let dispatchGroup = DispatchGroup()
        
        let trapline = _Trapline(code: code, regionCode: "TEST", details: "Test")
        let _ = traplineService.add(trapline: trapline) { (trapline, error) in
            
            if let trapline = trapline {
                for i in 1...numberOfStations {
                    
                    let station = _Station(traplineId: trapline.id!, number:  i)
                    station.traplineId = trapline.id
                    station.traplineCode = trapline.code
                    
                    if 1 <= numberOfTrapsPerStation {
                        station.trapTypes.append(TrapTypeStatus(trapTpyeId: TrapTypeCode.pellibait.rawValue, active: true))
                    }
                    if 2 <= numberOfTrapsPerStation {
                        station.trapTypes.append(TrapTypeStatus(trapTpyeId: TrapTypeCode.possumMaster.rawValue, active: true))
                    }
                    if numberOfTrapsPerStation >= 3 {
                        station.trapTypes.append(TrapTypeStatus(trapTpyeId: TrapTypeCode.doc200.rawValue, active: true))
                    }
                    
                    dispatchGroup.enter()
                    ServiceFactory.sharedInstance.stationFirestoreService.add(station: station, completion: { (station, error) in
                        
                        dispatchGroup.leave()
                    })
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                completion?(trapline)
            }
        }
    }
}
