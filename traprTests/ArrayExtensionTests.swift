//
//  ArrayExtensionTests.swift
//  traprTests
//
//  Created by Andrew Tokeley on 20/07/20.
//  Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import XCTest
@testable import trapr_development

class ArrayExtensionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMean() throws {
        
        let set = [10, 20, 50, 100, 20] // total 200
        if let mean = set.map({ Double($0) }).mean() {
            XCTAssert(mean == 40)
        } else {
            XCTFail()
        }
    }

    func testMedian() throws {
        
        let set: [Double] = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
        if let median = set.median() {
            XCTAssert(median == 3.5)
        } else {
            XCTFail()
        }
        
    }
    
    func testMedianEven() throws {
        
        let set: [Double] = [2.0, 1.0, 3.0, 4.0]
        if let median = set.median() {
            XCTAssert(median == 2.5)
        } else {
            XCTFail()
        }
        
    }
    
    func testRankNoRepeats() throws {
        
        let set: [Double] = [2.0, 1.0, 3.0, 4.0, 5.0, 7.0, 6.0]
        if let rank = set.rank(index: 2) {
            XCTAssert(rank.rank == 3)
        } else {
            XCTFail()
        }
        
    }
    
    func testRankWithRepeats() throws {
        
        let set: [Double] = [3.0, 1.0, 3.0, 4.0, 5.0, 7.0, 6.0]
        
        if let rank1 = set.rank(index: 0), let rank2 = set.rank(index: 2) {
            XCTAssert(rank1.rank == 2)
            XCTAssert(rank2.rank == 2)
        } else {
            XCTFail()
        }
        
    }
    
    func testRankOfValueThatExists() throws {
        
        let set: [Double] = [3.0, 1.0, 3.0, 4.0, 5.0, 7.0, 6.0]
        
        if let rank = set.rank(value: 3.0) {
            XCTAssert(rank.rank == 2)
        } else {
            XCTFail()
        }
        
    }
    
    func testRankOfValueThatDoesNotExists() throws {
        
        let set: [Double] = [3.0, 1.0, 3.0, 4.0, 5.0, 7.0, 6.0]
        
        let rank = set.rank(value: 2.0)
        XCTAssertNil(rank)        
    }
    
    func testQuartiles() throws {
    
        let set: [Double] = [19,26,25,37,32,28,22,23,29,34,39,31]
        
        XCTAssert(set.lowerQuartile() == 24.0)
        XCTAssert(set.upperQuartile() == 33.0)
        
    }
    
    func testPerformanceExample() throws {
    // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
