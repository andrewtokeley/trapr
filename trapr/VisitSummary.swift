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
    
    /**
     The number of traps visited
     */
    var numberOfTrapsVisited: Int {
        return visits.count
    }
    
    /**
     Returns true if all the traps have been visited on the route
     */
    var allTrapsVisited: Bool {
        return numberOfTrapsVisited == route.numberOfTraps
    }

    /**
     Returns the number of seconds between the first and last visit (regardless of whether all the traps have been visited)
     */
    var timeTaken: TimeInterval {
        
        let orderedVisits = visits.sorted(by: { $0.visitDateTime < $1.visitDateTime }, stable: true)
        
        if let firstVisit = orderedVisits.first, let lastVisit = orderedVisits.last {
            return lastVisit.visitDateTime.timeIntervalSince(firstVisit.visitDateTime)
        } else {
            return 0
        }
    }
    
    var totalPoisonAdded: Int {
        var count = 0
        for visit in visits {
            if visit.trap?.type?.killMethod == KillMethod.poison {
                count += visit.baitAdded
            }
        }
        return count
    }
    
    var totalKillsBySpecies: [String: Int] {
        var counts = [String: Int]()
        for visit in visits {
            if let name = visit.catchSpecies?.name {
                if let _ = counts[name] {
                    counts[name]! += 1
                } else {
                    counts[name] = 1
                }
            }
        }
        return counts
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
