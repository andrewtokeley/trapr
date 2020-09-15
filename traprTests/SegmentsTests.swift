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

        let segments = try? SegmentCollection(start: 0, segmentLength: 5, numberOfSegments: 5)
        
        XCTAssertNotNil(segments)
        XCTAssertTrue(segments?.count == 5)
        XCTAssertTrue(segments?[0].range.lowerBound == 0)
        XCTAssertTrue(segments?[4].range.upperBound == 25)
    }
    
    func testLastDescription() throws {

        let segments1 = try? SegmentCollection(start: 0, segmentLength: 5, numberOfSegments: 5, openEnded: true)
        XCTAssertNotNil(segments1)
        XCTAssertTrue(segments1?.last?.description == "20+" )
        
        let segments2 = try? SegmentCollection(start: 0, segmentLength: 5, numberOfSegments: 5, openEnded: false)
        XCTAssertNotNil(segments2)
        XCTAssertTrue(segments2?.last?.description == "20 - 25" )
        
    }

    func testZeroSegment() throws {
        let segments = try? SegmentCollection(start: 1, segmentLength: 5, numberOfSegments: 5, openEnded: true, includeZeroSegment: true)
        
        XCTAssertNotNil(segments)
        XCTAssertTrue(segments?.count == 6)
        XCTAssertTrue(segments?.first?.description == "0")
    }
    
    func testZeroSegment2() throws {
        
        let segment = Segment(colour: .red, range: 0..<1)
        
        XCTAssertTrue(segment.zeroSegment)
        XCTAssertTrue(segment.description == "0")
    }
}
