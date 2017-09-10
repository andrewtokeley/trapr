//
//  VisitSummary.swift
//  trapr
//
//  Created by Andrew Tokeley  on 8/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

class VisitSummary {
    
    var trapLinesDescription: String
    var dateOfVisit: Date
    
    init(trapLinesDescription: String, dateOfVisit: Date) {
        self.trapLinesDescription = trapLinesDescription
        self.dateOfVisit = dateOfVisit
    }
    
}
