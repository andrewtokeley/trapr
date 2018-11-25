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
    
    // not used
    func createOrUpdateLookupData() {}
    
    func createOrUpdateLookupData(completion: (() -> Void)?) {
        self.speciesService.createOrUpdateDefaults {
            
            self.lureService.createOrUpdateDefaults {
                
                // NOTE trapTypes must be added last as they rely on lures to be registered
                self.trapTypeService.createOrUpdateDefaults {
                    
                    completion?()
                    
                }
            }
        }
    }
    
    func resetAllData() {
        
    }
    
    func mergeWithV1Data() {
        
    }
    
    func mergeWithV1Data(progress: ((Float) -> Void)?, completion: ((ImportSummary) -> Void)?) {
        
    }
    
    func mergeDataFromCSVToDatastore(progress: ((Float) -> Void)?, completion: ((ImportSummary) -> Void)?) {
        
    }
    
    
    func restoreDatabase(){}
    
    func restoreDatabase(completion: (() -> Void)?) {
        
        speciesService.deleteAll { (error) in
            self.userService.deleteAllUsers { (error) in
                self.trapTypeService.deleteAll { (error) in
                    self.lureService.deleteAll { (error) in
                        self.traplineService.deleteAll { (error) in
                            self.stationService.deleteAll { (error) in
                                self.visitService.deleteAll { (error) in
                                    self.createOrUpdateLookupData {
                                        completion?()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
//    func createTrapline(code: String, numberOfStations: Int, completion: ((_Trapline?) -> Void)?) {
//        createTrapline(code: code, numberOfStations: numberOfStations, numberOfTrapsPerStation: 2, completion: completion)
//    }
//
    func createTrapline(code: String, numberOfStations: Int, numberOfTrapsPerStation: Int, completion: ((_Trapline?) -> Void)?) {
        let dispatchGroup = DispatchGroup()
        
        let trapline = _Trapline(code: code, regionCode: "TEST", details: "Test")
        let _ = traplineService.add(trapline: trapline) { (trapline, error) in
            
            if let trapline = trapline {
                for i in 1...numberOfStations {
                    
                    let station = _Station(number: i)
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
    
    
    func createTrapline(code: String, numberOfStations: Int) -> Trapline {
        return Trapline()
    }
    
    func createTrapline(code: String, numberOfStations: Int, numberOfTrapsPerStation: Int) -> Trapline {
        return Trapline()
    }
    
    func createVisit(_ added: Int, _ removed: Int, _ eaten: Int, _ date: Date, _ route: Route, _ trap: Trap) {
        
    }
    
}
