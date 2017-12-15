//
//  DataPopulator.swift
//  trapr
//
//  Created by Andrew Tokeley  on 17/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

class DataPopulatorService: RealmService, DataPopulatorServiceInterface {
    
    var possumMaster: TrapType!
    var pelifeed: TrapType!
    var doc200: TrapType!
    
    override init(realm: Realm) {
        super.init(realm: realm)
        
        // Make sure lookup data is up to date
        createOrUpdateLookupData()
    }
    
    func replaceAllDataWithTestData() {
        deleteAllTestData()
        createTestData()
    }
    
    func deleteAllTestData() {
        // Delete all data in the repository
        ServiceFactory.sharedInstance.applicationService.deleteAllData()
        createOrUpdateLookupData()
    }
    
    private func createOrUpdateLookupData() {
        ServiceFactory.sharedInstance.lureService.createOrUpdateDefaults()
        ServiceFactory.sharedInstance.speciesService.createOrUpdateDefaults()
        
        let trapTypeService = ServiceFactory.sharedInstance.trapTypeService
        trapTypeService.createOrUpdateDefaults()
        possumMaster = trapTypeService.get(.possumMaster)
        pelifeed = trapTypeService.get(.pellibait)
        doc200 = trapTypeService.get(.doc200)
    }
    
    func mergeWithV1Data() {
        if let path = Bundle.main.path(forResource: "trapLines_Dec_5_2017", ofType: "trl") {
            let importer: DataImport = importer_traplines_v1_to_v2(fileURL: URL(fileURLWithPath: path))
            importer.importAndMerge(onError: nil, onCompletion: nil)
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
        let trapline = Trapline()
        trapline.code = code
        ServiceFactory.sharedInstance.traplineService.add(trapline: trapline)
        
        for i in 1...numberOfStations {
            let station = Station(code: String(format: "%02d", i))
            let _ = station.addTrap(type: pelifeed)
            let _ = station.addTrap(type: possumMaster)
            if i % 2 == 0 {
                let _ = station.addTrap(type: doc200)
            }
            ServiceFactory.sharedInstance.traplineService.addStation(trapline: trapline, station: station)
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
