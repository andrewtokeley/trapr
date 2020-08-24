//
//  SegmentsTests.swift
//  traprTests
//
//  Created by Andrew Tokeley on 8/08/20.
//  Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import XCTest
@testable import trapr_development

class SegmentsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testClosedSegmentIntegers() throws {

        let segments = Segments(start: 0, segmentLength: 5, numberOfSegments: 5)
        
        XCTAssertTrue(segments.count == 5)
        XCTAssertTrue(segments[0].lowerBound == 0)
        XCTAssertTrue(segments[4].upperBound == 25)
    }

    func testDescriptionRounding() throws {

        // Segments of Doubles 0 - 0.5, 0.5 - 1.0, 1.0 - 1.5
        let segments = Segments(start: 0, segmentLength: 0.5, numberOfSegments: 5)
        let descriptions = segments.segmentDescriptions(roundingPrecision: 2)
        XCTAssert(descriptions[0] == "0.00 - 0.50")
        XCTAssert(descriptions[1] == "0.50 - 1.00")
    }
    
    func testLastDescription() throws {

        let segments1 = Segments(start: 0, segmentLength: 5, numberOfSegments: 5, openEnded: true)
        XCTAssertTrue(segments1.segmentDescriptions().last == "20+" )
        
        let segments2 = Segments(start: 0, segmentLength: 5, numberOfSegments: 5, openEnded: false)
        XCTAssertTrue(segments2.segmentDescriptions().last == "20 - 25" )
        
    }

}
