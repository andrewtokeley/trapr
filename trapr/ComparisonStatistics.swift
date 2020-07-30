//
//  ComparisonStatistics.swift
//  trapr
//
//  Created by Andrew Tokeley on 20/07/20.
//  Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation

enum Quartile {
    case Q1
    case Q2
    case Q3
}

struct ComparisonStatistics {
    var rank: Int
    var quartile: Quartile
}
