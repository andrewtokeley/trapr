//
//  FirestoreDataPopulatorServiceTests.swift
//  traprTests
//
//  Created by Andrew Tokeley on 3/11/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import XCTest

@testable import trapr_development

class DataPopulatorFirestoreServiceTests: XCTestCase {

    let dataPopulatorService = ServiceFactory.sharedInstance.dataPopulatorFirestoreService
    let speciesService = ServiceFactory.sharedInstance.speciesFirestoreService
    let trapTypeService = ServiceFactory.sharedInstance.trapTypeFirestoreService
    let lureService = ServiceFactory.sharedInstance.lureFirestoreService
    let userService = ServiceFactory.sharedInstance.userService
    let traplineService = ServiceFactory.sharedInstance.traplineFirestoreService
    let stationService = ServiceFactory.sharedInstance.stationFirestoreService
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateTrapline() {
        let expect = expectation(description: "testCreateTrapline")
        
        self.traplineService.deleteAll { (error) in
            
            XCTAssertNil(error)
            
            self.dataPopulatorService.createTrapline(code: "LW", numberOfStations: 3, numberOfTrapsPerStation: 1) { (trapline) in
                
                XCTAssertNotNil(trapline)
                XCTAssertTrue(trapline?.code == "LW")
                
                if let id = trapline?.id {
                    self.stationService.get(traplineId: id, completion: { (stations) in
                        
                        XCTAssertNotNil(stations)
                        XCTAssertTrue(stations.count == 3)
                        XCTAssertTrue(stations.first?.number == 1)
                        XCTAssertTrue(stations.last?.number == 3)
                        expect.fulfill()

                    })
                } else {
                    XCTFail()
                }
            }
        }
        
        waitForExpectations(timeout: 100) { (error) in
            if let e = error {
                XCTFail(e.localizedDescription)
            }
        }
    }
    
    func testDeleteAllReadyForTest() {
        
        let expect = expectation(description: "testDeleteAllReadyForTest")
        
        dataPopulatorService.restoreDatabase {
            
            self.userService.getUserStats { (stats, error ) in
                
                if let stats = stats {
                    
                    // No users
                    XCTAssertTrue(stats.count == 0)

                    // check lookups are there
                    self.speciesService.get { (species, error) in
                        XCTAssertNil(error)
                        XCTAssertTrue(species.count > 0)
                    
                        self.trapTypeService.get { (trapTypes, error) in
                            XCTAssertNil(error)
                            XCTAssertTrue(trapTypes.count > 0)
                        
                            // check that additional, non-lookup, fields have been populated
                            if let possumMaster = trapTypes.filter({ (trapType) -> Bool in
                                return trapType.id == TrapTypeCode.possumMaster.rawValue
                            }).first {
                                XCTAssertTrue(possumMaster.defaultLure == LureCode.cereal.rawValue)
                            } else {
                                XCTFail()
                            }
                            
                            self.lureService.get { (lures, error) in
                                XCTAssertNil(error)
                                XCTAssertTrue(lures.count > 0)
                                
                                // Check there aren't any traplines
                                self.traplineService.get { (traplines) in
                                    
                                    XCTAssertTrue(traplines.count == 0)
                                 
                                    self.stationService.get { (stations) in
                                        
                                        XCTAssertTrue(stations.count == 0)
                                        
                                        expect.fulfill()
                                    }
                                    
                                }
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
}
