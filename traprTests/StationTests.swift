//
//  StationTests.swift
//  traprTests
//
//  Created by Andrew Tokeley on 17/11/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import XCTest
import RealmSwift
import Foundation

@testable import trapr

class StationTests: XCTestCase {
    
    private lazy var dataPopulatorService = {
        return ServiceFactory.sharedInstance.dataPopulatorService
    }()

    private lazy var routeService = {
        return ServiceFactory.sharedInstance.routeService
    }()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        ServiceFactory.sharedInstance.dataPopulatorService.deleteAllTestData()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
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
    
//    func testRemovingRouteStations() {
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
//        XCTAssertTrue(route.stations.count == 6)
//        
//        // Update route stations to include all the route stations, excluding AA01
//        var newRouteStations = Array(route.stations)
//        newRouteStations.remove(at: 2) // AA01
//        
//        routeService.updateStations(route: route, stations: newRouteStations)
//        
//        // LW01, LW02, LW03, AA03, AA04, AA02
//        XCTAssertTrue(route.stations.count == 5)
//        XCTAssertTrue(route.stations[2].longCode == "LW03", "Expected LW03 was \(route.stations.last!.longCode)")
//        XCTAssertTrue(route.stations[3].longCode == "AA03", "Expected AA03 was \(route.stations.last!.longCode)")
//    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
