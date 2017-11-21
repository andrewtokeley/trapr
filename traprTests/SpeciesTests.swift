//
//  SpeciesTests.swift
//  traprTests
//
//  Created by Andrew Tokeley  on 5/11/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import XCTest
import RealmSwift

@testable import trapr

class SpeciesTests: XCTestCase {
    
    let service = ServiceFactory.sharedInstance.speciesService
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        ServiceFactory.sharedInstance.dataPopulatorService.deleteAllTestData()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSpeciesDefaults() {
        
        // by default species lookup should be 
        let all = service.getAll()
        XCTAssertTrue(all.count > 0, "Expected more than 0, received \(all.count)")
        
    }
    
    func testGetSpeciesByCode() {
        
        XCTAssertNotNil(service.get(code: "POS"))

    }
    
    
    
}
