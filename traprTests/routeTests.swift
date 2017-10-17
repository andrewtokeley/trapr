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
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        ServiceFactory.sharedInstance.applicationService.deleteAllData()
    }
    
    func testStationDescriptions() {
        
        let trapline = ServiceFactory.sharedInstance.dataPopulatorService.createTrapline(code: "LW", numberOfStations: 10)
        
        let route = Route(stations: Array(trapline.stations))
        
        let expected = "LW: 01-10"
        let result = route.description(includeStationCodes: true)
        XCTAssertTrue(result == expected, "\(result) != \(expected)")        
    }
    
    func testStationDescriptionsMultiple() {
        
        let trapline = ServiceFactory.sharedInstance.dataPopulatorService.createTrapline(code: "LW", numberOfStations: 10)
        
        let stations = [trapline.stations[0], trapline.stations[1], trapline.stations[4], trapline.stations[5], trapline.stations[6], trapline.stations[9]]
        
        let route = Route(stations: stations)
        
        let expected = "LW: 01-02, 05-07, 10"
        let result = route.description(includeStationCodes: true)
        XCTAssertTrue(result == expected, "\(result) != \(expected)")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
