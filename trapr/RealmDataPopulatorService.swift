//
//  DataPopulator.swift
//  trapr
//
//  Created by Andrew Tokeley  on 17/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

class RealmDataPopulatorService: RealmService, DataPopulatorServiceInterface {
    
    // Not implemented for Realm
    func createTraplineWithStations(trapline: _Trapline, stations: [_Station], completion: ((Error?) -> Void)?) {}
    
    func createTrapline(code: String, numberOfStations: Int, numberOfTrapsPerStation: Int, completion: ((_Trapline?) -> Void)?) {}
    
    
    var possumMaster: TrapType!
    var pelifeed: TrapType!
    var doc200: TrapType!
    var timms: TrapType!
    
    override init(realm: Realm) {
        super.init(realm: realm)
        
        // Make sure lookup data is up to date
        createOrUpdateLookupData()
    }
    
    func resetAllData() {
        try! realm.write {
            realm.deleteAll()
        }
        createOrUpdateLookupData()
        mergeWithV1Data()
    }

    func restoreDatabase(completion: (() -> Void)?) {
        restoreDatabase()
        completion?()
    }
    
    func restoreDatabase() {
        try! realm.write {
            realm.deleteAll()
        }
        createOrUpdateLookupData()
    }
    
    func createOrUpdateLookupData(completion: (() -> Void)?) {
        completion?()
    }
    
    func createOrUpdateLookupData() {
        ServiceFactory.sharedInstance.lureService.createOrUpdateDefaults()
        ServiceFactory.sharedInstance.speciesService.createOrUpdateDefaults()
        
        let trapTypeService = ServiceFactory.sharedInstance.trapTypeService
        trapTypeService.createOrUpdateDefaults()
        possumMaster = trapTypeService.get(.possumMaster)
        pelifeed = trapTypeService.get(.pellibait)
        doc200 = trapTypeService.get(.doc200)
        timms = trapTypeService.get(.timms)
    }
    
    func mergeAllRealmDataToServer(completion: ((String, Double, Error?) -> Void)?) {}
    
    func mergeDataFromCSVToDatastore(progress: ((Float) -> Void)?, completion: ((ImportSummary) -> Void)?) {
//        if let path = Bundle.main.path(forResource: "trapLines_May_27_2018", ofType: "trl") {

//            let importer: DataImport = importer_traplines_v1_to_v2(fileURL: URL(fileURLWithPath: path), traplineService: ServiceFactory.sharedInstance.traplineFirestoreService, regionService: ServiceFactory.sharedInstance.regionFirestoreService)
//
//
//            importer.validateFile(onError: nil, onCompletion: {
//                (summary) in
//
//                let recordsToImport = summary.lineCount
//
//                importer.importAndMerge(
//                    onError: nil,
//                    onProgress: {
//                        (importedLines) in
//                        let progressRate:Float = Float(importedLines)/Float(recordsToImport)
//                        progress?(progressRate)
//                },
//                    onCompletion: completion)
//            })
//
//        }
    }
    
    func mergeWithV1Data() {
        mergeWithV1Data(progress: nil, completion: nil)
    }
    
    func mergeWithV1Data(progress: ((Float) -> Void)?, completion: ((ImportSummary) -> Void)?) {
        if let path = Bundle.main.path(forResource: "trapLines_May_27_2018", ofType: "trl") {
            //trapLines_26_1_18
            let importer: DataImport = importer_traplines_v1_to_v2(fileURL: URL(fileURLWithPath: path), traplineService: ServiceFactory.sharedInstance.traplineService, regionService: ServiceFactory.sharedInstance.regionService)
            
            importer.validateFile(onError: nil, onCompletion: {
                (summary) in
                
                    let recordsToImport = summary.lineCount
                
                    importer.importAndMerge(
                        onError: nil,
                        onProgress: {
                            (importedLines) in
                            let progressRate:Float = Float(importedLines)/Float(recordsToImport)
                            progress?(progressRate)
                        },
                        onCompletion: completion)
            })
            
        }
    }
    
