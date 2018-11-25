//
//  TrapTests.swift
//  traprTests
//
//  Created by Andrew Tokeley on 24/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import XCTest
import RealmSwift

@testable import trapr_development

class TrapTests: XCTestCase {
    
    lazy var trapService: TrapServiceInterface = {
        return ServiceFactory.sharedInstance.trapService
    }()
    
    //MARK: - Setup
    
    override func setUp() {
        super.setUp()
        ServiceFactory.sharedInstance.dataPopulatorService.restoreDatabase()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    //MARK: - Helpers
    func createVisit(_ added: Int, _ removed: Int, _ eaten: Int, _ date: Date, _ route: Route, _ trap: Trap) {
        ServiceFactory.sharedInstance.dataPopulatorService.createVisit(added, removed, eaten, date, route, trap)
    }
    
    //MARK: - Tests
    
    func testBalances() {
        let trapline = ServiceFactory.sharedInstance.dataPopulatorService.createTrapline(code: "LW", numberOfStations: 3)
        
        var balance: Int = 0
        if let trap =  trapline.stations.first?.traps.first {
            let route = Route(name: "LW Route", stations: Array(trapline.stations))
            
            createVisit(10, 0, 0, Date().add(0, -4, 0), route, trap)
            createVisit(3, 0, 3, Date().add(0, -3, 0), route, trap)
            createVisit(4, 1, 3, Date().add(0, -2, 0), route, trap)
            createVisit(5, 5, 0, Date().add(0, -1, 0), route, trap)
            
            balance = ServiceFactory.sharedInstance.trapService.getLureBalance(trap: trap, asAtDate: Date())
        }
        
        XCTAssertTrue(balance == 10, "Expected 10, was \(balance)")
        
        
    }
    
    func testBalancesOnDayOfVisit() {
        let trapline = ServiceFactory.sharedInstance.dataPopulatorService.createTrapline(code: "LW", numberOfStations: 1)
        
        var balanceOnTheDayBeforeVisit: Int = 0
        var balanceOnTheDayAfterVisit: Int = 0
        if let trap =  trapline.stations.first?.traps.first {
            let route = Route(name: "LW Route", stations: Array(trapline.stations))
            
            // consequetive visits
            
            // today
            let visitDay = Date()
            
            // yesterday
            let visitDayBefore = Date().add(-1, 0, 0)
            
            createVisit(10, 0, 0, visitDayBefore, route, trap)
            createVisit(3, 0, 3, visitDay, route, trap)
            
            balanceOnTheDayBeforeVisit = ServiceFactory.sharedInstance.trapService.getLureBalance(trap: trap, asAtDate: visitDayBefore)
            
            balanceOnTheDayAfterVisit = ServiceFactory.sharedInstance.trapService.getLureBalance(trap: trap, asAtDate: visitDay.add(1, 0, 0))
        }
        
        XCTAssertTrue(balanceOnTheDayBeforeVisit == 10, "Expected 10, was \(balanceOnTheDayBeforeVisit)")
        XCTAssertTrue(balanceOnTheDayAfterVisit == 10, "Expected 10, was \(balanceOnTheDayAfterVisit)")
    }
}
