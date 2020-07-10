//
//  XlsxReaderWriterExtension.swift
//  trapr
//
//  Created by Andrew Tokeley on 9/07/20.
//  Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation
import XlsxReaderWriter

struct ColumnSeach {
    var columnReference: String
    var value: String?
}

extension BRAWorksheet {

    /// Returns the first row number that matches all the searchTerms
    func findRow(searchTerms: [ColumnSeach]) -> Int? {
        
        for row in 1...100 {
            var match = false
            for searchTerm in searchTerms {
                // get the value of the cell in the column
                let cellValue = self.cell(forCellReference: searchTerm.columnReference + String(row))?.stringValue()
                match = cellValue == searchTerm.value
                if !match { break }
            }
            
            // if match is true here, then all the searchTerms matched
            if match { return row }
        }

        // no matches
        return nil
    }
}
