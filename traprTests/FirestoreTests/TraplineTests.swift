//
//  traplineTests.swift
//  trapr
//
//  Created by Andrew Tokeley  on 18/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import XCTest

@testable import trapr_development

class TraplineTests: XCTestCase {
    
    let traplineService = ServiceFactory.sharedInstance.traplineFirestoreService
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()

    }
    
    func testNewTrapline() {
        let expect = expectation(description: "testNewTrapline")
        
        self.traplineService.deleteAll { (error) in
            
            XCTAssertNil(error)
            
            let trapline = Trapline(code: "LW", regionCode: "ABC", details: "Lowry")
            let _ = self.traplineService.add(trapline: trapline) { (trapline, error) in

                // successful add if no error
                XCTAssertNil(error)
                
                // get the trap back and make sure it's all there
                self.traplineService.get { (traplines) in
                    if let trapline = traplines.first {
                        XCTAssertTrue(trapline.code == "LW")
                        XCTAssertTrue(trapline.details == "Lowry")
                        XCTAssertTrue(trapline.regionCode == "ABC")
                    } else {
                        XCTFail()
                    }
                    
                    expect.fulfill()
                }
            }
        }
        
        waitForExpectations(timeout: 100) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
        
    }
    
    func testNewTraplines() {
        
        let expect = expectation(description: "testNewTraplines")
        let dispatchGroup = DispatchGroup()
        
        self.traplineService.deleteAll { (error) in
            XCTAssertNil(error)
            for i in 1...10 {
                let trapline = Trapline(code: "LW\(String(i))", regionCode: "TR", details: "Test")
                dispatchGroup.enter()
                let _ = self.traplineService.add(trapline: trapline, completion: { (trapline, error) in
                    XCTAssertNil(error)
                    XCTAssertNotNil(trapline)
                    dispatchGroup.leave()
                })
            }
            // wait for all traplines to be added
            dispatchGroup.notify(queue: .main) {
                self.traplineService.get { (traplines) in
                    XCTAssertTrue(traplines.count == 10)
                    expect.fulfill()
                }
            }
        }
        
        // wait for the test to complete before leaving the function
        waitForExpectations(timeout: 100) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    
    func testFindTraplineByRegion() {
        let expect = expectation(description: "testNewTrapline")
        
        let REGIONID = "REG"
        let trapline1 = Trapline(code: "LW", regionCode: REGIONID, details: "Lowry")
        let trapline2 = Trapline(code: "GC", regionCode: REGIONID, details: "Golf Course")
        
        let _ = self.traplineService.add(trapline: trapline1) { (trapline, error) in
            let _ = self.traplineService.add(trapline: trapline2) { (trapline, error) in
                self.traplineService.get(regionId: REGIONID, completion: { (traplines) in
                    XCTAssertTrue(traplines.count == 2)
                    
                    self.traplineService.delete(trapline: trapline1, completion: { (error) in
                        self.traplineService.delete(trapline: trapline2, completion: { (error) in
                            expect.fulfill()
                        })
                    })
                    
                })
            }
        }
        
        waitForExpectations(timeout: 100) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }

    }
    
    
}
