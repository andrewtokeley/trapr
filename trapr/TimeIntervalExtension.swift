//
//  TimeIntervalExtension.swift
//  trapr
//
//  Created by Andrew Tokeley on 10/09/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

extension TimeInterval {

    func formatInTimeUnits() -> String? {
        // Create a formatter that returns in time format
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        formatter.maximumUnitCount = 2
        
        return formatter.string(from: self)
    }
}
