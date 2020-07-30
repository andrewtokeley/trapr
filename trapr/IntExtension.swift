//
//  IntExtension.swift
//  trapr
//
//  Created by Andrew Tokeley on 30/07/20.
//  Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation

extension Int {
    
    /**
     Returns the rank description of an integer. For example, 1 will return 1st, 2 = 2nd, 3 = 3rd...
     */
    var rankDescription: String {
        let intAsString = String(self)
        let last2Numbers = Int(intAsString.suffix(2))
        
        if intAsString.count >= 2 &&
            last2Numbers! >= 11 &&
            last2Numbers! <= 19 {
            return "\(intAsString)th"
        } else if intAsString.last == "1" {
            return "\(intAsString)st"
        } else if intAsString.last == "2" {
            return "\(intAsString)nd"
        } else if intAsString.last == "3" {
            return "\(intAsString)rd"
        } else {
            return "\(intAsString)th"
        }
    }
}
