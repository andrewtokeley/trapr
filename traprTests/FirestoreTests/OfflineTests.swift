//
//  OfflineTests.swift
//  traprTests
//
//  Created by Andrew Tokeley on 18/11/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import XCTest

@testable import trapr_development

class OfflineTests: XCTestCase {

    let speciesService = ServiceFactory.sharedInstance.speciesFirestoreService
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRetrievingFromCacheSuccess() {
        
        let expect = expectation(description: "testRetrievingFromCacheSuccess")
        
        self.speciesService.firestore.enableNetwork { (error) in
            
            // I think this will load into the cache AND server
            self.speciesService.createOrUpdateDefaults {
                
                self.speciesService.firestore.disableNetwork { (error) in
                    
                    self.speciesService.get(completion: { (species, erro) in
                        XCTAssertNil(error)
                        XCTAssert(species.count > 0)
                        expect.fulfill()
                    })
                }
            }
        }
        
        waitForExpectations(timeout: 100) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    func testWritingAndReadingFromCache() {
        
        let expect = expectation(description: "testWritingAndReadingFromCache")
        
        self.speciesService.firestore.enableNetwork { (error) in
            
            // delete from server
            self.speciesService.deleteAll { (error) in
                
                self.speciesService.firestore.disableNetwork { (error) in
                    
                    // Add to cache only
                    let _ = self.speciesService.add(entity: Species(id: "TEST", name: "TESTNAME", order: 1000)) { (species, error) in
                        
                        // get the entity (from cache)
                        self.speciesService.get(id: "TEST") { (species, error) in
                            
                            XCTAssertNil(error)
                            XCTAssertTrue(species?.name == "TESTNAME")
                            XCTAssertTrue(species?.order == 1000)
                            
                            expect.fulfill()
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
    
    func testWhetherCallbackCalledWhenOffline() {
        let expect = expectation(description: "testWhetherCallbackCalledWhenOffline")
        
        let ID = "TestID"
        let NAME = "TestName"
        
        self.speciesService.firestore.disableNetwork { (error) in
            print("1")
            // delete all from server
            self.speciesService.deleteAll { (error) in
                print("2")
                // Add to server, see if callback called
                let _ = self.speciesService.add(entity: Species(id: ID, name: NAME, order: 1000)) { (species, error) in
                    print("3")
                    XCTAssertTrue(true)
                    expect.fulfill()
                }
            }
        }
        
        waitForExpectations(timeout: 10) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    func testWritingToServerReadingBeforeCallback() {
        let expect = expectation(description: "testWritingToServerReadingFromCache")
        
        let ID = "TestID"
        let NAME = "TestName"
        
        self.speciesService.firestore.enableNetwork { (error) in
            
            // delete all from server
            self.speciesService.deleteAll { (error) in
                
                // Add to server - ignore callback
                let _ = self.speciesService.add(entity: Species(id: ID, name: NAME, order: 1000), completion: nil)
                
                // immediately read the results to make sure the cache has the added entity
                self.speciesService.get(id: ID, completion: { (species, error) in
                    XCTAssertNil(error)
                    XCTAssertTrue(species?.id == ID)
                    XCTAssertTrue(species?.name == NAME)
                    expect.fulfill()
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
