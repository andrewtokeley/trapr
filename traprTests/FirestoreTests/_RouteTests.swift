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
        
        print("0")
        self.setupTests {
            print("1")
            self.dataPupulatorService.createTrapline(code: "LW", numberOfStations: 3, numberOfTrapsPerStation: 1) { (traplineLW) in
                
                if let id = traplineLW?.id {
                    print("2")
                    self.stationService.get(traplineId: id) { (stationsLW) in
                
                        print("3")
                        self.dataPupulatorService.createTrapline(code: "AA", numberOfStations: 4, numberOfTrapsPerStation: 1) { (traplineAA) in
                            
                            if let id = traplineAA?.id {
                                print("4")
                                self.stationService.get(traplineId: id, completion: { (stationsAA) in
                                    
                                    // Create a new Route with Stations in the order of LW01, LW02, AA01, LW03, AA03, AA04
                                    let newRoute = _Route(id: "ER", name: "East Ridge #1")
                                    newRoute.stationIds = [stationsLW[0].id!, stationsLW[1].id!, stationsAA[0].id!, stationsLW[2].id!, stationsAA[2].id!, stationsAA[3].id!]
                                    print("5")
                                    self.routeService.add(route: newRoute, completion: { (route, error) in
                                        if let routeId = route?.id {
                                            print("6")
                                            self.routeService.get(routeId: routeId) { (route, error) in
                                            
                                                print("7")
                                                XCTAssertNil(error)
                                                XCTAssertTrue(route?.stationIds.count == 6)
                                                expect.fulfill()
                                            }
                                        } else {
                                            // route has no id
                                            XCTFail()
                                        }
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
