//
//  DateExtention.swift
//  trapr
//
//  Created by Andrew Tokeley  on 11/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

extension Date {
    func string(from format: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func add(_ days: Int, _ months: Int, _ years: Int) -> Date {
        var components = DateComponents()
        components.day = days
        components.month = months
        components.year = years
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        return Calendar.current.date(byAdding: components, to: self) ?? self
    }
    
    static func dateFromComponents(_ days: Int, _ months: Int, _ years: Int) -> Date? {
        var components = DateComponents()
        components.day = days
        components.month = months
        components.year = years
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        return Calendar.current.date(from: components)
    }
}
