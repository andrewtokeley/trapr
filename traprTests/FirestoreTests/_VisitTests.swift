//
//  VisitTests.swift
//  traprTests
//
//  Created by Andrew Tokeley on 12/11/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import XCTest

@testable import trapr_development
@testable import Viperit

class VisitTests: FirebaseTestCase {

    var routeLWE_Id: String = ""
    var stationLW01_Id: String = ""
    
    let today = Date()
    let lastMonth = Date().add(0, -1, 0)
    
    let visitService = ServiceFactory.sharedInstance.visitFirestoreService
    let speciesService = ServiceFactory.sharedInstance.speciesFirestoreService
    let traplineService = ServiceFactory.sharedInstance.traplineFirestoreService
    let regionService = ServiceFactory.sharedInstance.regionFirestoreService
    let stationService = ServiceFactory.sharedInstance.stationFirestoreService
    let routeService = ServiceFactory.sharedInstance.routeFirestoreService
    let visitSummaryService = ServiceFactory.sharedInstance.visitSummaryFirestoreService
    
    override func setUp() {
        super.setUp()
        
        // create new test data
        let expect = expectation(description: "SetUp")
        self.createTestData {
            expect.fulfill()
        }
        
        // wait for the test data to be created
        waitForExpectations(timeout: 100, handler: nil)
    }

    override func tearDown() {
        super.tearDown()
        
        // create new test data
        let expect = expectation(description: "tearDown")
        self.deleteTestData {
            expect.fulfill()
        }
        
        // wait for the test data to be created
        waitForExpectations(timeout: 100, handler: nil)
    }
    
