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
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        ServiceFactory.sharedInstance.dataPopulatorService.resetAllData()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReverseOrder() {
        let trapline = ServiceFactory.sharedInstance.dataPopulatorService.createTrapline(code: "LW", numberOfStations: 10)
        
        //XCTAssertTrue(trapline.stations[0].c)
    }
    func testStationDescriptions() {
        
        let trapline = ServiceFactory.sharedInstance.dataPopulatorService.createTrapline(code: "LW", numberOfStations: 10)
        let stations = Array(trapline.stations)
        let result = ServiceFactory.sharedInstance.stationService.getDescription(stations: stations, includeStationCodes: true)
        
        let expected = "LW01-10"
        
        XCTAssertTrue(result == expected, "FAIL: \(result) != \(expected)")
        
        ServiceFactory.sharedInstance.traplineService.delete(trapline: trapline)
    }
    
    func testStationDescriptionsMultiple() {
        
        let trapline = ServiceFactory.sharedInstance.dataPopulatorService.createTrapline(code: "LW", numberOfStations: 10)
        
        let stations = [trapline.stations[0], trapline.stations[1], trapline.stations[4], trapline.stations[5], trapline.stations[6], trapline.stations[9]]
        let result = ServiceFactory.sharedInstance.stationService.getDescription(stations: stations, includeStationCodes: true)
        
        let expected = "LW01-02, LW05-07, LW10"
        
        XCTAssertTrue(result == expected, "FAIL: \(result) != \(expected)")
        
        ServiceFactory.sharedInstance.traplineService.delete(trapline: trapline)
    }
    
    func testStationDescriptionsSkipped() {
        
        let trapline = ServiceFactory.sharedInstance.dataPopulatorService.createTrapline(code: "LW", numberOfStations: 3)
        
        // skip second one
        let stations = [trapline.stations[0], trapline.stations[2]]
        let result = ServiceFactory.sharedInstance.stationService.getDescription(stations: stations, includeStationCodes: true)
        
        let expected = "LW01, LW03"
        
        XCTAssertTrue(result == expected, "FAIL: \(result) != \(expected)")
        
        ServiceFactory.sharedInstance.traplineService.delete(trapline: trapline)
    }
    
    func testStationDescriptionsMultipleTraplines() {
        
        let trapline1 = ServiceFactory.sharedInstance.dataPopulatorService.createTrapline(code: "LW", numberOfStations: 10)
        let trapline2 = ServiceFactory.sharedInstance.dataPopulatorService.createTrapline(code: "E", numberOfStations: 5)
        
        var stations = Array(trapline1.stations)
        stations.append(contentsOf: Array(trapline2.stations))
        let result = ServiceFactory.sharedInstance.stationService.getDescription(stations: stations, includeStationCodes: true)
        let expected = "LW01-10, E01-05"
        XCTAssertTrue(result == expected, "FAIL: \(result) != \(expected)")
        
        ServiceFactory.sharedInstance.traplineService.delete(trapline: trapline1)
        ServiceFactory.sharedInstance.traplineService.delete(trapline: trapline2)
    }
    
    

    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
