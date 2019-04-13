//
//  importTests.swift
//  traprTests
//
//  Created by Andrew Tokeley on 8/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import XCTest
//import CSVImporter

@testable import trapr_development

class importTests: XCTestCase {
    
    let traplineService = ServiceFactory.sharedInstance.traplineFirestoreService
    let regionService = ServiceFactory.sharedInstance.regionFirestoreService
    let trapTypeService = ServiceFactory.sharedInstance.trapTypeService
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        ServiceFactory.sharedInstance.dataPopulatorService.restoreDatabase()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testImportFileWithWrongHeaders() {
        
//        let expect = expectation(description: "ImportFileWithWrongHeaders")
//
//        // Create CSV with incorrect/missing Trap Line and Summary headings
//        let csvData = """
//        Trap Line WRONG,,Trap Name,Trap Type,Latitude,Longitude,Notes
//        aaa,,1?,Possum Trap (KBL),-41.311834,174.905899,Should be end if of E near B. Creek
//        """
//
//        var errorCount: Int = 0
//
//        let importer = importer_traplines_v1_to_v2(contentString: csvData, traplineService: traplineService, regionService: regionService)
//        importer.validateFile(onError: { (error) in
//            errorCount += 1
//        }, onCompletion: { (importSummary) in
//            XCTAssert(errorCount == 4) // 4 mandatory headings not present
//            expect.fulfill()
//        })
//
//        waitForExpectations(timeout: 100) { (error) in
//            if let e = error {
//                XCTFail(e.localizedDescription)
//            }
//        }
        
    }
    
    func testImportSuccess() {
        
//        let expect = expectation(description: "testImportSuccess")
//
//        // Create CSV with incorrect/missing Trap Line and Summary headings
//        let csvData = """
//        Region Code,Region Name,Trap Line,Summary
//        TR,Test Region,AA,Summary for AA
//        """
//
//        let importer = importer_traplines_v1_to_v2(contentString: csvData, traplineService: traplineService, regionService: regionService)
//        importer.importAndMerge(onError: { (error) -> Bool in
//            XCTFail("Invalid file")
//            return false
//        }, onCompletion: { (importSummary) in
//
//            //XCTAssertTrue(importSummary.traplinesAddedOrUpdated == 2)
//
//            let traplines = self.traplineService.getTraplines()
//            XCTAssertTrue(traplines?.count == 1)
//            XCTAssertTrue(traplines?.first?.code == "AA")
//            XCTAssertTrue(traplines?.first?.details == "Summary for AA")
//            expect.fulfill()
//        })
//
//        waitForExpectations(timeout: 100) { (error) in
//            if let e = error {
//                XCTFail(e.localizedDescription)
//            }
//        }
//
    }
    
    func testImportSuccessMuktipleLines() {
        
//        let expect = expectation(description: "testImportSuccessMuktipleLines")
//
//        // CSV
//        let csvData = """
//        Region Code,Region Name,Trap Line,Summary
//        TR,Test Region,AA,Summary for AA
//        TR,Test Region,BB,Summary for BB
//        TR,Test Region,CC,Summary for CC
//        """
//
//        let importer = importer_traplines_v1_to_v2(contentString: csvData, traplineService: traplineService, regionService: regionService)
//        importer.importAndMerge(onError: { (error) -> Bool in
//            XCTFail("Invalid file")
//            return false
//        }, onCompletion: { (importSummary) in
//
//            //XCTAssertTrue(importSummary.traplinesAddedOrUpdated == 3)
//
//            let traplines = self.traplineService.getTraplines()
//            XCTAssertTrue(traplines?.count == 3)
//            XCTAssertTrue(traplines?[0].code == "AA")
//            XCTAssertTrue(traplines?[1].code == "BB")
//            XCTAssertTrue(traplines?[2].code == "CC")
//            expect.fulfill()
//        })
//
//        waitForExpectations(timeout: 100) { (error) in
//            if let e = error {
//                XCTFail(e.localizedDescription)
//            }
//        }
        
    }
    
    func testImportAddingAndUpdating() {
        
//        var traplines = ServiceFactory.sharedInstance.traplineService.getTraplines()
//        XCTAssertTrue(traplines?.count == 0)
//
//        let expect = expectation(description: "testImportAddingAndUpdating")
//
//        // Create CSV with incorrect/missing Trap Line and Summary headings
//        var csvData = """
//        Region Code,Region Name,Trap Line,Summary
//        TR,Test Region,AA,Summary for AA
//        TR,Test Region,BB,Summary for BB
//        TR,Test Region,CC,Summary for CC
//        """
//
//        var importer = importer_traplines_v1_to_v2(contentString: csvData, traplineService: traplineService, regionService: regionService)
//        importer.importAndMerge(onError: {
//                (error) in
//                print(error.reason)
//                XCTFail()
//                return false
//        },
//        onCompletion: {
//                (importSummary) in
//
//                traplines = self.traplineService.getTraplines()
//                XCTAssertTrue(traplines?.count == 3, "Expected 3 get \(traplines?.count ?? 0)")
//
//                csvData = """
//                Region Code,Region Name,Trap Line,Summary
//                TR,Test Region,AA,Summary for AA Updated
//                TR,Test Region,DD,Summary for DD Added
//                """
//                importer = importer_traplines_v1_to_v2(contentString: csvData, traplineService: self.traplineService, regionService: self.regionService)
//                importer.importAndMerge(onError: nil, onCompletion: {
//                    (importSummary) in
//
//                    let traplines = self.traplineService.getTraplines()
//                    XCTAssertTrue(traplines?.count == 4, "Expected 4 get \(traplines?.count ?? 0)")
//                    XCTAssertTrue(traplines?[0].code == "AA")
//                    XCTAssertTrue(traplines?[0].details == "Summary for AA Updated", "Actual: \(traplines?[0].details ?? "") ")
//
//                    expect.fulfill()
//                })
//        })
//
//        waitForExpectations(timeout: 100) { (error) in
//            if let e = error {
//                XCTFail(e.localizedDescription)
//            }
//        }
        
    }
    
