//
//  traprTests.swift
//  traprTests
//
//  Created by Andrew Tokeley  on 5/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import XCTest
@testable import trapr

class dateTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDateCreate() {
        
        if let date = Date.dateFromComponents(28, 8, 1968)
        {
            XCTAssertTrue(date.toString(from: "d") == "28")
            XCTAssertTrue(date.toString(from: "M") == "8")
            XCTAssertTrue(date.toString(from: "y") == "1968")
        }
        else
        {
            XCTFail()
        }
    }
    
    func testDateAddExtension() {
        
        let august = Date.dateFromComponents(10, 8, 2000)
        let nextDate = august?.add(0, 1, 0)
        
        XCTAssertTrue(nextDate?.toString(from: "M") == "9")
    }

    func testDateDayStart() {
        let formater = DateFormatter()
        formater.dateFormat = "dd MM yyyy, HH:mm:ss"
        if let date = formater.date(from: "28 08 2017, 13:11:03") {
            
            let dayStart = formater.string(from: date.dayStart())
            
            XCTAssertTrue(dayStart == "28 08 2017, 00:00:00")
            
        } else {
            
            XCTFail()
        }

    }

    
    func testDateDayEnd() {
        let formater = DateFormatter()
        formater.dateFormat = "dd MM yyyy, HH:mm:ss"
        if let date = formater.date(from: "28 08 2017, 13:11:03") {
            
            let dayEnd = formater.string(from: date.dayEnd())
            
            XCTAssertTrue(dayEnd == "28 08 2017, 23:59:59")
            
        } else {
            
            XCTFail()
        }
    }
    
    func testSetTime() {
        let today = Date()
        let todayComponents = Calendar.current.dateComponents([.day, .month, .year], from: today)
        
        // set the time is 11:11:11 and set to this
        if let newDate = today.setTime(11, 11, 11) {
        
            // test the time is 11:11:11 on newDate
            let components = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute, .second], from: newDate)
            
            // Test the day is the same
            XCTAssertTrue(components.day == todayComponents.day)
            XCTAssertTrue(components.month == todayComponents.month)
            XCTAssertTrue(components.year == todayComponents.year)
            
            XCTAssertTrue(components.hour == 11)
            XCTAssertTrue(components.minute == 11)
            XCTAssertTrue(components.second == 11)
        } else {
            XCTFail()
        }
    }
}
