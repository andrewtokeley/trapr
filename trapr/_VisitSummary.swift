//
//  _VisitSummary.swift
//  trapr
//
//  Created by Andrew Tokeley on 15/11/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

class _VisitSummary {
    
    /// Date on which the visits happened
    var dateOfVisit: Date!
    
    /// The id of the Route which was followed when the visits were recorded
    var routeId: String!
    
    //MARK: - Initialisers
    
    /**
     Create a new VisitSummary instance. NOTE, you should not create VisitSummary objects directly, instead use the VisitSummaryService.get() methods.
     
     - parameters:
     - dateOfVisit: the date you want visit summary for
     - routeId: the id of the Route you want the summary for
     */
    init(dateOfVisit: Date, routeId: String) {
        self.dateOfVisit = dateOfVisit
        self.routeId = routeId
    }
    
    //MARK: - Calculated properties
    
    /// The number of traps visited
    var numberOfTrapsVisited: Int {
        return visits.count
    }
    
    
    /// The number of seconds between the first and last visit (regardless of whether all the traps have been visited)
    var timeTaken: TimeInterval {
        
        let orderedVisits = visits.sorted(by: { $0.visitDateTime < $1.visitDateTime })
        
        if let firstVisit = orderedVisits.first, let lastVisit = orderedVisits.last {
            return lastVisit.visitDateTime.timeIntervalSince(firstVisit.visitDateTime)
        } else {
            return 0
        }
    }
    
    // MARK: - Set by VisitSummaryService.get(...)
    var route: _Route?
    
    /// The visits that were recorded on the specified day and Route.
    var visits = [_Visit]()
    
    /// Number of traps on the entire Route
    var numberOfTrapsOnRoute: Int = 0
    
    /// Total number of poison bait used on this visit
    var totalPoisonAdded: Int = 0
    
    /// Total number of kills on this visit
    var totalKills: Int = 0
    
    /// Total number of kills of each species on this visit. The dictionary key is the rawValue of the SpeciesCode enum.
    var totalKillsBySpecies = [String: Int]()
    
    var stationsOnRoute = [_Station]()
//
//    var totalPoisonAdded: Int {
//        var count = 0
//        for visit in visits {
//
//            if visit.trapTypeId == TrapTypeCode.
//            if visit.trap?.type?.killMethod == KillMethod.poison {
//                count += visit.baitAdded
//            }
//        }
//        return count
//    }
//
//    var totalKillsBySpecies: [String: Int] {
//        var counts = [String: Int]()
//        for visit in visits {
//            if let name = visit.catchSpecies?.name {
//                if let _ = counts[name] {
//                    counts[name]! += 1
//                } else {
//                    counts[name] = 1
//                }
//            }
//        }
//        return counts
//    }
//
//    var totalKills: Int {
//        var count = 0
//        for visit in visits {
//            if visit.catchSpecies != nil {
//                count += 1
//            }
//        }
//        return count
//    }
    
    
    
}
