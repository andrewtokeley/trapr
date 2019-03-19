//
//  StationTests.swift
//  traprTests
//
//  Created by Andrew Tokeley on 6/11/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import XCTest

@testable import trapr_development

class StationTests: FirebaseTestCase {

    let stationService = ServiceFactory.sharedInstance.stationFirestoreService
    let traplineService = ServiceFactory.sharedInstance.traplineFirestoreService
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAdd() {
        
        let expect = expectation(description: "testAdd")
        
        self.removeTestStationsAndTraplines {
            
            self.createTestTrapline(regionId: "REG", traplineCode: "LW") { (trapline, stations) in
                
                if let newStation = stations.first {
                    newStation.latitude = 40
                    newStation.longitude = 140
                    newStation.traplineCode = "LW"
                    newStation.traplineId = "abcde"
                    newStation.trapTypes = [
                        TrapTypeStatus(trapTpyeId: TrapTypeCode.doc200.rawValue, active: true),
                        TrapTypeStatus(trapTpyeId: TrapTypeCode.pellibait.rawValue, active: true)
                    ]
            
                    self.stationService.add(station: newStation) { (station, error) in
                        XCTAssertNil(error)
                        XCTAssertTrue(station?.routeId == newStation.routeId)
                        XCTAssertTrue(station?.latitude == newStation.latitude)
                        XCTAssertTrue(station?.longitude == newStation.longitude)
                        XCTAssertTrue(station?.traplineCode == newStation.traplineCode)
                        XCTAssertTrue(station?.traplineId == newStation.traplineId)
                        
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
    
    func testMissingStations() {
        
        let expect = expectation(description: "testMissingStations")
        
        self.removeTestStationsAndTraplines {
            
            self.createTestTrapline(regionId: "TR", traplineCode: "LW", numberOfStations: 0) { (trapline, stations) in
                
                XCTAssertNotNil(trapline)
                
                let dispatchGroup = DispatchGroup()
                    
                // unordered, with gaps
                let stationNumbers = [8, 1, 2, 4, 5]
                for number in stationNumbers {
                    dispatchGroup.enter()
                    self.createTestStation(trapline: trapline!, stationNumber: number, completion: { (station) in
                        dispatchGroup.leave()
                    })
                }
                    
                dispatchGroup.notify(queue: .main, execute: {
                    self.stationService.getMissingStationIds(trapline: trapline! ,completion: { (missing) in
                        XCTAssertTrue(missing.count == 3)
                        XCTAssertTrue(self.cleanTestString(missing[0]) == "LW03")
                        XCTAssertTrue(self.cleanTestString(missing[1]) == "LW06")
                        XCTAssertTrue(self.cleanTestString(missing[2]) == "LW07")
                        expect.fulfill()
                    })
                })
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
        
        self.removeTestStationsAndTraplines {
            
            let dispatchGroup = DispatchGroup()
            self.createTestTrapline(regionId: "REG", traplineCode: "LW", numberOfStations: 0) { (trapline, stations) in
                
                XCTAssertNotNil(trapline)
                for stationNumber in 1...10 {
                    dispatchGroup.enter()
                    self.createTestStation(trapline: trapline!, stationNumber: stationNumber, completion: { (station) in
                        dispatchGroup.leave()
                    })
                }
            
                dispatchGroup.notify(queue: .main) {
                    // get the stations on the line
                    self.stationService.get(traplineId: trapline!.id!) { (stations) in
                        
                        XCTAssertNotNil(stations)
                        self.stationService.getStationSequence(fromStationId: stations.first!.id!, toStationId: stations.last!.id!) { (sequence, error) in
                            
                            XCTAssertTrue(sequence.count == stations.count)
                            XCTAssertTrue(sequence.first == stations.first)
                            XCTAssertTrue(sequence.last == stations.last)
                            
                            expect.fulfill()
                        }
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
        
        self.removeTestStationsAndTraplines {
            
            self.createTestTrapline(regionId: "REG", traplineCode: "LW", numberOfStations: 3) { (trapline, stations) in
                XCTAssertNotNil(trapline)
            
                self.stationService.getStationSequence(fromStationId: stations.last!.id!, toStationId: stations.first!.id!) { (sequence, error) in
                    
                    XCTAssertTrue(sequence.count == stations.count)
                    XCTAssertTrue(sequence.first == stations.last)
                    XCTAssertTrue(sequence.last == stations.first)
                    
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
    
    func testStationSequencePartial() {
        
        let expect = expectation(description: "testStationSequencePartial")
        
        self.removeTestStationsAndTraplines {
            
            self.createTestTrapline(regionId: "REG", traplineCode: "LW", numberOfStations: 10) { (trapline, stations) in
                self.stationService.get(traplineId: trapline!.id!) { (stations) in
                    
                    XCTAssertNotNil(stations)
                    self.stationService.getStationSequence(fromStationId: stations[3].id!, toStationId: stations[6].id!) { (sequence, error) in
                        
                        XCTAssertTrue(sequence.count == 4)
                        XCTAssertTrue(sequence.first == stations[3])
                        XCTAssertTrue(sequence.last == stations[6])
                        
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
        
        self.removeTestStationsAndTraplines {
            
            self.createTestTrapline(regionId: "REG", traplineCode: "LW", numberOfStations: 10) { (trapline, stations) in
                
                if let id = trapline?.id {
                    self.stationService.get(traplineId: id ) { (stations) in
                        
                        let result = self.stationService.description(stations: stations, includeStationCodes: true)
                        
                        let expected = "LW01-10"
                        
                        XCTAssertTrue(self.cleanTestString(result) == expected, "FAIL: \(result) != \(expected)")
                        
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

    /// Delete all stations and traplines
    private func removeTestStationsAndTraplines(completion: (() -> Void)?) {
        self.deleteTestStations {
            self.deleteTestTraplines {
                completion?()
            }
        }
    }
    
}
