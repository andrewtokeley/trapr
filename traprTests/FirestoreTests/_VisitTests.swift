//
//  _VisitTests.swift
//  traprTests
//
//  Created by Andrew Tokeley on 12/11/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import XCTest

@testable import trapr_development
@testable import Viperit

class _VisitTests: XCTestCase {

    let route1_Id = "routeid1"
    let route2_Id = "routeid2"
    
    let today = Date()
    let lastMonth = Date().add(0, -1, 0)
    
    var testDataCreated = false
    
    let dataPopulator = ServiceFactory.sharedInstance.dataPopulatorFirestoreService
    let visitService = ServiceFactory.sharedInstance.visitFirestoreService
    let speciesService = ServiceFactory.sharedInstance.speciesFirestoreService
    let traplineService = ServiceFactory.sharedInstance.traplineFirestoreService
    let regionService = ServiceFactory.sharedInstance.regionFirestoreService
    let stationService = ServiceFactory.sharedInstance.stationFirestoreService
    let routeService = ServiceFactory.sharedInstance.routeFirestoreService
    let visitSummaryService = ServiceFactory.sharedInstance.visitSummaryFirestoreService
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
        if !testDataCreated {
            dataPopulator.restoreDatabase {
                
                // Add Region
                let regionId = "EHRP"
                let region = _Region(id: regionId, name: "Eastbourne Harbour Regional Park", order: 0)
                
                let route1 = _Route(id: self.route1_Id, name: "Route1")
                let route2 = _Route(id: self.route2_Id, name: "Route2")
                
                self.routeService.add(route: route1) { (route1, error) in
                    self.routeService.add(route: route2) { (route2, error) in
                        self.regionService.add(lookup: region) { (error) in
                        
                            // LW01 (Possum Master and Pellibait)
                            let trapline = _Trapline(code: "LW", regionCode: regionId, details: "Trapline1")
                            let station = _Station(traplineId: trapline.id!, number: 1)
                            station.routeId = self.route1_Id
                            station.trapTypes.append(TrapTypeStatus(trapTpyeId: TrapTypeCode.possumMaster.rawValue, active: true))
                            station.trapTypes.append(TrapTypeStatus(trapTpyeId: TrapTypeCode.pellibait.rawValue, active: true))
                            self.dataPopulator.createTraplineWithStations(trapline: trapline, stations: [station]) { (error) in
                                
                                // LW01 - Visit: Today, Possum Master, Possum
                                let visit = _Visit(date: self.today, routeId: self.route1_Id, traplineId: trapline.id!, stationId: station.id!, trapTypeId: TrapTypeCode.possumMaster.rawValue)
                                visit.speciesId = SpeciesCode.possum.rawValue
                                self.visitService.add(visit: visit) { (visit, error) in
                                    
                                    // LW01 - Visit: Today, Pellibait, 2, 4, 6
                                    let visit = _Visit(date: self.today, routeId: self.route1_Id, traplineId: trapline.id!, stationId: station.id!, trapTypeId: TrapTypeCode.pellibait.rawValue)
                                    visit.baitRemoved = 2
                                    visit.baitEaten = 4
                                    visit.baitAdded = 6
                                    self.visitService.add(visit: visit) { (visit, error) in
                                    
                                        // LW01 - Visit: Last Month, Possum Master, Possum
                                        let visit = _Visit(date: self.lastMonth, routeId: self.route1_Id, traplineId: trapline.id!, stationId: station.id!, trapTypeId: TrapTypeCode.possumMaster.rawValue)
                                        visit.speciesId = SpeciesCode.possum.rawValue
                                        self.visitService.add(visit: visit) { (visit, error) in
                                            
                                            // LW01 - Visit: Last Month, Pelibait, 10 opening balance
                                            let visit = _Visit(date: self.lastMonth, routeId: self.route1_Id, traplineId: trapline.id!, stationId: station.id!, trapTypeId: TrapTypeCode.pellibait.rawValue)
                                            visit.baitAdded = 10
                                            self.visitService.add(visit: visit) { (visit, error) in
                                                
                                                // E01 (DOC200)
                                                let trapline = _Trapline(code: "E01", regionCode: regionId, details: "Trapline2")
                                                    let station = _Station(traplineId: trapline.id!, number: 1)
                                                station.routeId = self.route1_Id
                                                station.trapTypes.append(TrapTypeStatus(trapTpyeId: TrapTypeCode.doc200.rawValue, active: true))
                                                self.dataPopulator.createTraplineWithStations(trapline: trapline, stations: [station]) { (error) in
                                                    
                                                    // E01 - Visit: Today, DOC200, Rat
                                                    let visit = _Visit(date: self.today, routeId: self.route1_Id, traplineId: trapline.id!, stationId: station.id!, trapTypeId: TrapTypeCode.doc200.rawValue)
                                                    visit.speciesId = SpeciesCode.rat.rawValue
                                                    self.visitService.add(visit: visit) { (visit, error) in
                                                    
                                                        // GC01 (Pellibait)
                                                        let trapline = _Trapline(code: "GC01", regionCode: regionId, details: "Trapline3")
                                                        let station = _Station(traplineId: trapline.id!, number: 1)
                                                        station.routeId = self.route2_Id
                                                        station.trapTypes.append(TrapTypeStatus(trapTpyeId: TrapTypeCode.pellibait.rawValue, active: true))
                                                        self.dataPopulator.createTraplineWithStations(trapline: trapline, stations: [station]) { (error) in
                                                            
                                                            // GC01 - Visit: Today, Pellibait, 1, 2, 3
                                                            let visit = _Visit(date: self.today, routeId: self.route2_Id, traplineId: trapline.id!, stationId: station.id!, trapTypeId: TrapTypeCode.pellibait.rawValue)
                                                            visit.baitRemoved = 1
                                                            visit.baitEaten = 2
                                                            visit.baitAdded = 3
                                                            
                                                            self.visitService.add(visit: visit) { (visit, error) in
                                                                self.testDataCreated = true
                                                                completion?()
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else {
            completion?()
        }
    }
    
    func testAddVisit() {
        let expect = expectation(description: "testAddVisit")
        
        self.visitService.deleteAll { (error) in
            let visit = _Visit(date: self.today, routeId: "r", traplineId: "tl", stationId: "s", trapTypeId: "tt")
            self.visitService.add(visit: visit, completion: { (visit, error) in
                
                XCTAssertNil(error)
                
                if let id = visit?.id {
                    self.visitService.get(id: id) { (visit, error) in
                        XCTAssertNotNil(visit)
                        if let visit = visit {
                            XCTAssertTrue(visit.routeId == "r")
                            XCTAssertTrue(visit.visitDateTime.day == self.today.day, "\(visit.visitDateTime.day) doesn't match \(self.today.day)")
                            XCTAssertTrue(visit.visitDateTime.month == self.today.month, "\(visit.visitDateTime.day) doesn't match \(self.today.day)")
                            XCTAssertTrue(visit.visitDateTime.year == self.today.year, "\(visit.visitDateTime.day) doesn't match \(self.today.day)")
                        }
                        expect.fulfill()
                    }
                } else {
                    XCTFail()
                    expect.fulfill()
                }
                
            })
        }

        waitForExpectations(timeout: 100) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    func testLureBalanceFutureDate() {
        
        let expect = expectation(description: "testLureBalanceFutureDate")
        
        self.createTestData {
            self.stationService.getLureBalance(stationId: "EHRP-LW-01", trapTypeId: TrapTypeCode.pellibait.rawValue, asAtDate: self.today.add(10, 0, 0), completion: { (balance) in
                XCTAssertTrue(balance == 10)
                expect.fulfill()
            })
        }
        
        waitForExpectations(timeout: 100) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    func testLureBalanceBeforeAnyVisits() {
        
        let expect = expectation(description: "testLureBalanceBeforeAnyVisits")
        
        self.createTestData {
            self.stationService.getLureBalance(stationId: "EHRP-LW-01", trapTypeId: TrapTypeCode.pellibait.rawValue, asAtDate: self.lastMonth.add(0, 0, -100), completion: { (balance) in
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
            self.visitSummaryService.get(date: self.today, routeId: self.route1_Id, completion: { (summary, error) in
                
                XCTAssertNil(error)
                if let summary = summary {
                    XCTAssertTrue(summary.routeId == self.route1_Id)
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
            self.visitSummaryService.get(date: self.lastMonth, routeId: self.route1_Id, completion: { (summary, error) in
                
                XCTAssertNil(error)
                if let summary = summary {
                    XCTAssertTrue(summary.routeId == self.route1_Id)
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
            self.visitService.get(recordedOn: self.today, routeId: self.route1_Id, trapTypeId: TrapTypeCode.possumMaster.rawValue, completion: { (visits, error) in
                
                XCTAssertTrue(visits.count == 1)
                
                self.visitService.get(recordedOn: self.today, routeId: self.route1_Id, trapTypeId: TrapTypeCode.timms.rawValue, completion: { (visits, error) in
                    
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
        createTestData {
            
            self.visitSummaryService.get(recordedBetween: self.lastMonth.add(-1, 0, 0), endDate: self.today.add(1, 0, 0), routeId: self.route1_Id) { (summaries, error) in
                
                // two separate days
                XCTAssert(summaries.count == 2)
                
                expect.fulfill()
            }
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
            self.visitSummaryService.get(recordedBetween: Date().add(0, 0, -100), endDate: Date(), routeId: self.route1_Id, completion: { (summaries, error) in
                
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
    
//    func testCreate() {
//
//        let expect = expectation(description: "testCreate")
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        self.createTestData {
//            XCTAssertTrue(1 == 1)
//            expect.fulfill()
//        }
//
//        waitForExpectations(timeout: 100) { (error) in
//            if let e = error {
//                XCTFail(e.localizedDescription)
//            }
//        }
//    }


}
