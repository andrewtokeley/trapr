//
//  GroupedTableViewDatasourceTests.swift
//  traprTests
//
//  Created by Andrew Tokeley  on 23/10/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import XCTest

@testable import trapr_development

fileprivate class Station {
    var code: String
    var traplineCode: String
    
    init(_ code: String, _ traplineCode: String) {
        self.code = code
        self.traplineCode = traplineCode
    }
    
}

class GroupedTableViewDatasourceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmptyGroupedTableViewDatasource() {
        let stations = [Station]() // empty
        
        let selected = [Bool](repeatElement(false, count: stations.count))
        let groupedData = GroupedTableViewDatasource<Station>(data: stations, selected: selected, sectionName:{
            $0.traplineCode
        }, cellLabelText: {
            $0.code
        })
        
        XCTAssertTrue(groupedData.numberOfSections() == 0)
        XCTAssertTrue(groupedData.dataItems(selectedOnly: false).count == 0)
        //XCTAssertTrue(groupedData
    }
    
    func testInsertingItems() {
        
        let orderedData = [Station("1", "LW"),
                           Station("2", "LW"),
                           Station("3", "LW"),
                           Station("1", "AA"),
                           Station("2", "AA")]
        let selected = [Bool](repeatElement(false, count: orderedData.count))
        let groupedData = GroupedTableViewDatasource<Station>(data: orderedData, selected: selected, sectionName:{
            $0.traplineCode
        }, cellLabelText: {
            $0.code
        })
        
        groupedData.insert(item: Station("1.5", "LW"), at: IndexPath(row: 1, section: 0))
        
        XCTAssertTrue(groupedData.numberOfSections() == 2)
        XCTAssertTrue(groupedData.numberOfRowsInSection(section: 0) == 4)
        XCTAssertTrue(groupedData.numberOfRowsInSection(section: 1) == 2)
        XCTAssertTrue(groupedData.data(section: 0, row: 1).item.code == "1.5")
        XCTAssertTrue(groupedData.data(section: 0, row: 1).selected == false) // default
        
    }
    
    func testAppendingItems() {
        
        let orderedData = [Station("1", "LW"),
                           Station("2", "LW"),
                           Station("3", "LW"),
                           Station("1", "AA"),
                           Station("2", "AA")]
        let selected = [Bool](repeatElement(false, count: orderedData.count))
        let groupedData = GroupedTableViewDatasource<Station>(data: orderedData, selected: selected, sectionName:{
            $0.traplineCode
        }, cellLabelText: {
            $0.code
        })
        
        groupedData.append(items: [Station("1", "BB"), Station("2", "BB")])
        
        XCTAssertTrue(groupedData.numberOfSections() == 3)
        XCTAssertTrue(groupedData.numberOfRowsInSection(section: 0) == 3)
        XCTAssertTrue(groupedData.numberOfRowsInSection(section: 1) == 2)
        XCTAssertTrue(groupedData.numberOfRowsInSection(section: 1) == 2)
        XCTAssertTrue(groupedData.data(section: 2, row: 0).item.traplineCode == "BB")
        
    }
    
    func testReplacingSectionItems() {
        
        let orderedData = [Station("1", "LW"),
                           Station("2", "LW"),
                           Station("3", "LW"),
                           Station("1", "AA"),
                           Station("2", "AA")]
        let selected = [Bool](repeatElement(false, count: orderedData.count))
        let groupedData = GroupedTableViewDatasource<Station>(data: orderedData, selected: selected, sectionName:{
            $0.traplineCode
        }, cellLabelText: {
            $0.code
        })
        
        groupedData.replace(dataInSection: 1, items: [Station("1", "ZZ")])
        
        XCTAssertTrue(groupedData.numberOfSections() == 2)
        XCTAssertTrue(groupedData.numberOfRowsInSection(section: 0) == 3)
        XCTAssertTrue(groupedData.numberOfRowsInSection(section: 1) == 1)
        XCTAssertTrue(groupedData.data(section: 1, row: 0).item.traplineCode == "ZZ")
        
    }
    
    func testNumberOfSectionsOrderedData() {
        
        let orderedData = [Station("1", "LW"),
                           Station("2", "LW"),
                           Station("3", "LW"),
                           Station("1", "AA"),
                           Station("2", "AA")]
        let selected = [Bool](repeatElement(false, count: orderedData.count))
        let groupedData = GroupedTableViewDatasource(data: orderedData, selected: selected, sectionName:{
            $0.traplineCode
        }, cellLabelText: {
            $0.code
        })
        
        XCTAssertTrue(groupedData.numberOfSections() == 2)
        XCTAssertTrue(groupedData.numberOfRowsInSection(section: 0) == 3)
        XCTAssertTrue(groupedData.numberOfRowsInSection(section: 1) == 2)
        
    }
    
    func testNumberOfSectionsUnordered() {
        
        let orderedData = [Station("1", "LW"),
                           Station("1", "AA"),
                           Station("2", "LW"),
                           Station("2", "AA"),
                           Station("3", "AA")]
        let selected = [Bool](repeatElement(false, count: orderedData.count))
        let groupedData = GroupedTableViewDatasource(data: orderedData, selected: selected, sectionName:{
            $0.traplineCode
        }, cellLabelText: {
            $0.code
        })
        
        XCTAssertTrue(groupedData.numberOfSections() == 4)
        XCTAssertTrue(groupedData.numberOfRowsInSection(section: 0) == 1)
        XCTAssertTrue(groupedData.numberOfRowsInSection(section: 1) == 1)
        XCTAssertTrue(groupedData.numberOfRowsInSection(section: 2) == 1)
        XCTAssertTrue(groupedData.numberOfRowsInSection(section: 3) == 2)
        
    }
    
    func testSectionName() {
        
        let orderedData = [Station("1", "LW"),
                           Station("2", "LW"),
                           Station("3", "LW"),
                           Station("1", "AA"),
                           Station("2", "AA")]
        let selected = [Bool](repeatElement(false, count: orderedData.count))
        let groupedData = GroupedTableViewDatasource(data: orderedData, selected: selected, sectionName:{
            $0.traplineCode
        }, cellLabelText: {
            $0.code
        })
        
        XCTAssertTrue(groupedData.numberOfSections() == 2)
        XCTAssertTrue(groupedData.sectionText(section: 0) == "LW")
        XCTAssertTrue(groupedData.sectionText(section: 1) == "AA")
    }

    func testFlatIndex() {
        let orderedData = [Station("1", "LW"),
                           Station("2", "LW"),
                           Station("3", "LW"),
                           Station("1", "AA"),
                           Station("2", "AA")]
        
        // All unselected
        let selected = [Bool](repeatElement(false, count: orderedData.count))
        
        let groupedData = GroupedTableViewDatasource(data: orderedData, selected: selected, sectionName:{
            $0.traplineCode
        }, cellLabelText: {
            $0.code
        })
        
        let flatIndex2 = groupedData.flatIndex(index: IndexPath(row: 2, section: 0))
        let flatIndex4 = groupedData.flatIndex(index: IndexPath(row: 1, section: 1))
        
        XCTAssertTrue(flatIndex2 == 2)
        XCTAssertTrue(flatIndex4 == 4)
        
    }
    
    func testMove() {
        
        let orderedData = [Station("1", "LW"),
                           Station("2", "LW"),
                           Station("3", "LW"),
                           Station("1", "AA"),
                           Station("2", "AA")]
        
        // All unselected
        let selected = [Bool](repeatElement(false, count: orderedData.count))
        
        let groupedData = GroupedTableViewDatasource(data: orderedData, selected: selected, sectionName:{
            $0.traplineCode
        }, cellLabelText: {
            $0.code
        })
        
        let LW2 = groupedData.data(section: 0, row: 1).item
        XCTAssertTrue(LW2?.code == "2" && LW2?.traplineCode == "LW")
        
        // Move AA1 to row:1, section:0 (second place)
        groupedData.moveItem(from: IndexPath(row: 0, section: 1), to: IndexPath(row: 1, section: 0))
        
        // Order matters for groups, so should be
        // LW
        // - 1
        // AA
        // - 1
        // LW
        // - 2
        // - 3
        // AA
        // - 2
        XCTAssertTrue(groupedData.numberOfSections() == 4)
        let AA1 = groupedData.data(section: 1, row: 0).item
        XCTAssertTrue(AA1?.code == "1" && AA1?.traplineCode == "AA")
        
    }
    
    func testMoveToEnd() {
        
        let orderedData = [Station("1", "LW"),
                           Station("2", "LW"),
                           Station("3", "LW"),
                           Station("1", "AA"),
                           Station("2", "AA")]
        
        // All unselected
        let selected = [Bool](repeatElement(false, count: orderedData.count))
        
        let groupedData = GroupedTableViewDatasource(data: orderedData, selected: selected, sectionName:{
            $0.traplineCode
        }, cellLabelText: {
            $0.code
        })
        
        // Move LW3 to last row
        groupedData.moveItem(from: IndexPath(row: 2, section: 0), to: IndexPath(row: 1, section: 1))
        
        let lastItem = groupedData.dataItems(selectedOnly: false).last!
        XCTAssertTrue(lastItem.code == "3" && lastItem.traplineCode == "LW")
    }
    
    func testMoveSectionBeforeFirst() {
        
        let orderedData = [Station("1", "Group1"),
                           Station("2", "Group1"),
                           Station("3", "Group1"),
                           Station("1", "Group2"),
                           Station("2", "Group2"),
                           Station("1", "Group3"),
                           Station("2", "Group3")]
        
        // All unselected
        let selected = [Bool](repeatElement(false, count: orderedData.count))
        
        let groupedData = GroupedTableViewDatasource(data: orderedData, selected: selected, sectionName:{
            $0.traplineCode
        }, cellLabelText: {
            $0.code
        })
        
        // Move Group2 before Group1
        groupedData.moveSection(fromSection: 1, beforeSection: 0)

        // still three sections
        let numberOfSections = groupedData.numberOfSections()
        XCTAssertTrue( numberOfSections == 3, "Expected 3, was \(numberOfSections)")
        
        // first section is now Group2
        let firstSectionText = groupedData.sectionText(section: 0)
        XCTAssertTrue(firstSectionText == "Group2", "Expected Group2, was \(firstSectionText)")
        
    }
    
    
    func testHasSelected() {
        
        let orderedData = [Station("1", "LW"),
                           Station("2", "LW"),
                           Station("3", "LW"),
                           Station("1", "AA"),
                           Station("2", "AA"),
                           Station("1", "CC"),
                           Station("2", "CC")]
        
        // One selected in section 0, none selected in section 1, all selected in section 2
        let selected = [true, false, false,
                        false, false,
                        true, true]
        
        let groupedData = GroupedTableViewDatasource(data: orderedData, selected: selected, sectionName:{
            $0.traplineCode
        }, cellLabelText: {
            $0.code
        })
        
        XCTAssertTrue(groupedData.hasSelected(section: 0) == true)
        XCTAssertTrue(groupedData.hasSelected(section: 1) == false)
        XCTAssertTrue(groupedData.hasSelected(section: 0) == true)
    }
}