    func createTestData() {

        let trapline1 = createTrapline(code: "LW", numberOfStations: 11)
        let route1 = createRoute(name: "Lowry Bay", traplines: [trapline1], maxStationsPerLine: 11)
        createVisitsForTrapline(route: route1, trapline: trapline1, date: Date().add(-7, 0, 0))


        let trapline2 = createTrapline(code: "E", numberOfStations: 50)
        let trapline3 = createTrapline(code: "GC", numberOfStations: 6)
        let trapline4 = createTrapline(code: "U", numberOfStations: 6)
        let route2 = createRoute(name: "East Ridge", traplines: [trapline2, trapline3, trapline4], maxStationsPerLine: 11)
        createVisitsForTrapline(route: route2, trapline: trapline2, date: Date().add(0, -1, 0), numberOfStations: 10)
        createVisitsForTrapline(route: route2, trapline: trapline3, date: Date().add(0, -1, 0))
        createVisitsForTrapline(route: route2, trapline: trapline4, date: Date().add(0, -1, 0))

        let trapline5 = createTrapline(code: "AA", numberOfStations: 10)
        let route3 = createRoute(name: "A Line", traplines: [trapline5], maxStationsPerLine: 5)
        createVisitsForTrapline(route: route3, trapline: trapline5, date: Date().add(0, -2, 0), numberOfStations: 5)
        
    }

    func createTrapline(code: String, numberOfStations: Int) -> Trapline {
        return createTrapline(code: code, numberOfStations: numberOfStations, numberOfTrapsPerStation: 2)
    }
    
    func createTrapline(code: String, numberOfStations: Int, numberOfTrapsPerStation: Int) -> Trapline {
        
        let trapline = Trapline(region: Region(code: "TR", name: "Test Region"), code: code)
        
        // if we successfully add this trapline then add stations to it
        do {
            try ServiceFactory.sharedInstance.traplineService.add(trapline: trapline)
            for i in 1...numberOfStations {
                let station = Station(code: String(format: "%02d", i))
                
                if 1 <= numberOfTrapsPerStation {
                    let _ = station.addTrap(type: pelifeed)
                }
                if 2 <= numberOfTrapsPerStation {
                    let _ = station.addTrap(type: possumMaster)
                }
                if numberOfTrapsPerStation >= 3 {
                    let _ = station.addTrap(type: doc200)
                }

                ServiceFactory.sharedInstance.traplineService.addStation(trapline: trapline, station: station)
            }
        } catch {
            return Trapline()
        }
        
        return ServiceFactory.sharedInstance.traplineService.getTrapline(code: code) ?? trapline
    }

    func createVisitsForTrapline(route: Route, trapline: Trapline, date: Date, numberOfStations: Int = 1000) {
        
        let count = numberOfStations > trapline.stations.count ? trapline.stations.count - 1 : numberOfStations
        
        for i in 0...count - 1 {
            let station = trapline.stations[i]
            for trap in station.traps {
                let visit = Visit(date: date, route: route, trap: trap)
                if i == 0 {
                    visit.baitAdded = 2
                }
                ServiceFactory.sharedInstance.visitService.add(visit: visit)
            }
        }
    }
    
    func createVisit(_ added: Int, _ removed: Int, _ eaten: Int, _ date: Date, _ route: Route, _ trap: Trap) {
        
        let visit = Visit(date: date, route: route, trap: trap)
        visit.baitAdded = added
        visit.baitEaten = eaten
        visit.baitRemoved = removed
        ServiceFactory.sharedInstance.visitService.add(visit: visit)
    }
    
    func createRoute(name: String, traplines: [Trapline], maxStationsPerLine: Int) -> Route {
        var stations = [Station]()
        
        for trapline in traplines {
            let count = maxStationsPerLine > trapline.stations.count ? trapline.stations.count : maxStationsPerLine
            for i in 0...count - 1 {
                stations.append(trapline.stations[i])
            }
        }
        let route = Route(name: name, stations: stations)
        ServiceFactory.sharedInstance.routeService.add(route: route)
        return route
    }
}