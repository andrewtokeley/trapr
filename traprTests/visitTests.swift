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
    
    var route_LW_E: Route?
    var route_GC: Route?
    
    lazy var visitService: VisitServiceInterface = {
        return ServiceFactory.sharedInstance.visitService
    }()
    
    lazy var traplineService: TraplineServiceInterface = {
        return ServiceFactory.sharedInstance.traplineService
    }()
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        ServiceFactory.sharedInstance.dataPopulatorService.deleteAllDataReadyForTests()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
    }
    
    func testUpdateVisit() {
        
        let NOTE = "This is a note"
        let BAIT_ADDED = 10
        
        // save a blank visit
        let visit = Visit()
        visit.visitDateTime = Date()
        visitService.add(visit: visit)
        
        // retrieve it from store
        var visits = visitService.getVisits(recordedOn: Date())
        
        // take a copy of the saved visit to enable batch updates to the objects before saving
        let visitToUpdate = Visit(value: visits.first!)
        
        // update some properties
        visitToUpdate.baitAdded = BAIT_ADDED
        visitToUpdate.notes = NOTE
        
        // save to store
        let _ = visitService.save(visit: visitToUpdate)
        
        // get the updated visit from the store and check properties stuck
        visits = visitService.getVisits(recordedOn: Date())
        XCTAssertTrue(visits.count == 1, "expected 1, was \(visits.count)")
        XCTAssertTrue(visits.first!.baitAdded == BAIT_ADDED, "expected \(BAIT_ADDED), was \(visits.first!.baitAdded)")
        XCTAssertTrue(visits.first!.notes == NOTE, "expected \(NOTE), was \(visits.first!.notes!)")
    }
    
    
    func testGetVisits() {
        
        let visit = Visit()
        visit.visitDateTime = Date()
        
        visitService.add(visit: visit)
        
        let visits = visitService.getVisits(recordedOn: Date())
        
        XCTAssertTrue(visits.count == 1, "expected 1, was \(visits.count)")
    }
    
    func testVisitKillCount() {
        
        createTestData()
        if let possum = ServiceFactory.sharedInstance.speciesService.get(.possum), let rat = ServiceFactory.sharedInstance.speciesService.get(.rat) {
            
            let killCountsThisMonth = ServiceFactory.sharedInstance.visitService.killCounts(monthOffset: 0, route: self.route_LW_E!)  //killCount(monthOffset: 0, species: possum, route: self.route_LW_E!)
            XCTAssertTrue(killCountsThisMonth[possum] == 1)
            XCTAssertTrue(killCountsThisMonth[rat] == 1)
            
            // no rats last month
            let killCountsLastMonth = ServiceFactory.sharedInstance.visitService.killCounts(monthOffset: -1, route: self.route_LW_E!)
            XCTAssertTrue(killCountsLastMonth[rat] == nil)
            XCTAssertTrue(killCountsLastMonth[possum] == 1)
                
            
        } else  {
            XCTFail()
        }
        
    }
    
    //MARK: - Test Data
    
    /**
     Create...
     
     LW, E Route
        - LW01
            - one visit today (possum)
            - one visit a month ago (possum)
        - E01 - one visit today (rat)
     
     GC Route
        - GC01 - no visits
    */
    func createTestData() {
        let possumMaster = TrapType()
        possumMaster.name = "Possum Master"
        
        // LW01
        let trapline1 = Trapline()
        trapline1.code = "LW"
        traplineService.add(trapline: trapline1)
        
        let station1 = Station(code: "01")
        let trap1 = station1.addTrap(type: possumMaster)
        traplineService.addStation(trapline: trapline1, station: station1)
        
        // E01
        let trapline2 = Trapline()
        trapline2.code = "E"
        traplineService.add(trapline: trapline2)
        
        let station2 = Station(code: "01")
        let trap2 = station2.addTrap(type: possumMaster)
        traplineService.addStation(trapline: trapline2, station: station2)
        
        // GC01
        let trapline3 = Trapline()
        trapline3.code = "GC"
        traplineService.add(trapline: trapline3)
        
        let station3 = Station(code: "01")
        let _ = station3.addTrap(type: possumMaster)
        traplineService.addStation(trapline: trapline3, station: station3)
        
        // Route_LW_E
        self.route_GC = Route(name: "GC Route", stations: [station3])
        self.route_LW_E = Route(name: "LW, E Route", stations: [station1, station2])
        ServiceFactory.sharedInstance.routeService.add(route: self.route_GC!)
        ServiceFactory.sharedInstance.routeService.add(route: self.route_LW_E!)
        
        // Visit LW01 - possum caught this month
        let visit1 = Visit(date: Date(), route: route_LW_E!, trap: trap1)
        visit1.catchSpecies = ServiceFactory.sharedInstance.speciesService.get(.possum)
        visitService.add(visit: visit1)
        
        // Visit LW01 - possum caught last month
        let visit2 = Visit(date: Date().add(0, -1, 0), route: route_LW_E!, trap: trap1)
        visit2.catchSpecies = ServiceFactory.sharedInstance.speciesService.get(.possum)
        visitService.add(visit: visit2)
        
        // Visit E01 - rat caugy this month
        let visit3 = Visit(date: Date(), route: route_LW_E!, trap: trap2)
        visit3.catchSpecies = ServiceFactory.sharedInstance.speciesService.get(.rat)
        visitService.add(visit: visit3)
        
        //
    }
    
    func testDeleteAllRouteVisits() {
        createTestData()
        
        if let route = self.route_LW_E {
            let visitCountBefore = visitService.getVisits(route: route).count
            visitService.deleteVisits(route: route)
            let visitCountAfter = visitService.getVisits(route: route).count
            XCTAssertTrue(visitCountBefore == 3)
            XCTAssertTrue(visitCountAfter == 0)
        }
        
    }
    
    func testGetVisitSummary() {
        createTestData()
        
        let summary = visitService.getVisitSummary(date: Date(), route: self.route_LW_E!)
        
        XCTAssert(summary.route == route_LW_E)
        XCTAssert(summary.visits.count == 2)
        XCTAssert(summary.route.shortDescription == "LW, E")
    }
    
    func testGetVisitSummary_NoVisits() {
        createTestData()
        let summary = visitService.getVisitSummary(date: Date(), route: self.route_GC!)
        
        XCTAssert(summary.route == route_GC)
        XCTAssert(summary.visits.count == 0)
        XCTAssert(summary.route.shortDescription == "GC")
    }
    
    func testGetSummaries() {
        createTestData()
        let summaries = visitService.getVisitSummaries(recordedBetween: Date().add(-1, 0,0), endDate: Date().add(1, 0, 0))
        
        // even though there are 2 route, only one has visits
        XCTAssert(summaries.count == 1)
        
    }
}
