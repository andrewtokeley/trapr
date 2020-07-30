//
//  TimeSeriesItem.swift
//  traprTests
//
//  Created by Andrew Tokeley on 27/07/20.
//  Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol TimeSeriesItem {
    var timestamp: Date
}

protocol TimeSeriesIntegerItem: TimeSeriesItem {
    var data: Int
}

protocol TimeSeriesDoubleItem: TimeSeriesItem {
    var data: Double
}
