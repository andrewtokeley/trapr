//
//  CatchSummary.swift
//  trapr
//
//  Created by Andrew Tokeley on 14/01/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

struct StackCount {
    var labels = [String]()
    var counts = [[Int]]()

    init(_ labels: [String], _ counts: [[Int]]) {
        
        // catches[i] same for all i
        // check species.count = catches[0].count
        self.labels = labels
        self.counts = counts
    }
}
