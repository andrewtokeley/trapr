//
//  VisitSummary.swift
//  trapr
//
//  Created by Andrew Tokeley  on 8/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

class VisitSummary {

    var visitService: VisitServiceInterface?
    var dateOfVisit: Date!
    var route: Route!
    
    init() {
        self.dateOfVisit = Date()
    }
    
    /**
     Create an instance from the visits that were created on a specific day
    */
    convenience init(dateOfVisit: Date, visitService: VisitServiceInterface) {
        
        //TODO: don't need to create a summary from visits - should use (dateOfVisit: route:) only
        self.init()
        self.dateOfVisit = dateOfVisit

        let visits = visitService.getVisits(recordedOn: self.dateOfVisit)
        self.route = Route(name: "Test", visits: Array(visits))
    }
    
    /**
     Create an instance for a specific day and route
     */
    convenience init(dateOfVisit: Date, route: Route) {
        self.init()
        
        self.dateOfVisit = dateOfVisit
        self.route = route
    }
    
}
