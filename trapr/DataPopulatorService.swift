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
    
    private var applicationService: ApplicationServiceInterface {
        return ServiceFactory.sharedInstance.applicationService
    }
    
    func populateWithTestData() {

        // Delete all data in the repository
        applicationService.deleteAllData()
        
        createTestData()
    }
    
    func createTestData() {
        
        let pelifeed = TrapType()
        pelifeed.name = "Pelifeed"
        pelifeed.killMethodRaw = KillMethod.Poison.rawValue
        pelifeed.baitDescription = "Blocks"
        
        let possumMaster = TrapType()
        possumMaster.name = "Possum Master"
        possumMaster.killMethodRaw = KillMethod.Direct.rawValue
        possumMaster.baitDescription = "Muesli"

        let trapline1 = Trapline()
        trapline1.code = "LW"
        trapline1.details = "Lowry Bay"
        let stationLW01 = trapline1.addStation(code: "01")
        let _ = stationLW01.addTrap(type: pelifeed)
        let _ = stationLW01.addTrap(type: possumMaster)
        let _ = trapline1.addStation(code: "02").addTrap(type: pelifeed)
        let _ = trapline1.addStation(code: "03").addTrap(type: pelifeed)
        let _ = trapline1.addStation(code: "04").addTrap(type: pelifeed)
        let _ = trapline1.addStation(code: "05").addTrap(type: pelifeed)
        
        let trapline2 = Trapline()
        trapline2.code = "E"
        trapline2.details = "Eastern Bays"
        let stationE01 = trapline2.addStation(code: "01")
        let _ = stationE01.addTrap(type: pelifeed)
        let _ = stationE01.addTrap(type: possumMaster)
        let stationE02 = trapline2.addStation(code: "02")
        let trap0 = stationE02.addTrap(type: pelifeed)
        let _ = stationE02.addTrap(type: possumMaster)
        
        let trapline3 = Trapline()
        trapline3.code = "GC"
        trapline3.details = "Wainuiomata Golf Club"
        let stationGC01 = trapline3.addStation(code: "01")
        let trap1 = stationGC01.addTrap(type: pelifeed)
        let trap2 = stationGC01.addTrap(type: possumMaster)
        let stationGC02 = trapline3.addStation(code: "02")
        let trap3 = stationGC02.addTrap(type: pelifeed)
        let trap4 = stationGC02.addTrap(type: possumMaster)

        let visit0 = Visit(trap: trap0)
        let visit1 = Visit(trap: trap1)
        let visit2 = Visit(trap: trap2)
        let visit3 = Visit(trap: trap3)
        let visit4 = Visit(trap: trap4)
        
        // These guys don't have their own service yet
        try! realm.write {
            realm.add(pelifeed)
            realm.add(possumMaster)
        }
        
        let traplineService = ServiceFactory.sharedInstance.traplineService
        traplineService.add(trapline: trapline1)
        traplineService.add(trapline: trapline2)
        traplineService.add(trapline: trapline3)
        
        let visitService = ServiceFactory.sharedInstance.visitService
        visitService.add(visit: visit0)
        visitService.add(visit: visit1)
        visitService.add(visit: visit2)
        visitService.add(visit: visit3)
        visitService.add(visit: visit4)

    }
}
