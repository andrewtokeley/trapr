//
//  SelectTraplineInteractorInput.swift
//  trapr
//
//  Created by Andrew Tokeley  on 28/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol SelectTraplineInteractorInput {
    
    func getTraplinesAvailableVisitSummary(visitSummary: VisitSummary) -> [Trapline]?
}
