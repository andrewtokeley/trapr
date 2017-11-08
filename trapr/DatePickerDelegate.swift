//
//  DatePickerDelegate.swift
//  trapr
//
//  Created by Andrew Tokeley  on 12/10/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

enum DatePickerElement: String {
    case title
    case todayButton
    case nowButton
    
    var defaultTextValue: String {
        switch self {
        case .title: return ""
        case .todayButton: return "Today"
        case .nowButton: return "Now"
        }
    }
}

protocol DatePickerDelegate {

    // optional
    func datePicker(_ datePicker: DatePickerViewApi, textFor element: DatePickerElement) -> String
    func datePicker(_ datePicker: DatePickerViewApi, showTextFor element: DatePickerElement) -> Bool
    func datePicker(_ datePicker: DatePickerViewApi, didSelectDate date: Date)
    
    // must implement
    func displayMode(_ datePicker: DatePickerViewApi) -> UIDatePickerMode
}

//MARK: - Default implementations for optional methods
extension DatePickerDelegate {
    
    func datePicker(_ datePicker: DatePickerViewApi, textFor element: DatePickerElement) -> String {
        return element.defaultTextValue
    }
    
    func datePicker(_ datePicker: DatePickerViewApi, showTextFor element: DatePickerElement) -> Bool {
        
        if element == .title {
            
            return true
        } else {
        
            let mode = displayMode(datePicker)
        
            if element == .nowButton {
                return mode == .time
            } else if element == .todayButton {
                return (mode == .date || mode == .dateAndTime)
            } else {
                return false
            }
        }
    }
    
    func datePicker(_ datePicker: DatePickerViewApi, didSelectDate date: Date) {
        // do nothing
    }
    
    
}
