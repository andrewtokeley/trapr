//
//  visitTests.swift
//  trapr
//
//  Created by Andrew Tokeley  on 20/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import XCTest
import RealmSwift

@testable import trapr

class visitTests: XCTestCase {
    
    lazy var visitService: VisitServiceInterface = {
        return ServiceFactory.sharedInstance.visitService
    }()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        ServiceFactory.sharedInstance.applicationService.deleteAllData()
    }
    
    func testGetVisits() {
        
        let visit = Visit()
        visit.visitDateTime = Date()
        
        visitService.add(visit: visit)
        
        let visits = visitService.getVisits(recordedOn: Date())
        
        XCTAssertTrue(visits.count == 1)
    }
    
    func getVisitSummary() -> VisitSummary {
        let possumMaster = TrapType()
        possumMaster.name = "Possum Master"
        
        let trapline1 = Trapline()
        trapline1.code = "LW"
        let station = trapline1.addStation(code: "01")
        let trap1 = station.addTrap(type: possumMaster)
        
        let trapline2 = Trapline()
        trapline2.code = "E"
        let station2 = trapline2.addStation(code: "01")
        let trap2 = station2.addTrap(type: possumMaster)
        
        let trapline3 = Trapline()
        trapline3.code = "GC"
        let station3 = trapline3.addStation(code: "01")
        let trap3 = station3.addTrap(type: possumMaster)
        
        let visit1 = Visit()
        visit1.visitDateTime = Date()
        visit1.trap = trap1
        visitService.add(visit: visit1)
        
        let visit2 = Visit()
        visit2.visitDateTime = Date()
        visit2.trap = trap2
        visitService.add(visit: visit2)
        
        let visit3 = Visit()
        visit3.visitDateTime = Date()
        visit3.trap = trap3
        visitService.add(visit: visit3)
        
        return visitService.getVisitSummary(date: Date())!
    }
    
    func testGetVisitSummary() {
        let summary = getVisitSummary()
        XCTAssertTrue(summary.traplinesDescription == "LW, E, GC")
    }
    
    func testGetAvailableTraplines() {
        
        let summary = getVisitSummary()
        
        let trapline = Trapline()
        trapline.code = "XX"
        ServiceFactory.sharedInstance.traplineService.add(trapline: trapline)
        
        // add a new trapline that's not part of this summary and it should be the only one returned
        
        let allTraplines = ServiceFactory.sharedInstance.traplineService.getTraplines()
        
        let interactor = SelectTraplineInteractor()
        let availableTraplines = interactor.getTraplinesAvailableVisitSummary(visitSummary: summary)
        
        XCTAssertTrue(allTraplines.count == 4)
        XCTAssertTrue(availableTraplines?.count ?? 0 == 1)
        XCTAssertTrue(availableTraplines?.first?.code ?? "--" == "XX")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
