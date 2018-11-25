//
//  _StationTests.swift
//  traprTests
//
//  Created by Andrew Tokeley on 6/11/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import XCTest

@testable import trapr_development

class _StationTests: XCTestCase {

    let stationService = ServiceFactory.sharedInstance.stationFirestoreService
    let traplineService = ServiceFactory.sharedInstance.traplineFirestoreService
    let dataPopulatorService = ServiceFactory.sharedInstance.dataPopulatorFirestoreService
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAdd() {
        
        let expect = expectation(description: "testAdd")
        
        self.testSetUp {
            let newStation = _Station(number: 1)
            newStation.routeId = "RO"
            newStation.latitude = 40
            newStation.longitude = 140
            newStation.traplineCode = "LW"
            newStation.traplineId = "abcde"
            newStation.trapTypes = [
                TrapTypeStatus(trapTpyeId: TrapTypeCode.doc200.rawValue, active: true),
                TrapTypeStatus(trapTpyeId: TrapTypeCode.pellibait.rawValue, active: true)
            ]
        
            self.stationService.add(station: newStation, completion: { (station, error) in
                XCTAssertNil(error)
                
                XCTAssertTrue(station?.routeId == newStation.routeId)
                XCTAssertTrue(station?.latitude == newStation.latitude)
                XCTAssertTrue(station?.longitude == newStation.longitude)
                XCTAssertTrue(station?.traplineCode == newStation.traplineCode)
                XCTAssertTrue(station?.traplineId == newStation.traplineId)
                expect.fulfill()
            })
        }
        
        waitForExpectations(timeout: 100) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    func testMissingStations() {
        
        let expect = expectation(description: "testMissingStations")
        
        self.testSetUp {
            
            let trapline = _Trapline(code: "LW", regionCode: "TR", details: "Test Line")
            let _ = self.traplineService.add(trapline: trapline) { (trapline, error) in
                
                if let trapline = trapline {
                    XCTAssertNil(error)
                    
                    let dispatchGroup = DispatchGroup()
                    
                    // unordered, with gaps
                    let stationCodes = [8, 1, 2, 4, 5]
                    for number in stationCodes {
                        let station = _Station(number: number)
                        station.traplineId = trapline.id
                        station.traplineCode = trapline.code
                        
                        dispatchGroup.enter()
                        self.stationService.add(station: station, completion: { (station, error) in
                            dispatchGroup.leave()
                        })
                    }
                    
                    dispatchGroup.notify(queue: .main, execute: {
                        self.stationService.getMissingStations(completion: { (missing) in
                            XCTAssertTrue(missing.count == 3)
                            XCTAssertTrue(missing[0] == "LW03")
                            XCTAssertTrue(missing[1] == "LW06")
                            XCTAssertTrue(missing[2] == "LW07")
                            expect.fulfill()
                        })
                    })
                } else {
                    XCTFail()
                    expect.fulfill()
                }
            }
        }
        
        waitForExpectations(timeout: 100) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    func testStationSequenceForward() {
        
        let expect = expectation(description: "testStationSequenceForward")
        
        self.testSetUp {
            
            self.dataPopulatorService.createTrapline(code: "LW", numberOfStations: 10, numberOfTrapsPerStation: 1) { (trapline) in
                
                XCTAssertNotNil(trapline)
                
                // get the stations on the line
                self.stationService.get(traplineId: trapline!.id!) { (stations) in
                    
                    XCTAssertNotNil(stations)
                    self.stationService.getStationSequence(stations.first!, stations.last!) { (sequence) in
                        
                        XCTAssertTrue(sequence!.count == stations.count)
                        XCTAssertTrue(sequence!.first == stations.first)
                        XCTAssertTrue(sequence!.last == stations.last)
                        
                        expect.fulfill()
                    }
                }
            }
        }
        
        waitForExpectations(timeout: 100) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    func testStationSequenceBack() {
        
        let expect = expectation(description: "testStationSequenceBack")
        
        self.testSetUp {
            
            self.dataPopulatorService.createTrapline(code: "LW", numberOfStations: 10, numberOfTrapsPerStation: 1) { (trapline) in
                
                XCTAssertNotNil(trapline)
                
                // get the stations on the line
                self.stationService.get(traplineId: trapline!.id!) { (stations) in
                    
                    XCTAssertNotNil(stations)
                    self.stationService.getStationSequence(stations.last!, stations.first!) { (sequence) in
                        
                        XCTAssertTrue(sequence!.count == stations.count)
                        XCTAssertTrue(sequence!.first == stations.last)
                        XCTAssertTrue(sequence!.last == stations.first)
                        
                        expect.fulfill()
                    }
                }
            }
        }
        
        waitForExpectations(timeout: 100) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    func testStationSequencePartial() {
        
        let expect = expectation(description: "testStationSequencePartial")
        
        self.testSetUp {
            
            self.dataPopulatorService.createTrapline(code: "LW", numberOfStations: 10, numberOfTrapsPerStation: 1) { (trapline) in
                
                XCTAssertNotNil(trapline)
                
                self.stationService.get(traplineId: trapline!.id!) { (stations) in
                    
                    XCTAssertNotNil(stations)
                    self.stationService.getStationSequence(stations[3], stations[6]) { (sequence) in
                        
                        XCTAssertTrue(sequence!.count == 4)
                        XCTAssertTrue(sequence!.first == stations[3])
                        XCTAssertTrue(sequence!.last == stations[6])
                        
                        expect.fulfill()
                    }
                }
            }
        }
        
        waitForExpectations(timeout: 100) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }   
    }
    
    func testStationDescriptions() {
        
        let expect = expectation(description: "testStationDescriptions")
        
        self.testSetUp {
            self.dataPopulatorService.createTrapline(code: "LW", numberOfStations: 10, numberOfTrapsPerStation: 1) { (trapline) in
            
                XCTAssertNotNil(trapline)
                
                if let id = trapline?.id {
                    self.stationService.get(traplineId: id ) { (stations) in
                    
                        print("first: \(stations[0].number)")
                        
                        let result = self.stationService.getDescription(stations: stations, includeStationCodes: true)
                        
                        let expected = "LW01-10"
                        
                        XCTAssertTrue(result == expected, "FAIL: \(result) != \(expected)")
                        
                        expect.fulfill()
                        
                    }
                } else {
                    XCTFail()
                    expect.fulfill()
                }
            }
        }
        
        waitForExpectations(timeout: 100) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }

    private func testSetUp(completion: (() -> Void)?) {
        self.stationService.deleteAll { (error) in
            self.traplineService.deleteAll { (error) in
                completion?()
            }
        }
    }
    
}
