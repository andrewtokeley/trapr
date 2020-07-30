//
//  TimeSeries.swift
//  traprTests
//
//  Created by Andrew Tokeley on 27/07/20.
//  Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation

class TimeSeries<T> where T: TimeSeriesItem {
    
    private var internalArray: [T]
    
    init() {
        internalArray = []()
    }
    
    convenience init(_ data: [T]) {
        internalArray = data
    }
    
    func append(_ item: T) {
        internalArray.append(item)
    }
    
    func insert(_ item, at index: Int) {
        internalArray.insert(item, at: index)
    }
}
