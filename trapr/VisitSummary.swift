//
//  VisitSummary.swift
//  trapr
//
//  Created by Andrew Tokeley  on 8/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

class VisitSummary {

    /**
     Date on which the visits happened
     */
    var dateOfVisit: Date!
    
    /**
     The Route which was followed when the visits were recorded
     */
    var route: Route!
    
    /**
     The visits that were recorded on the specified day and Route.
     */
    var visits = [Visit]()
    
    var totalPoisonAdded: Int {
        var count = 0
        for visit in visits {
            if visit.trap?.type?.killMethod == KillMethod.poison {
                count += visit.baitAdded
            }
        }
        return count
    }
    
    var totalKills: Int {
        var count = 0
        for visit in visits {
            if visit.catchSpecies != nil {
                count += 1
            }
        }
        return count
    }
    
    /**
     Create an instance for a specific day and route
     */
    init(dateOfVisit: Date, route: Route) {
        self.dateOfVisit = dateOfVisit
        self.route = route
    }
    
}
