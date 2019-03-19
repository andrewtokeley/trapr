//
//  LookupTests.swift
//  traprTests
//
//  Created by Andrew Tokeley on 5/11/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import XCTest

@testable import trapr_development

class LookupTests: XCTestCase {

    let trapTypeService = ServiceFactory.sharedInstance.trapTypeFirestoreService
    let speciesService = ServiceFactory.sharedInstance.speciesFirestoreService
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreatingDefaultsMerge() {
        let expect = expectation(description: "testCreatingDefaultsMerge")
        
        let doc200 = TrapTypeCode.doc200.rawValue
        
        // remove all traptypes
        self.trapTypeService.deleteAll() { (error) in
            
            self.trapTypeService.createOrUpdateDefaults {
                
                // add one of the defaults (with the right id but incorrect name and order)
                self.trapTypeService.add(lookup: TrapType(id: doc200, name: "DOC200 NEW", order: 100)) { (error) in
                
                    // add a random one (this shouldn't be affected by running defaults)
                    self.trapTypeService.add(lookup: TrapType(id: "TEST", name: "TEST", order: 200)) { (error) in

                        // refresh defaults, make sure it's not destructive
                        self.trapTypeService.createOrUpdateDefaults() {
                            
                            self.trapTypeService.get() { (traptypes, error) in
                                
                                // check that the doc200 is still there and not updated
                                if let doc = traptypes.first(where: { (trapType) -> Bool in
                                    trapType.id == doc200
                                }) {
                                    XCTAssertTrue(doc.name == doc200)
                                    XCTAssertTrue(doc.order != 100)
                                }
                                
                                // check that the TEST one is unaffected
                                if let test = traptypes.first(where: { (trapType) -> Bool in
                                    trapType.id == "TEST"
                                }) {
                                    XCTAssertTrue(test.name == "TEST")
                                    XCTAssertTrue(test.order == 200)
                                }
                                
                                expect.fulfill()
                            }
                        }
                    }
                }
            }
        }
        
        waitForExpectations(timeout: 100) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    func testGetByCodes() {
        
        let expect = expectation(description: "testGetByCodes")
            
        self.trapTypeService.deleteAll { error in
        
            self.trapTypeService.createOrUpdateDefaults {
                
                self.trapTypeService.get(completion: { (trapTypes, error) in
                    
                    // make sure we a few in here (should have been put in from deleteAllDataReadyForTests)
                    XCTAssertTrue(trapTypes.count > 2 )
                    
                    // search for a couple only
                    self.trapTypeService.get(ids: [
                        TrapTypeCode.doc200.rawValue, TrapTypeCode.pellibait.rawValue]) { (trapTypes, error) in
                            
                            XCTAssertTrue(trapTypes.count == 2)
                            XCTAssertTrue(trapTypes.contains(where: { (trapType) -> Bool in
                                return trapType.id == TrapTypeCode.doc200.rawValue
                            }))
                            XCTAssertTrue(trapTypes.contains(where: { (trapType) -> Bool in
                                return trapType.id == TrapTypeCode.pellibait.rawValue
                            }))
                        
                            expect.fulfill()
                    }
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
