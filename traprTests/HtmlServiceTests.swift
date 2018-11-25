//
//  HtmlServiceTests.swift
//  traprTests
//
//  Created by Andrew Tokeley on 26/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import XCTest

@testable import trapr_development

class HtmlServiceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSimple() {
        
        let htmlService = ServiceFactory.sharedInstance.htmlService
        let dataService = ServiceFactory.sharedInstance.dataPopulatorService
        //let visitService = ServiceFactory.sharedInstance.visitService
        
        let trapline = dataService.createTrapline(code: "LW", numberOfStations: 3, numberOfTrapsPerStation: 2)
        let route = Route(name: "LW Route", stations: Array(trapline.stations))
        
        dataService.createVisit(1, 1, 1, Date(), route, trapline.stations[0].traps[0])
        dataService.createVisit(2, 1, 1, Date(), route, trapline.stations[0].traps[1])
        dataService.createVisit(3, 1, 1, Date(), route, trapline.stations[1].traps[0])
        dataService.createVisit(4, 1, 1, Date(), route, trapline.stations[1].traps[1])
        dataService.createVisit(5, 1, 1, Date(), route, trapline.stations[2].traps[0])
        dataService.createVisit(6, 1, 1, Date(), route, trapline.stations[2].traps[1])
        
        let html = htmlService.getVisitsAsHtml(recordedOn: Date(), route: route)
        
        XCTAssertTrue(html != nil)
    }
    
    func testOrderAscendingByStationLongCodeThenTrapOrder() {
        
        let htmlService = ServiceFactory.sharedInstance.htmlService
        let dataService = ServiceFactory.sharedInstance.dataPopulatorService
        //let visitService = ServiceFactory.sharedInstance.visitService
        
        // Create;
        // LW01 Pellibait
        // LW01 Possum Master
        // LW02 Pellibait
        // LW02 Pellibait
        // LW03 Pellibait
        // LW03 Pellibait
        // AA01 Pellibait
        
        let LW = dataService.createTrapline(code: "LW", numberOfStations: 3, numberOfTrapsPerStation: 2)
        let AA = dataService.createTrapline(code: "AA", numberOfStations: 1, numberOfTrapsPerStation: 1)
        
        let route = Route(name: "LW-AA Route", stations: [
            LW.stations[0],
            LW.stations[1],
            LW.stations[2],
            AA.stations[0]
            ])
        
        // visit every trap
        dataService.createVisit(1, 1, 1, Date(), route, LW.stations[0].traps[0])
        dataService.createVisit(2, 1, 1, Date(), route, LW.stations[0].traps[1])
        dataService.createVisit(3, 1, 1, Date(), route, LW.stations[1].traps[0])
        dataService.createVisit(4, 1, 1, Date(), route, LW.stations[1].traps[1])
        dataService.createVisit(5, 1, 1, Date(), route, LW.stations[2].traps[0])
        dataService.createVisit(6, 1, 1, Date(), route, LW.stations[2].traps[1])
        dataService.createVisit(6, 1, 1, Date(), route, AA.stations[0].traps[0])
        
        let html = htmlService.getVisitsAsHtml(recordedOn: Date(), route: route)
        
        XCTAssertTrue(html != nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
