//
//  VisitSummariesStatistics.swift
//  trapr
//
//  Created by Andrew Tokeley on 10/09/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

struct VisitSummariesStatistics {
    
    /// The average time across VisitSummaries where all the traps were visited.
    var averageTimeTaken: TimeInterval = 0
    
    /// The fastest time across VisitSummaries where all the traps were visited.
    var fastestTimeTaken: TimeInterval = 0
    
    /// The total number of poison bait used during visits
    var totalPoisonAdded: Int = 0
    
    /// The total number of kills, of any species, across all visits
    var totalKills: Int = 0
    
    /// The total number of kills, by species, across all visits. The result is a dictionary where the key is the speciesId and the value is the count of kills.
    var totalKillsBySpecies = [String: Int]()
}