    /// Deletes all test data
    func deleteTestData(completion: (() -> Void)?) {
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
    
    /**
     Create...
     
     RouteLW-E
     - LW01 (Possum Master)
        - today (possum)
        - a month ago (possum)
     - LW01 (Pellibait)
        - today (peli, 2, 4, 6)
        - a month ago (10, 0, 0) opening balance
     - E01 (DOC200)
        - today (rat)
     
     RouteGC
     - GC01 (Pellibait)
        - today (1, 2, 3)
     */
    func createTestData(completion: (() -> Void)?) {
        self.createTestTrapline(regionId: "REG", traplineCode: "LW", numberOfStations: 1) { (traplineLW, stations) in
            let stationLW01 = stations.first!
            self.stationLW01_Id = stationLW01.id!
            self.createTestTrapline(regionId: "REG", traplineCode: "E", numberOfStations: 1) { (traplineLW, stations) in
                let stationE01 = stations.first!
                self.createTestTrapline(regionId: "REG", traplineCode: "GC", numberOfStations: 1) { (traplineGC, stations) in
                    let stationGC01 = stations.first!
                    self.createTestRoute(name: "RouteLW-E",stationIds: ["LW01", "E01"]) { (routeLWE) in
                        self.routeLWE_Id = routeLWE!.id!
                        self.createTestRoute(name: "RouteGC",stationIds: ["GC01"]) { (routeGC) in
                            let dispatchGroup = DispatchGroup()
                            
                            // LW01 PossumMaster, Possum, today
                            dispatchGroup.enter()
                            self.createTestVisit(self.today, 0, 0, 0, SpeciesCode.possum, routeLWE!.id!, traplineLW!.id!, stationLW01.id!, TrapTypeCode.possumMaster) { dispatchGroup.leave() }
                            
                            // LW01 PossumMaster, Possum, month ago
                            dispatchGroup.enter()
                            self.createTestVisit(self.lastMonth, 0, 0, 0, SpeciesCode.possum, routeLWE!.id!, traplineLW!.id!, stationLW01.id!, TrapTypeCode.possumMaster) { dispatchGroup.leave() }
                            
                            // LW01 Pellibat, today, 2, 4, 6
                            dispatchGroup.enter()
                            self.createTestVisit(self.today, 2, 4, 6, nil, routeLWE!.id!, traplineLW!.id!, stationLW01.id!, TrapTypeCode.pellibait) { dispatchGroup.leave() }
                            
                            // LW01 Pellibait, a month ago (10, 0, 0) opening balance
                            dispatchGroup.enter()
                            self.createTestVisit(self.today, 10, 0, 0, nil, routeLWE!.id!, traplineLW!.id!, stationLW01.id!, TrapTypeCode.pellibait) { dispatchGroup.leave() }
                            
                            // E01 Doc200, rat, today
                            dispatchGroup.enter()
                            self.createTestVisit(self.today, 0, 0, 0, SpeciesCode.rat, routeLWE!.id!, traplineLW!.id!, stationE01.id!, TrapTypeCode.doc200) { dispatchGroup.leave() }
                            
                            // GC01 Pellibait, today, 1, 2, 3
                            dispatchGroup.enter()
                            self.createTestVisit(self.today, 1, 2, 3, nil, routeGC!.id!, traplineGC!.id!, stationGC01.id!, TrapTypeCode.pellibait) { dispatchGroup.leave() }
                            
                            dispatchGroup.notify(queue: .main) {
                                completion?()
                            }
                        }
                    }
                }
            }
        }
    }
    
//    func testCreateData() {
//        let expect = expectation(description: "testCreateData")
//
//
//        waitForExpectations(timeout: 100) { (error) in
//            if let e = error {
//                XCTFail(e.localizedDescription)
//            }
//        }
//    }
    
    func testLureBalanceFutureDate() {
        
        let expect = expectation(description: "testLureBalanceFutureDate")
       
        self.stationService.getLureBalance(stationId: stationLW01_Id, trapTypeId: TrapTypeCode.pellibait.rawValue, asAtDate: self.today.add(10, 0, 0), completion: { (balance) in
            XCTAssertTrue(balance == 10)
            expect.fulfill()
        })
        
        waitForExpectations(timeout: 100) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    func testLureBalanceBeforeAnyVisits() {
        
        let expect = expectation(description: "testLureBalanceBeforeAnyVisits")
        
        self.createTestData {
            self.stationService.getLureBalance(stationId: self.stationLW01_Id, trapTypeId: TrapTypeCode.pellibait.rawValue, asAtDate: self.lastMonth.add(0, 0, -100), completion: { (balance) in
                XCTAssertTrue(balance == 0)
                expect.fulfill()
            })
        }
        
        waitForExpectations(timeout: 100) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    func testGetVisitSummaryRouteLWEToday() {
        
        let expect = expectation(description: "testGetVisitSummaryRouteLWEToday")

        self.createTestData {
            self.visitSummaryService.get(date: self.today, routeId: self.routeLWE_Id, completion: { (summary, error) in
                
                XCTAssertNil(error)
                if let summary = summary {
                    XCTAssertTrue(summary.routeId == self.routeLWE_Id)
                    XCTAssertTrue(summary.visits.count == 3)
                    XCTAssertTrue(summary.numberOfTrapsVisited == 3)
                    XCTAssertTrue(summary.numberOfTrapsOnRoute == 3)
                    XCTAssertTrue(summary.totalKills == 2)
                    XCTAssertTrue(summary.totalKillsBySpecies.count == 2)
                    XCTAssertTrue(summary.totalKillsBySpecies[SpeciesCode.rat.rawValue] == 1)
                    XCTAssertTrue(summary.totalKillsBySpecies[SpeciesCode.possum.rawValue] == 1)
                    XCTAssertTrue(summary.totalPoisonAdded == 6) // pelifeed
                    
                } else {
                    XCTFail()
                }
                
                expect.fulfill()
            })
        }
        waitForExpectations(timeout: 100) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    func testGetVisitSummaryRouteLWELastMonth() {
        
        let expect = expectation(description: "testGetVisitSummaryRouteLWELastMonth")
        
        self.createTestData {
            self.visitSummaryService.get(date: self.lastMonth, routeId: self.routeLWE_Id, completion: { (summary, error) in
                
                XCTAssertNil(error)
                if let summary = summary {
                    XCTAssertTrue(summary.routeId == self.routeLWE_Id)
                    XCTAssertTrue(summary.visits.count == 1)
                    XCTAssertTrue(summary.numberOfTrapsVisited == 1)
                    XCTAssertTrue(summary.numberOfTrapsOnRoute == 3)
                    XCTAssertTrue(summary.totalKills == 1)
                    XCTAssertTrue(summary.totalKillsBySpecies.count == 1)
                    XCTAssertTrue(summary.totalKillsBySpecies[SpeciesCode.possum.rawValue] == 1)
                    XCTAssertTrue(summary.totalPoisonAdded == 0) // pelifeed
                    
                } else {
                    XCTFail()
                }
                
                expect.fulfill()
            })
        }
        waitForExpectations(timeout: 100) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
        
    }
    
    func testGetVisitForRouteAndTrapType() {
        
        let expect = expectation(description: "testGetVisitForRouteAndTrapType")
        
        createTestData {
            self.visitService.get(recordedOn: self.today, routeId: self.routeLWE_Id, stationId: self.stationLW01_Id, trapTypeId: TrapTypeCode.possumMaster.rawValue, completion: { (visits, error) in
                
                XCTAssertTrue(visits.count == 1)
                
                self.visitService.get(recordedOn: self.today, routeId: self.routeLWE_Id, stationId: self.stationLW01_Id, trapTypeId: TrapTypeCode.timms.rawValue, completion: { (visits, error) in
                    
                    XCTAssertTrue(visits.count == 0)
                    
                    expect.fulfill()
                })
            })
        }
        
        waitForExpectations(timeout: 100) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    func testGetSummaries() {
        
        let expect = expectation(description: "testGetSummaries")
    
        self.visitSummaryService.get(recordedBetween: self.lastMonth.add(-1, 0, 0), endDate: self.today.add(1, 0, 0), routeId: self.routeLWE_Id) { (summaries, error) in
            
            // two separate days
            XCTAssert(summaries.count == 2)
            
            expect.fulfill()
        }
    
        
        waitForExpectations(timeout: 100) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    func testGetKillCountsForCharts() {
        let expect = expectation(description: "testGetKillCountsForCharts")
        
        createTestData() {
            
            let interactor = RouteDashboardInteractor()
            self.visitSummaryService.get(recordedBetween: Date().add(0, 0, -100), endDate: Date(), routeId: self.routeLWE_Id, completion: { (summaries, error) in
                
                if let stackCount = interactor.killCounts(visitSummaries: summaries) {
                    XCTAssertTrue(stackCount.labels.count == 2) // RAT, POS
                    if let possumIndex = stackCount.labels.firstIndex(of: SpeciesCode.possum.rawValue), let ratIndex = stackCount.labels.firstIndex(of: SpeciesCode.rat.rawValue) {
                        
                        // 1 pos + 1 rat kill in current month.
                        XCTAssertTrue(stackCount.counts[11][possumIndex] == 1)
                        XCTAssertTrue(stackCount.counts[11][ratIndex] == 1)
                        
                        // 1 pos last month
                        XCTAssertTrue(stackCount.counts[10][possumIndex] == 1)
                    } else {
                        XCTFail()
                    }
                } else {
                    XCTFail()
                }
                expect.fulfill()
            })
        }
        
        waitForExpectations(timeout: 100) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
}
