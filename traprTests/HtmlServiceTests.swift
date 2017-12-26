//
//  HtmlServiceTests.swift
//  traprTests
//
//  Created by Andrew Tokeley on 26/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import XCTest
@testable import trapr

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
        
        let html = htmlService.getVisitsAsHtmlTable(recordedOn: Date(), route: route)
        
        XCTAssertTrue(html != nil)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
