//
//  traplineTests.swift
//  trapr
//
//  Created by Andrew Tokeley  on 18/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import XCTest
import RealmSwift

@testable import trapr

class traplineTests: XCTestCase {
    
    lazy var traplineService: TraplineServiceInterface = {
        return ServiceFactory.sharedInstance.traplineService
    }()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        ServiceFactory.sharedInstance.dataPopulatorService.deleteAllDataReadyForTests()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()

    }
    
    func testNewTrapline() {
        
        let trapline = Trapline(region: Region(code: "TR", name:"Test Region"), code: "LW")
        trapline.details = "details"
        
        XCTAssertNoThrow(try traplineService.add(trapline: trapline))
        
        let getTrapline = traplineService.getTraplines() ?? [Trapline]()
        
        XCTAssertTrue(getTrapline.count == 1)
    }
    
    func testNewTraplines() {
        
        for i in 1...10 {
            let trapline = Trapline(region: Region(code: "TR", name: "Test Region"), code:"LW\(String(i))")
            XCTAssertNoThrow(try traplineService.add(trapline: trapline))
        }
        
        let getTraplines = traplineService.getTraplines() ?? [Trapline]()
        
        XCTAssertTrue(getTraplines.count == 10)
    }
    
    func testAddingTrapStations() {
        
        let trapline = Trapline(region: Region(code: "TR", name:"Test Region"), code: "LW")
        XCTAssertNoThrow(try traplineService.add(trapline: trapline))
        
        traplineService.addStation(trapline: trapline, station: Station(code: "01"))
        traplineService.addStation(trapline: trapline, station: Station(code: "02"))
        
        traplineService.addStation(trapline: trapline, station: Station(code: "03"))
        
        let getTrapline = traplineService.getTraplines() ?? [Trapline]()
        
        XCTAssertTrue(getTrapline.count == 1)
        XCTAssertTrue(getTrapline.first!.stations.count == 3)
    }
    
    func testFindTrapline() {
        
        let trapline1 = Trapline(region: Region(code: "TR", name:"Test Region"), code: "LW")
        let trapline2 = Trapline(region: Region(code: "TR", name:"Test Region"), code: "E")
        
        XCTAssertNoThrow(try traplineService.add(trapline: trapline1))
        XCTAssertNoThrow(try traplineService.add(trapline: trapline2))
        
        if let getTrapline = traplineService.getTrapline(code: "E") {
            XCTAssertTrue(getTrapline.code == "E")
        } else {
            XCTFail()
        }
    }
    
    
}
