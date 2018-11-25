//
//  DataPopulatorServiceTests.swift
//  traprTests
//
//  Created by Andrew Tokeley on 29/05/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import XCTest
import RealmSwift

@testable import trapr_development

class DataPopulatorServiceTests: XCTestCase {
    
    let dataPopulationService = ServiceFactory.sharedInstance.dataPopulatorService
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        ServiceFactory.sharedInstance.dataPopulatorService.restoreDatabase()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateTrapline() {
        let LW = dataPopulationService.createTrapline(code: "LW", numberOfStations: 3)
        XCTAssertTrue(LW.stations.count == 3)
    }
    
    func testCreateTraplineTwice() {
        let LW = dataPopulationService.createTrapline(code: "LW", numberOfStations: 3, numberOfTrapsPerStation: 2)
        let AA = dataPopulationService.createTrapline(code: "AA", numberOfStations: 1, numberOfTrapsPerStation: 1)
        XCTAssertTrue(LW.stations.count == 3)
        XCTAssertTrue(AA.stations.count == 1)
    }
}