    func testImportingStationsWithTraps() {
        
//        var traplines = self.traplineService.getTraplines()
//        XCTAssertTrue(traplines?.count == 0)
//
//        let expect = expectation(description: "testImportingStationsWithTraps")
//
//        // Create CSV with 3 stations, one repeated
//        let csvData = """
//        Region Code,Region Name,Trap Line,Summary,Trap Name,Trap Type,Latitude,Longitude,Notes
//        TR,Test Region,AA,Summary for AA, AA01,Possum Master, 1.2, 1.3,Some notes about AA01 Pos Master
//        TR,Test Region,AA,Summary for AA, AA02,Possum Master, 1.2, 1.3,Some notes about AA02 Pos Master
//        TR,Test Region,AA,Summary for AA, AA02,Pelifeed, 22.2, 11.3,Some notes about AA02 Peli
//        TR,Test Region,BB,Summary for BB, BB01,Possum Master, 1.2, 1.3,Some notes about BB01 Pos Master
//        TR,Test Region,BB,Summary for BB, BB02,Haines Trap, 1.2, 1.3,Some notes about BB01 Pos Master
//        """
//
//        let importer = importer_traplines_v1_to_v2(contentString: csvData, traplineService: traplineService, regionService: regionService)
//        importer.importAndMerge(onError: nil, onCompletion: {
//            (importSummary) in
//
//            traplines = self.traplineService.getTraplines()
//            XCTAssertTrue(traplines?.count == 2, "Expected 2 get \(traplines?.count ?? 0)")
//
//            let AAline = self.traplineService.getTrapline(code: "AA")
//
//            XCTAssertTrue(AAline?.stations.count == 2, "Expected 2 get \(AAline?.stations.count ?? 0)")
//            XCTAssertTrue(AAline?.stations[1].code == "02", "Expected 02 get \(AAline?.stations[0].code ?? "")")
//
//            XCTAssertTrue(AAline?.stations[1].traps.count == 2, "Expected 2 get \(AAline?.stations[1].traps.count ?? 0)")
//            XCTAssertTrue(AAline?.stations[1].traps[0].type == ServiceFactory.sharedInstance.trapTypeService.get(.possumMaster))
//            XCTAssertTrue(AAline?.stations[1].traps[1].type == ServiceFactory.sharedInstance.trapTypeService.get(.pellibait))
//            XCTAssertTrue(AAline?.stations[1].traps[1].notes == "Some notes about AA02 Peli")
//            XCTAssertTrue(AAline?.stations[1].traps[1].longitude == 11.3)
//            XCTAssertTrue(AAline?.stations[1].traps[1].latitude == 22.2)
//
//            //XCTAssertTrue(AAline?.stations[1].code == "02", "Expected 02 get \(AAline?.stations[1].code ?? "")")
//
//            expect.fulfill()
//        })
//
//        waitForExpectations(timeout: 100) { (error) in
//            if let e = error {
//                XCTFail(e.localizedDescription)
//            }
//        }
    }
    
    func testImportingOverExisitingData() {
        
//        let expect = expectation(description: "testImportingOverExisitingData")
//        
//        // Add LW01 Possum Master
//        let trapline = Trapline(region: Region(code: "TR", name: "Test Region"), code: "LW")
//
//        XCTAssertNoThrow(try ServiceFactory.sharedInstance.traplineService.add(trapline: trapline))
//        let station = Station(code: "01")
//        self.traplineService.addStation(trapline: trapline, station: station)
//        let trap = Trap()
//        trap.type = self.trapTypeService.get(.possumMaster)
//        self.traplineService.addTrap(station: station, trap: trap)
//        
//        // CSV - add new trap and update notes on possum master trap
//        let csvData = """
//        Region Code,Region Name,Trap Line,Summary,Trap Name,Trap Type,Latitude,Longitude,Notes
//        TR,Test Region,LW - line,Summary for LW,LW01,Possum Master, 1.2, 1.3,Some notes about LW01 Pos Master
//        TR,Test Region,LW - line,Summary for LW,LW01,Pellifeed, 1.2, 1.3,Some notes about LW01 Pel
//        TR,Test Region,LW - line,Summary for LW,LW02,Possum Master, 1.2, 1.3,Some notes about LW02 Pos Master
//        """
//        
//        let importer = importer_traplines_v1_to_v2(contentString: csvData, traplineService: traplineService, regionService: regionService)
//        importer.importAndMerge(onError: nil, onCompletion: {
//            (summary) in
//            
//            if let traplines = self.traplineService.getTraplines() {
//                XCTAssertTrue(traplines.count == 1, "Expected 1 got \(traplines.count)")
//                
//                if let trapline = traplines.first {
//                    XCTAssertTrue(trapline.stations.count == 2, "Exected 2 get \(trapline.stations.count)")
//                    XCTAssertTrue(trapline.stations[0].traps[0].notes == "Some notes about LW01 Pos Master")
//                    XCTAssertTrue(trapline.stations[0].traps[1].notes == "Some notes about LW01 Pel")
//                    XCTAssertTrue(trapline.stations[1].traps[0].type == self.trapTypeService.get(.possumMaster))
//                } else {
//                    XCTFail()
//                }
//            } else {
//                XCTFail()
//            }
//            
//            expect.fulfill()
//        } )
//        
//        waitForExpectations(timeout: 100) { (error) in
//            if let e = error {
//                XCTFail(e.localizedDescription)
//            }
//        }
    }
    
    
}
