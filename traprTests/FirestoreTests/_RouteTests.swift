//
//  _RouteTests.swift
//  traprTests
//
//  Created by Andrew Tokeley on 16/11/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import XCTest

@testable import trapr_development

class _RouteTests: FirebaseTestCase {

    let routeService = ServiceFactory.sharedInstance.routeFirestoreService
    let routeUserSettingsService = ServiceFactory.sharedInstance.routeUserSettingsFirestoreService
    let stationService = ServiceFactory.sharedInstance.stationFirestoreService
    let traplineService = ServiceFactory.sharedInstance.traplineFirestoreService
    let visitService = ServiceFactory.sharedInstance.visitFirestoreService
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// Tests that routes created by a user can be retrieved too via security
    func testCreateAndGet() {
        let expect = expectation(description: "testCreateAndGet")
        
        self.routeService.get(routeId: "Cro7vkpJbPAxZdj5swPR") { (route, error) in
            
            XCTAssertNotNil(route)
            
            expect.fulfill()
        }
        

//        self.setupTests {
//
//            self.createTestRoute(name: "TESTRoute") { (route: Route?) in
//                self.routeService.get(routeId: route!.id!) { (route, error) in
//                    
//                    XCTAssertNotNil(route)
//                    
//                    expect.fulfill()
//                }
//            }
//        }
        
        waitForExpectations(timeout: 100) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
          
    func testDaysSinceLastVisit() {
        let expect = expectation(description: "testDaysSinceLastVisit")
        self.setUpTests() {
                    
            // add a new Trapline/Station/Route and 300 day old visit
            self.createTestTrapline(regionId: "REG", traplineCode: "ZZ", numberOfStations: 1) { (trapline, stations) in
                
                self.createTestRoute(name: "TestRoute") { (route: Route?) in
                    
                    self.createTestVisit(Date().add(-400, 0, 0), 0, 0, 0, route!.id!, trapline!.id!, stations[0].id!, TrapTypeCode.doc200, nil, nil) {
                        
                        // test that the days since last visit correct
                        self.routeService.daysSinceLastVisit(routeId: route!.id!) { (days) in
                            XCTAssertTrue(days == 400)
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
    
    func testAddOwners() {
        let expect = expectation(description: "testAddOwners")
        self.setUpTests() {
            
            // add an ownerless route
            
            let route = try! Route(name: "New Route", stationIds: [String]())
            // this will add the current users as the owner and the creator
            let _ = self.routeService.add(route: route) { (route, error) in
                
                // delete the permissions for the current user to the route (they'll just be the creator)
                self.routeUserSettingsService.delete(routeId: route!.id!) { (error) in

                    // we should receive no permissions for the current user
                    self.routeUserSettingsService.get(routeId: route!.id!) { (settings, error) in
                        XCTAssertNil(settings)
                        
                        // this method should give th creator permissions on the route again
                        self.routeService._addOwnerToOwnerlessRoutes {
                            
                            // we should now get permissions for the current user
                            self.routeUserSettingsService.get(routeId: route!.id!) { (settings, error) in
                                XCTAssertNotNil(settings)
                                //
                                expect.fulfill()
                            }
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
    
    func testAddingRouteStations() {
        
        let expect = expectation(description: "testAddingRouteStations")
        
        self.setUpTests {
            // Create LW01, LW02, LW03
            self.createTestTrapline(regionId: "REF", traplineCode: "LW", numberOfStations: 3) { (traplineLW, stationsLW) in
            
                // Create AA01, AA02, AA03, AA04
                self.createTestTrapline(regionId: "REF", traplineCode: "AA", numberOfStations: 4)  { (traplineAA, stationsAA) in
                    
                    // Create a new Route with Stations in the order of LW01, LW02, AA01, LW03, AA03, AA04
                    self.createTestRoute(name: "Route") { (route) in
                    
                        let stationIds = [stationsLW[0].id!, stationsLW[1].id!, stationsAA[0].id!, stationsLW[2].id!, stationsAA[2].id!, stationsAA[3].id!]
                            
                        // Add stations to Route
                        self.routeService.replaceStationsOn(routeId: route!.id!, stationIds: stationIds) { (route, error) in
                            
                            // check route has stations
                            XCTAssertTrue(route?.stationIds.count == 6)
                            XCTAssertTrue(route?.stationIds.first == stationsLW[0].id)
                            XCTAssertTrue(route?.stationIds.last == stationsAA[3].id)
                            
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
    
    func testSetUp() {
        self.setUpTests {
            //check no routes are returned for the current user
            self.routeService.get(completion: { (routes, error) in
                XCTAssertTrue(routes.count == 0)
            })
        }
    }
    
    private func setUpTests(completion: (() -> Void)?) {
        self.deleteTestRoutes {
            self.deleteTestTraplines {
                self.deleteTestStations {
                    self.deleteTestVisits {
                        completion?()
                    }
                }
            }
        }
    }
    
    
//    func testAddStationsToRoute() {
//        
//        // create some stations
//        stationService.deleteAll { (error) in
//            let station1 = Station(number: 1)
//            //station1.
//            self.stationService.add(station: station1, completion: { (station, error) in
//                //
//            })
//        }
//    }
}
