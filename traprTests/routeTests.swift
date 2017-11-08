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
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        print("DELETE ALL")
        ServiceFactory.sharedInstance.applicationService.deleteAllData()
        ServiceFactory.sharedInstance.dataPopulatorService.addLookupData()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
    }
    
    func testStationDescriptions() {
        print("START testStationDescriptions")
        let trapline = ServiceFactory.sharedInstance.dataPopulatorService.createTrapline(code: "LW", numberOfStations: 10)
        
        let route = Route(stations: Array(trapline.stations))
        
        let expected = "LW01-10"
        let result = route.longDescription
        XCTAssertTrue(result == expected, "FAIL: \(result) != \(expected)")
        
        ServiceFactory.sharedInstance.traplineService.delete(trapline: trapline)
    }
    
    func testStationDescriptionsMultiple() {
        print("START testStationDescriptionsMultiple")
        let trapline = ServiceFactory.sharedInstance.dataPopulatorService.createTrapline(code: "LW", numberOfStations: 10)
        
        let stations = [trapline.stations[0], trapline.stations[1], trapline.stations[4], trapline.stations[5], trapline.stations[6], trapline.stations[9]]
        
        let route = Route(stations: stations)
        
        let expected = "LW01-02, LW05-07, LW10"
        let result = route.longDescription
        XCTAssertTrue(result == expected, "FAIL: \(result) != \(expected)")
        
        ServiceFactory.sharedInstance.traplineService.delete(trapline: trapline)
    }
    
    func testStationDescriptionsMultipleTraplines() {
        print("START testStationDescriptionsMultipleTraplines")
        let trapline1 = ServiceFactory.sharedInstance.dataPopulatorService.createTrapline(code: "LW", numberOfStations: 10)
        let trapline2 = ServiceFactory.sharedInstance.dataPopulatorService.createTrapline(code: "E", numberOfStations: 5)
        
        var stations = Array(trapline1.stations)
        stations.append(contentsOf: Array(trapline2.stations))
        
        let route = Route(stations: stations)
        
        let expected = "LW01-10, E01-05"
        let result = route.longDescription
        XCTAssertTrue(result == expected, "FAIL: \(result) != \(expected)")
        
        ServiceFactory.sharedInstance.traplineService.delete(trapline: trapline1)
        ServiceFactory.sharedInstance.traplineService.delete(trapline: trapline2)
    }
    
}
