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
        ServiceFactory.sharedInstance.dataPopulatorService.deleteAllDataReadyForTests()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMissingStations() {
        let trapline = Trapline()
        trapline.code = "LW"
        ServiceFactory.sharedInstance.traplineService.add(trapline: trapline)
        
        // unordered, with gaps
        let stationCodes = ["08", "01", "02", "04", "05"]
        for code in stationCodes {
            let station = Station(code: code)
            ServiceFactory.sharedInstance.traplineService.addStation(trapline: trapline, station: station)
        }
        
        let missing = ServiceFactory.sharedInstance.stationService.getMissingStations()
        
        XCTAssertTrue(missing.count == 3)
        XCTAssertTrue(missing[0] == "LW03")
        XCTAssertTrue(missing[1] == "LW06")
        XCTAssertTrue(missing[2] == "LW07")
        
    }
    
    func testStationSequenceForward() {
        let trapline = ServiceFactory.sharedInstance.dataPopulatorService.createTrapline(code: "LW", numberOfStations: 10)
        
        if let sequence = ServiceFactory.sharedInstance.stationService.getStationSequence(trapline.stations.first!, trapline.stations.last!) {
        
            XCTAssertTrue(sequence.count == trapline.stations.count)
            XCTAssertTrue(sequence.first == trapline.stations.first)
            XCTAssertTrue(sequence.last == trapline.stations.last)
            
        } else {
            
            XCTFail()
        }
    }
    
    func testStationSequenceBackwards() {
        let trapline = ServiceFactory.sharedInstance.dataPopulatorService.createTrapline(code: "LW", numberOfStations: 10)
        
        if let sequence = ServiceFactory.sharedInstance.stationService.getStationSequence(trapline.stations.last!, trapline.stations.first!) {
            
            XCTAssertTrue(sequence.count == trapline.stations.count)
            XCTAssertTrue(sequence.first == trapline.stations.last)
            XCTAssertTrue(sequence.last == trapline.stations.first)
            
        } else {
            
            XCTFail()
        }
    }
    
    func testStationSequencePartial() {
        let trapline = ServiceFactory.sharedInstance.dataPopulatorService.createTrapline(code: "LW", numberOfStations: 10)
        
        if let sequence = ServiceFactory.sharedInstance.stationService.getStationSequence(trapline.stations[3], trapline.stations[6]) {
            
            XCTAssertTrue(sequence.count == 4) // 3rd,4th,5th and 6th stations
            XCTAssertTrue(sequence.first == trapline.stations[3])
            XCTAssertTrue(sequence.last == trapline.stations[6])
            
        } else {
            
            XCTFail()
        }
    }
    func testIsCentralStation() {
        let trapline10 = ServiceFactory.sharedInstance.dataPopulatorService.createTrapline(code: "LW", numberOfStations: 10)
        let trapline9 = ServiceFactory.sharedInstance.dataPopulatorService.createTrapline(code: "AA", numberOfStations: 9)
        let trapline1 = ServiceFactory.sharedInstance.dataPopulatorService.createTrapline(code: "BB", numberOfStations: 1)
        
        // with 10 stations the 5th one is central
        XCTAssertTrue(ServiceFactory.sharedInstance.stationService.isStationCentral(station: trapline10.stations[4]))
        XCTAssertFalse(ServiceFactory.sharedInstance.stationService.isStationCentral(station: trapline10.stations[5]))
        
        // with 9 stations the 4th is central
        XCTAssertTrue(ServiceFactory.sharedInstance.stationService.isStationCentral(station: trapline9.stations[3]))
        XCTAssertFalse(ServiceFactory.sharedInstance.stationService.isStationCentral(station: trapline9.stations[4]))
        
        // with 1 station, the only one is considered central
        XCTAssertTrue(ServiceFactory.sharedInstance.stationService.isStationCentral(station: trapline1.stations[0]))
        
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
        
        var stations = [Station]()
        stations.append(trapline.stations[0])
        stations.append(trapline.stations[1])
        stations.append(trapline.stations[4])
        stations.append(trapline.stations[5])
        stations.append(trapline.stations[6])
        stations.append(trapline.stations[9])
        
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
