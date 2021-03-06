//
//  CatchSummary.swift
//  trapr
//
//  Created by Andrew Tokeley on 14/01/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

/**
 Structure that can be used to populate a stacked bar chart. For each label in the labels array there is a corresponding array of counts.
 
 All count elements, themselves an array, must have a count equal to the number of labels.
 */
struct StackCount {
    var labels = [String]()
    var counts = [[Int]]()
    
    public static var zero: StackCount {
        return StackCount([String](), [[Int]]())
    }
    
    init(_ labels: [String], _ counts: [[Int]]) {
        self.labels = labels
        self.counts = counts
    }

    /**
    Returns true if all the counts are zero
    */
    var isZero: Bool {
        let firstNonZero = counts.first(where: {
            (items) in
            return items.reduce(0, +) != 0
        })
        
        // must be zero if there are no non-zeros
        return firstNonZero == nil
    }
    
}
