//
//  _RouteTests.swift
//  traprTests
//
//  Created by Andrew Tokeley on 16/11/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import XCTest

@testable import trapr_development

class _RouteTests: XCTestCase {

    let routeService = ServiceFactory.sharedInstance.routeFirestoreService
    let stationService = ServiceFactory.sharedInstance.stationFirestoreService
    let dataPupulatorService = ServiceFactory.sharedInstance.dataPopulatorFirestoreService
    let traplineService = ServiceFactory.sharedInstance.traplineFirestoreService
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddNewRoute() {
        
        let expect = expectation(description: "testAddNewRoute")
        
        self.setupTests {
            
            let newRoute = _Route(id: "ER", name: "East Ridge")
            
            self.routeService.add(route: newRoute) { (route, error) in
                XCTAssertNil(error)
                XCTAssertNotNil(route)
                
                XCTAssertTrue(route?.id == "ER")
                XCTAssertTrue(route?.name == "East Ridge")
                
                expect.fulfill()
            }
        }
        
        waitForExpectations(timeout: 100) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    func testAddingRouteStations() {
        
        let expect = expectation(description: "testAddingRouteStations")
        
        self.setupTests {
            // Create LW01, LW02, LW03
            self.dataPupulatorService.createTrapline(code: "LW", numberOfStations: 3, numberOfTrapsPerStation: 1) { (traplineLW) in
                
                if let id = traplineLW?.id {
                    self.stationService.get(traplineId: id) { (stationsLW) in
                
                        // Create AA01, AA02, AA03, AA04
                        self.dataPupulatorService.createTrapline(code: "AA", numberOfStations: 4, numberOfTrapsPerStation: 1) { (traplineAA) in
                            
                            if let id = traplineAA?.id {
                                self.stationService.get(traplineId: id, completion: { (stationsAA) in
                                    
                                    // Create a new Route with Stations in the order of LW01, LW02, AA01, LW03, AA03, AA04
                                    let newRoute = _Route(id: "ER", name: "East Ridge #1")
                                    self.routeService.add(route: newRoute, completion: { (route, error) in
                                        
                                        let stationIds = [stationsLW[0].id!, stationsLW[1].id!, stationsAA[0].id!, stationsLW[2].id!, stationsAA[2].id!, stationsAA[3].id!]
                                        
                                        // Add stations to Route
                                        self.routeService.replaceStationsOn(routeId: route!.id!, stationIds: stationIds, completion: { (route, error) in
                                            
                                            // check route has stations
                                            XCTAssertTrue(route?.stationIds.count == 6)
                                            XCTAssertTrue(route?.stationIds.first == stationsLW[0].id)
                                            XCTAssertTrue(route?.stationIds.last == stationsAA[3].id)
                                            
                                            // check each station refers to route
                                            self.stationService.get(stationIds: stationIds, completion: { (stations, error) in
                                                
                                                for station in stations {
                                                    XCTAssertNotNil(station.routeId)
                                                    XCTAssertTrue(station.routeId == route?.id)
                                                }
                                            })
                                            
                                            expect.fulfill()
                                        })
                                    })

                                })
                            } else {
                                // traplineAA has no id
                                XCTFail()
                            }
                        }
                    }
                } else {
                    // traplineLW has no id
                    XCTFail()
                }
            }
        }
        
        waitForExpectations(timeout: 100) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    private func setupTests(completion: (() -> Void)?) {
        // Delete all routes before running each test
        self.routeService.delete { (error) in
            self.traplineService.deleteAll { (error) in
                self.stationService.deleteAll { (error) in
                    completion?()
                }
            }
        }
    }
//    func testAddStationsToRoute() {
//        
//        // create some stations
//        stationService.deleteAll { (error) in
//            let station1 = _Station(number: 1)
//            //station1.
//            self.stationService.add(station: station1, completion: { (station, error) in
//                //
//            })
//        }
//    }
}
