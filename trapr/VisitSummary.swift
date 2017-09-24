//
//  VisitSummary.swift
//  trapr
//
//  Created by Andrew Tokeley  on 8/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

class VisitSummary {

    var traplines: [Trapline]?
    var dateOfVisit: Date
    
    init(dateOfVisit: Date) {
        self.dateOfVisit = dateOfVisit
    }
    
    convenience init(traplines: [Trapline], dateOfVisit: Date) {
        self.init(dateOfVisit: dateOfVisit)
        self.traplines = traplines
    }
    
    var traplinesDescription: String {
        
        var description = ""
        
        if self.traplines != nil {
            for trapline in self.traplines! {
                if let code = trapline.code {
                    description.append(code)
                    if trapline != self.traplines?.last {
                        description.append(", ")    
                    }
                }
            }
        }
        return description
    }
    
}
