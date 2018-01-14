//
//  RouteTests.swift
//  traprTests
//
//  Created by Andrew Tokeley  on 17/10/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import XCTest
import RealmSwift

@testable import trapr

class RouteTests: XCTestCase {
    
    private lazy var dataPopulatorService = {
        return ServiceFactory.sharedInstance.dataPopulatorService
    }()
    
    private lazy var routeService = {
        return ServiceFactory.sharedInstance.routeService
    }()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        ServiceFactory.sharedInstance.dataPopulatorService.resetAllData()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
    }
    
//    func testReorderingStationsOnRoute() {
//        
//        let traplineLW = dataPopulatorService.createTrapline(code: "LW", numberOfStations: 3)
//        let traplineAA = dataPopulatorService.createTrapline(code: "AA", numberOfStations: 4)
//        
//        // Create a new Route with Stations in the order of LW01, LW02, AA01, LW03, AA03, AA04
//        let route = Route(name: "TestRoute", stations: [
//            traplineLW.stations[0],
//            traplineLW.stations[1],
//            traplineAA.stations[0],
//            traplineLW.stations[2],
//            traplineAA.stations[2],
//            traplineAA.stations[3]
//            ])
//        routeService.add(route: route)
//    
//        // reorder with AA traps first
//        
//        let stationOrder = [
//            traplineAA.stations[0]: 0,
//            traplineAA.stations[2]: 1,
//            traplineAA.stations[3]: 2,
//            traplineLW.stations[0]: 3,
//            traplineLW.stations[1]: 4,
//            traplineLW.stations[2]: 5,
//        ]
//    
//        let updatedRoute = ServiceFactory.sharedInstance.routeService.reorderStations(route: route, stationOrder: stationOrder)
//    
//        XCTAssertTrue(updatedRoute.stations[0].longCode == "AA01")
//        XCTAssertTrue(updatedRoute.stations[1].longCode == "AA03")
//        XCTAssertTrue(updatedRoute.stations[2].longCode == "AA04")
//        XCTAssertTrue(updatedRoute.stations[3].longCode == "LW01")
//        XCTAssertTrue(updatedRoute.stations[4].longCode == "LW02")
//        XCTAssertTrue(updatedRoute.stations[5].longCode == "LW03")
//    }
    
    func testAddingRouteStations() {
        
        let traplineLW = dataPopulatorService.createTrapline(code: "LW", numberOfStations: 3)
        let traplineAA = dataPopulatorService.createTrapline(code: "AA", numberOfStations: 4)
        
        // Create a new Route with Stations in the order of LW01, LW02, AA01, LW03, AA03, AA04
        let route = Route(name: "TestRoute", stations: [
            traplineLW.stations[0],
            traplineLW.stations[1],
            traplineAA.stations[0],
            traplineLW.stations[2],
            traplineAA.stations[2],
            traplineAA.stations[3]
            ])
        routeService.add(route: route)
        XCTAssertTrue(route.stations.count == 6)
        
        // Update route stations to include all the stations, including AA02
        var newRouteStations = Array(traplineLW.stations)
        newRouteStations.append(contentsOf: Array(traplineAA.stations))
        
        routeService.updateStations(route: route, stations: newRouteStations)
        
        // New station, AA02, should be at the end
        XCTAssertTrue(route.stations.count == 7)
        XCTAssertTrue(route.stations.last!.longCode == "AA02", "Expected AA02 was \(route.stations.last!.longCode)")
    }
    
    func testNumberOfDaysNoVisits() {
        let traplineLW = dataPopulatorService.createTrapline(code: "LW", numberOfStations: 3)
        let route = Route(name: "TestRoute", stations: Array(traplineLW.stations))
        
        let numberOfDays = ServiceFactory.sharedInstance.routeService.daysSinceLastVisit(route: route)
        
        XCTAssertNil(numberOfDays)
        
        
    }
    
    func testNumberOfDaysVisitedToday() {
        let traplineLW = dataPopulatorService.createTrapline(code: "LW", numberOfStations: 3)
        let route = Route(name: "TestRoute", stations: Array(traplineLW.stations))
        
        // create a visit for today
        let visit = Visit(date: Date(), route: route, trap: route.traplines[0].stations[0].traps[0])
        ServiceFactory.sharedInstance.visitService.add(visit: visit)
        
        let numberOfDays = ServiceFactory.sharedInstance.routeService.daysSinceLastVisit(route: route)
        
        XCTAssertTrue(numberOfDays == 0, "Expected 0, result \(numberOfDays!)")
    }
    
    func testNumberOfDaysVisitedYesterday() {
        let traplineLW = dataPopulatorService.createTrapline(code: "LW", numberOfStations: 3)
        let route = Route(name: "TestRoute", stations: Array(traplineLW.stations))
        
        // create a visit for today
        let visit = Visit(date: Date().add(-1, 0, 0), route: route, trap: route.traplines[0].stations[0].traps[0])
        ServiceFactory.sharedInstance.visitService.add(visit: visit)
        
        let numberOfDays = ServiceFactory.sharedInstance.routeService.daysSinceLastVisit(route: route)
        
        XCTAssertTrue(numberOfDays == 1, "Expected 1, result \(numberOfDays!)")
    }
}
