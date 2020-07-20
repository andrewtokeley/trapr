//
//  HtmlServiceTests.swift
//  traprTests
//
//  Created by Andrew Tokeley on 26/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import XCTest

@testable import trapr_development

class HtmlServiceTests: FirebaseTestCase {
    private let htmlService = ServiceFactory.sharedInstance.htmlService
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSimple() {
        
        self.createTestTrapline(regionId: "REG", traplineCode: "LW", numberOfStations: 3) { (trapline, stations) in
            self.createTestRoute(name: "Route", stationIds: stations.map( { $0.id! })) { (route) in
                self.createVisit(1, 1, 1, nil, route!, trapline!, stations[0], TrapTypeCode.doc200) {
                    self.createVisit(2, 1, 1, nil, route!, trapline!, stations[0], TrapTypeCode.doc200) {
                        self.createVisit(3, 1, 1, nil, route!, trapline!, stations[1], TrapTypeCode.doc200) {
                            self.createVisit(4, 1, 1, nil, route!, trapline!, stations[1], TrapTypeCode.doc200) {
                                self.createVisit(5, 1, 1, nil, route!, trapline!, stations[2], TrapTypeCode.doc200) {
                                    self.createVisit(6, 1, 1, nil, route!, trapline!, stations[2], TrapTypeCode.doc200) {
                                        self.htmlService.getVisitsAsHtml(recordedOn: Date(), route: route!) { (html) in
                                            XCTAssertTrue(html != nil)
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
    
    func testOrderAscendingByStationLongCodeThenTrapOrder() {
        
        self.createTestTrapline(regionId: "REG", traplineCode: "LW", numberOfStations: 3) { (traplineLW, stationsLW) in
            self.createTestTrapline(regionId: "REG", traplineCode: "AA", numberOfStations: 1) { (traplineAA, stationsAA) in
                
                let stationIds = stationsLW.map( { $0.id! } ) + stationsAA.map( { $0.id! } )
                self.createTestRoute(name: "Route", stationIds: stationIds) { (route) in
                    self.createVisit(1, 1, 1, nil, route!, traplineLW!, stationsLW[0], TrapTypeCode.doc200) {
                        self.createVisit(1, 1, 1, nil, route!, traplineLW!, stationsLW[1], TrapTypeCode.doc200) {
                            self.createVisit(1, 1, 1, nil, route!, traplineLW!, stationsLW[0], TrapTypeCode.doc200) {
                                self.createVisit(1, 1, 1, nil, route!, traplineLW!, stationsLW[0], TrapTypeCode.doc200) {
                                    self.createVisit(1, 1, 1, nil, route!, traplineLW!, stationsLW[0], TrapTypeCode.doc200) {
                                        self.createVisit(1, 1, 1, nil, route!, traplineLW!, stationsLW[0], TrapTypeCode.doc200) {
                                            self.createVisit(1, 1, 1, nil, route!, traplineAA!, stationsAA[0], TrapTypeCode.doc200) {
                                                
                                                self.htmlService.getVisitsAsHtml(recordedOn: Date(), route: route!, completion: { (html) in
                                                    // how to test??
                                                    XCTAssertTrue(html != nil)
                                                })
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
    
    private func createVisit(_ baitAdded: Int = 0, _ baitEaten: Int = 0, _ baitRemoved: Int = 0, _ species: Species? = nil, _ route: Route, _ trapline: Trapline, _ station: Station, _ trapType: TrapTypeCode, completion: (() -> Void)?) {

        self.createTestVisit(Date(), baitAdded, baitEaten, baitRemoved, route.id!, trapline.id!, station.id!, trapType, nil, nil) {
            completion?()
        }
    }
}
