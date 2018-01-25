//
//  DateExtention.swift
//  trapr
//
//  Created by Andrew Tokeley  on 11/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

extension Date {
    
    //MARK: - Instance properties
    var day: Int {
        var components = Calendar.current.dateComponents([.day], from: self)
        return components.day!
    }
    
    var month: Int {
        var components = Calendar.current.dateComponents([.month], from: self)
        return components.month!
    }
    
    var year: Int {
        var components = Calendar.current.dateComponents([.year], from: self)
        return components.year!
    }
    
    //MARK: - Instance functions
    func toString(from format: String) -> String {
        
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
    
    func dayStart() -> Date {
        var components = Calendar.current.dateComponents([.day, .month, .year], from: self)
        
        let formater = DateFormatter()
        formater.dateFormat = "d M yyyy, HH:mm:ss"
        return formater.date(from: "\(components.day!) \(components.month!) \(components.year!), 00:00:00") ?? self
    }
    
    func dayEnd() -> Date {
        var components = Calendar.current.dateComponents([.day, .month, .year], from: self)
        
        let formater = DateFormatter()
        formater.dateFormat = "d M yyyy, HH:mm:ss"
        return formater.date(from: "\(components.day!) \(components.month!) \(components.year!), 23:59:59") ?? self
    }
    
    /**
     Converts a date to have the same time as now. The day/month/year will remain unchanged.
     */
    func setTimeToNow() -> Date? {
        let timeComponentsOfNow = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
        return self.setTime(timeComponentsOfNow.hour, timeComponentsOfNow.minute, timeComponentsOfNow.second)
    }
    
    /**
     Converts a date to have a specific time. The day/month/year will remain unchanged.
     */
    func setTime(_ hour: Int?, _ minute: Int?, _ second: Int?) -> Date? {
        
        let dateComonentsOfSelf = Calendar.current.dateComponents([.year, .month, .day], from: self)
        
        return Date.dateFromComponents(dateComonentsOfSelf.day, dateComonentsOfSelf.month, dateComonentsOfSelf.year, hour, minute, second)
    }
    
    /**
     Converts a date to have a specific day, the time components will remain unchanged.
     */
    func setDate(_ day: Int?, _ month: Int?, _ year: Int?) -> Date? {
        
        let timeComonentsOfSelf = Calendar.current.dateComponents([.hour, .minute, .second], from: self)
        
        return Date.dateFromComponents(day, month, year, timeComonentsOfSelf.hour, timeComonentsOfSelf.minute, timeComonentsOfSelf.second)
    }
    
    //MARK: - Static functions
    static func dateFromComponents(_ day: Int?, _ month: Int?, _ year: Int?, _ hour: Int?, _ minute: Int?, _ second: Int?) -> Date? {
        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year
        components.hour = hour
        components.minute = minute
        components.second = second
        
        return Calendar.current.date(from: components)
    }
    
    static func dateFromComponents(_ day: Int, _ month: Int, _ year: Int) -> Date? {
        return dateFromComponents(day, month, year, nil, nil, nil)
    }
    
    
}
