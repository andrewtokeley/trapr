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
        print("DELETE ALL")
        ServiceFactory.sharedInstance.applicationService.deleteAllData()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()

    }
    
    func testNewTrapline() {
        print("START testNewTrapline")
        let trapline = Trapline()
        trapline.code = "LW"
        trapline.details = "details"
        
        traplineService.add(trapline: trapline)
        
        let getTrapline = traplineService.getTraplines() ?? [Trapline]()
        
        XCTAssertTrue(getTrapline.count == 1)
    }
    
    func testNewTraplines() {
        print("START testNewTraplines")
        for i in 1...10 {
            let trapline = Trapline()
            trapline.code = "LW\(String(i))"
            traplineService.add(trapline: trapline)
        }
        
        let getTraplines = traplineService.getTraplines() ?? [Trapline]()
        
        XCTAssertTrue(getTraplines.count == 10)
    }
    
    func testAddingTrapStations() {
        print("START testAddingTrapStations")
        let trapline = Trapline()
        trapline.code = "LW"
        let _ = trapline.addStation(code: "01")
        let _ = trapline.addStation(code: "02")
        let _ = trapline.addStation(code: "03")
        
        traplineService.add(trapline: trapline)
        
        let getTrapline = traplineService.getTraplines() ?? [Trapline]()
        
        XCTAssertTrue(getTrapline.count == 1)
        XCTAssertTrue(getTrapline.first!.stations.count == 3)
    }
    
    func testFindTrapline() {
        print("START testFindTrapline")
        
        let trapline1 = Trapline()
        trapline1.code = "LW"
        
        let trapline2 = Trapline()
        trapline2.code = "E"
        
        traplineService.add(trapline: trapline1)
        traplineService.add(trapline: trapline2)
        
        if let getTrapline = traplineService.getTrapline(code: "E") {
            XCTAssertTrue(getTrapline.code == "E")
        } else {
            XCTFail()
        }
    }
    
    
}
