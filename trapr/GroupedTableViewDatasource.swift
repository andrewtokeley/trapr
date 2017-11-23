//
//  GroupedTableViewDatasource.swift
//  trapr
//
//  Created by Andrew Tokeley  on 22/10/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

class GroupedTableViewDatasourceItem<T: Any> {
    var selected: Bool = false
    var item: T!
    init(item: T, selected: Bool) {
        self.item = item
        self.selected = selected
    }
}

class GroupedTableViewDatasource<T: Any> {
    
    private var data = [T]()
    private var selected = [Bool]()
    
    private var sectionName: (T) -> String
    public var cellLabelText: (T) -> String
    
    private var groupedData = [[GroupedTableViewDatasourceItem<T>]]()
    
    init(data: [T], selected: [Bool], sectionName: @escaping (T) -> String, cellLabelText: @escaping ((T) -> String)) {
        
        self.cellLabelText = cellLabelText
        self.sectionName = sectionName
        
        self.data = data
        self.selected = selected
        
        rebuild()
    }
    
    private func rebuild() {
        
        // reset
        groupedData = [[GroupedTableViewDatasourceItem<T>]]()
        
        var lastSectionName: String?
        var count = 0
        
        for item in data {
            let groupedTableViewDatasourceItem = GroupedTableViewDatasourceItem(item: item, selected: selected[count])
            
            let sectionName = self.sectionName(item)
            if sectionName != lastSectionName {
                
                // new section
                groupedData.append([groupedTableViewDatasourceItem])
                
            } else {
                
                // add the item to the current latest section
                groupedData[groupedData.count - 1].append(groupedTableViewDatasourceItem)
            }
            lastSectionName = sectionName
            count += 1
        }
    }
    
    func numberOfSections() -> Int {
        return groupedData.count
    }
    
    func numberOfRowsInSection(section: Int, selectedOnly: Bool = false) -> Int {
        if (selectedOnly) {
            return groupedData[section].filter({ $0.selected }).count
        } else {
            return groupedData[section].count
        }
    }
    
    func data(section: Int, row: Int) -> GroupedTableViewDatasourceItem<T> {
        return groupedData[section][row]
    }
    
    func dataItems(selectedOnly: Bool) -> [T] {
        var items = [T]()
        
        for section in groupedData {
            for data in section {
                if (selectedOnly && data.selected) || !selectedOnly {
                    items.append(data.item)
                }
            }
        }
        return items
    }
    
    func cellLabelText(section: Int, row: Int) -> String {
        return self.cellLabelText(data(section: section, row: row).item)
    }
    
    func sectionText(section: Int) -> String {
        
        // we assume there is at least one item in each section, return the section name based on this data item
        let data = self.data(section: section, row: 0)
        return self.sectionName(data.item)
    }
    
    func setSelected(section: Int, row: Int = Int.max, selected: Bool) {
        if (row == Int.max) {
            
            // (de)select all rows in section
            for data in groupedData[section] {
                data.selected = selected
            }
        } else {
            
            // (de)select specific row
            groupedData[section][row].selected = selected
        }
    }
    
    func isSelected(section: Int, row: Int) -> Bool {
        return groupedData[section][row].selected
    }
    
    func hasSelected(section: Int) -> Bool {
        var hasSelected: Bool = false
        var row = 0
        
        while row < numberOfRowsInSection(section: section) && !hasSelected {
            hasSelected = data(section: section, row: row).selected
            row += 1
        }
        return hasSelected
    }
    
    func flatIndex(index: IndexPath) -> Int {
        var flatIndex = 0
        
        // add up the number of items in the previous sections
        if index.section > 0 {
            for section in 0...index.section - 1 {
                flatIndex += groupedData[section].count
            }
        }
        
        // add the number of items left in the current section
        flatIndex += index.row
        
        return flatIndex
    }
    
    func moveItem(from: IndexPath, to: IndexPath) {
        
        let fromIndex = self.flatIndex(index: from)
        let toIndex = self.flatIndex(index: to)
        print("From: \(fromIndex), To: \(toIndex))")
        
        if toIndex >= self.data.count {
            self.data.append(self.data.remove(at: fromIndex))
            self.selected.append(self.selected.remove(at: fromIndex))
        } else {
            self.data.insert(self.data.remove(at: fromIndex), at: toIndex)
            self.selected.insert(self.selected.remove(at: fromIndex), at: toIndex)
        }
        
        // rebuild
        self.rebuild()
    }
    
    func replace(dataInSection section: Int, items: [T]) {
        replace(dataInSection: section, items: items, selected: false)
    }
    
    func replace(dataInSection section: Int, items: [T], selected: Bool) {
        
        if self.groupedData.count <= section {
            return
        } else {
        
            // index range of the section
            let indexStart = self.flatIndex(index: IndexPath(row: 0, section: section))
            let indexEnd = self.flatIndex(index: IndexPath(row: numberOfRowsInSection(section: section) - 1, section: section))
            
            self.data.removeSubrange(indexStart...indexEnd)
            self.data.insert(contentsOf: items, at: indexStart)
            
            self.rebuild()

        }
    }
    
    func insert(item: T, at: IndexPath) {
        insert(item: item, at: at, selected: false)
    }
    
    func insert(item: T, at: IndexPath, selected: Bool) {
        
        let flatIndex = self.flatIndex(index: at)
        
        // insert into underlying data array
        self.data.insert(item, at: flatIndex)
        self.selected.insert(selected, at: flatIndex)
        
        // rebuild groupedData structure
        self.rebuild()
    }
    
    func append(items: [T]) {
        append(items: items, selected: false)
    }
    
    func append(items: [T], selected: Bool) {
        
        self.data.append(contentsOf: items)
        self.selected.append(contentsOf: [Bool](repeatElement(selected, count: items.count)))
        self.rebuild()
    }
    
}
