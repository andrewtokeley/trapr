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

    lazy var possumMaster: TrapType = {
        let trapType = TrapType()
        trapType.name = "Possum Master"
        trapType.killMethodRaw = KillMethod.Poison.rawValue
        trapType.baitDescription = "Blocks"

        try! self.realm.write {
            self.realm.add(trapType)
        }
        
        return trapType
    }()
    
    lazy var pelifeed: TrapType = {
        let trapType = TrapType()
        trapType.name = "Possum Master"
        trapType.killMethodRaw = KillMethod.Poison.rawValue
        trapType.baitDescription = "Blocks"
        
        try! self.realm.write {
            self.realm.add(trapType)
        }
        
        return trapType
    }()
    
    func replaceAllDataWithTestData() {
        deleteAllData()
        createTestData()
    }
    
    func deleteAllData() {
        // Delete all data in the repository
        ServiceFactory.sharedInstance.applicationService.deleteAllData()
    }
    
    func createTestData() {
        
        let trapline1 = createTrapline(code: "LW", numberOfStations: 5)
        createVisitsForTrapline(trapline: trapline1, date: Date())
        
        let trapline2 = createTrapline(code: "E", numberOfStations: 5)
        createVisitsForTrapline(trapline: trapline2, date: Date().add(-14, 0, 0))
        let trapline3 = createTrapline(code: "GC", numberOfStations: 5)
        createVisitsForTrapline(trapline: trapline3, date: Date().add(-14, 0, 0))
        let trapline4 = createTrapline(code: "U", numberOfStations: 5)
        createVisitsForTrapline(trapline: trapline4, date: Date().add(-14, 0, 0))
        
        let trapline5 = createTrapline(code: "LW", numberOfStations: 5)
        createVisitsForTrapline(trapline: trapline5, date: Date().add(-21, 0, 0))
    }

    func createTrapline(code: String, numberOfStations: Int) -> Trapline {
        let trapline = Trapline()
        trapline.code = code
        for i in 1...numberOfStations {
            let station = trapline.addStation(code: String(i))
            let _ = station.addTrap(type: possumMaster)
        }
        ServiceFactory.sharedInstance.traplineService.add(trapline: trapline)
        
        return trapline
    }

    func createVisitsForTrapline(trapline: Trapline, date: Date) {
        
        for station in trapline.stations {
            for trap in station.traps {
                let visit = Visit(trap: trap, date: date)
                ServiceFactory.sharedInstance.visitService.add(visit: visit)
            }
        }
    }
}
