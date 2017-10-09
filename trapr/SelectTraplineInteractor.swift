//
//  SelectTraplineInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley  on 28/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

class SelectTraplineInteractor: SelectTraplineInteractorInput {
    
    func getTraplinesAvailableVisitSummary(visitSummary: VisitSummary) -> [Trapline]? {
        
        let traplines = ServiceFactory.sharedInstance.traplineService.getTraplines()
        
        if visitSummary.traplines.count == 0 {
            return traplines
        } else {
            
            return traplines?.filter({ (trapline) in
                
                // returns true if the trapline is NOT part of the visitSummary
                return !visitSummary.traplines.contains(trapline)
            })
        }
    }
}
