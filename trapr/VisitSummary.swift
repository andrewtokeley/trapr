//
//  VisitSummary.swift
//  trapr
//
//  Created by Andrew Tokeley  on 8/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

class VisitSummary {

    var visitService: VisitServiceInterface!
    var dateOfVisit: Date!
    var traplines = [Trapline]()
    
    lazy var route: Route? = {
        let visits = self.visitService.getVisits(recordedOn: self.dateOfVisit)
        return Route(visits: Array(visits))
    }()
    
    init(dateOfVisit: Date, visitService: VisitServiceInterface) {
        self.dateOfVisit = dateOfVisit
        self.visitService = visitService
    }
    
    var traplinesDescription: String {
        return self.route?.description() ?? "-"
    }
   
}
