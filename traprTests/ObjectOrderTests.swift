//
//  ObjectOrderTests.swift
//  traprTests
//
//  Created by Andrew Tokeley on 10/01/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import XCTest
@testable import trapr

class ObjectOrderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGapInMiddle() {
        
        let s1 = "Tom"
        let s2 = "Jenny"
        let s3 = "Jane"
        let s4 = "Peter"
        
        let orderedObjects = ObjectOrder<String>()
        let _ = orderedObjects.add(s1)
        let _ = orderedObjects.add(s2)
        let _ = orderedObjects.add(s3)
        
        // remove Jenny
        orderedObjects.remove(s2)
        
        // add Peter
        let _ = orderedObjects.add(s4)
        
        // check Peter has filled the gap left by Jenny
        if let order = orderedObjects.orderOf(s4) {
            XCTAssertTrue(order == 1, "order == \(order) ")
        } else {
            XCTFail()
        
        }
    }
    
    func testRemoveFirst() {
        let s1 = "Sam1"
        let s2 = "Sam2"
        let s3 = "Sam3"
        let s4 = "Sam4"
        
        let orderedObjects = ObjectOrder<String>()
        let _ = orderedObjects.add(s1)
        let _ = orderedObjects.add(s2)
        let _ = orderedObjects.add(s3)
        
        //remove first
        orderedObjects.remove(s1)
        
        // add another (should be given first spot)
        let index = orderedObjects.add(s4)
        XCTAssertTrue(index == 0)
    }
    
    func testReverse() {
        let s1 = "Sam1"
        let s2 = "Sam2"
        let s3 = "Sam3"
        let orderedObjects = ObjectOrder<String>()
        let _ = orderedObjects.add(s1)
        let _ = orderedObjects.add(s2)
        let _ = orderedObjects.add(s3)
        
        XCTAssertTrue(orderedObjects.orderOf(s1) == 0)
        orderedObjects.reverse()
        XCTAssertTrue(orderedObjects.orderOf(s1) == 2)
    }
    func testRemoveAll() {
        let s1 = "Sam1"
        let s2 = "Sam2"
        let s3 = "Sam3"
        let orderedObjects = ObjectOrder<String>()
        let _ = orderedObjects.add(s1)
        let _ = orderedObjects.add(s2)
        let _ = orderedObjects.add(s3)
        
        orderedObjects.removeAll()
        
        XCTAssertTrue(orderedObjects.count == 0)
    }
    
    func testAddFirst() {
        let s1 = "Sam"
        let orderedObjects = ObjectOrder<String>()
        let _ = orderedObjects.add(s1)
        
        if let order = orderedObjects.orderOf(s1) {
            XCTAssertTrue(order == 0, "order == \(order) ")
        } else {
            XCTFail()
            
        }
    }
    
    func testNoGapsAddsToEnd() {
        
        let s1 = "Tom"
        let s2 = "Jenny"
        let s3 = "Jane"
        let s4 = "Peter"
        
        let orderedObjects = ObjectOrder<String>()
        let _ = orderedObjects.add(s1)
        let _ = orderedObjects.add(s2)
        let _ = orderedObjects.add(s3)
        
        // add Peter
        let _ = orderedObjects.add(s4)
        
        // check Peter has been given the biggest order
        if let order = orderedObjects.orderOf(s4) {
            XCTAssertTrue(order == 3, "order == \(order) ")
        } else {
            XCTFail()
            
        }
        
        
    }
    
}
