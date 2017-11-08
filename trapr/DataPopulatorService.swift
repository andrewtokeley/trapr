//
//  DataPopulator.swift
//  trapr
//
//  Created by Andrew Tokeley  on 17/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

class DataPopulatorService: Service, DataPopulatorServiceInterface {
    
    var possumMaster: TrapType!
    var pelifeed: TrapType!
    
    func replaceAllDataWithTestData() {
        deleteAllData()
        addLookupData()
        createTestData()
    }
    
    func deleteAllData() {
        // Delete all data in the repository
        ServiceFactory.sharedInstance.applicationService.deleteAllData()
    }
    
    func addLookupData() {
        ServiceFactory.sharedInstance.lureService.createDefaults()
        ServiceFactory.sharedInstance.speciesService.createDefaults()
        
        let trapTypeService = ServiceFactory.sharedInstance.trapTypeService
        trapTypeService.createDefaults()
        possumMaster = trapTypeService.get(code: "PMA")
        pelifeed = trapTypeService.get(code: "PEL")
        
    }
    
    func createTestData() {
        
        let trapline1 = createTrapline(code: "LW", numberOfStations: 11)
        createVisitsForTrapline(trapline: trapline1, date: Date())
        createRoute(traplines: [trapline1], maxStationsPerLine: 11)
        
        let trapline2 = createTrapline(code: "E", numberOfStations: 50)
        createVisitsForTrapline(trapline: trapline2, date: Date().add(-14, 0, 0), numberOfStations: 10)
        let trapline3 = createTrapline(code: "GC", numberOfStations: 6)
        createVisitsForTrapline(trapline: trapline3, date: Date().add(-14, 0, 0))
        let trapline4 = createTrapline(code: "U", numberOfStations: 6)
        createVisitsForTrapline(trapline: trapline4, date: Date().add(-14, 0, 0))
        createRoute(traplines: [trapline2, trapline3, trapline4], maxStationsPerLine: 11)
        
        let trapline5 = createTrapline(code: "AA", numberOfStations: 10)
        createVisitsForTrapline(trapline: trapline5, date: Date().add(-21, 0, 0), numberOfStations: 5)
        createRoute(traplines: [trapline5], maxStationsPerLine: 5)
    }

    func createTrapline(code: String, numberOfStations: Int) -> Trapline {
        let trapline = Trapline()
        trapline.code = code
        for i in 1...numberOfStations {
            let station = trapline.addStation(code: String(format: "%02d", i))
            let _ = station.addTrap(type: possumMaster)
            if i < 3 {
                let _ = station.addTrap(type: pelifeed)
            }
        }
        ServiceFactory.sharedInstance.traplineService.add(trapline: trapline)
        
        return trapline
    }

    func createVisitsForTrapline(trapline: Trapline, route: Route, date: Date, numberOfStations: Int = 1000) {
        
    }
    
    func createVisitsForTrapline(trapline: Trapline, date: Date, numberOfStations: Int = 1000) {
        
        let count = numberOfStations > trapline.stations.count ? trapline.stations.count - 1 : numberOfStations
        
        for i in 0...count - 1 {
            let station = trapline.stations[i]
            for trap in station.traps {
                let visit = Visit(trap: trap, date: date)
                if i == 0 {
                    visit.baitAdded = 2
                }
                ServiceFactory.sharedInstance.visitService.add(visit: visit)
            }
        }
    }
    
    func createRoute(traplines: [Trapline], maxStationsPerLine: Int) {
        var stations = [Station]()
        
        for trapline in traplines {
            let count = maxStationsPerLine > trapline.stations.count ? trapline.stations.count : maxStationsPerLine
            for i in 0...count - 1 {
                stations.append(trapline.stations[i])
            }
        }
        
        ServiceFactory.sharedInstance.routeService.add(route: Route(stations: stations))
    }
}
