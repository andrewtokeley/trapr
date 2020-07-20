//
//  RouteStatistics.swift
//  trapr
//
//  Created by Andrew Tokeley on 13/07/20.
//  Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation

/**
 Structure that defines statistics for a specific trap. Traps are uniquely defined by a combination of *Station* and *TrapType*.
 
 *TrapStatistic* records are typically returned from the *TrapStatisticService*.
 */
struct TrapStatistics {
    
    // MARK: Catch (for directKill traps)
    
    /**
     Number of kills by species.
     
     The key of the dictionary is the species code, as defined in SpeciesCode. For example;
     
          let numberOfPossumKills = [SpeciesCode.possum.rawValue]
     
     Would return the number of possum kills on a route or given trap on the route.
     
     - Important:
     Only set for traps where the *TrapType.killMethod*  is equal to *KillMethod.direct*, otherwise will be empty
     */
    var killsBySpecies = [String: Int]()
    
    /**
     The rate of catches per visit.
     
     Will be a number between 0 and 1, inclusive. For example, 0.2 means 20% of all visits resulted in a catch of some species.
     
     - Important:
     Only set for traps where the *TrapType.killMethod*  is equal to *KillMethod.direct*, otherwise nil.
     */
    var catchRate: Double?
    
    /**
     Total number of catches across all species
     */
    var totalCatches: Int = 0
    
    /**
     The rank order of most catches across all *TrapTypes* of the same type across a *Route*. Where 1 means the most catches.
     
     - Important:
     Only set for traps where the *TrapType.killMethod*  is equal to *KillMethod.direct*, otherwise nil.
     */
    var catchRank: Int?
    
    /**
     A Dictionary of the count of each *TrapSetStatus* for the given *Station* and *TrapType*.
     
     The key of the dictionary is the trap set status code, as defined in *TrapSetStatus* enum. For example;
     
          let countOfTrapSetNoBait = [TrapSetStatus.stillSet.rawValue]
     
     Would return the number of times the traps status was set to *.stillSet* across all visits.
     
     - Important:
     Only set for traps where the *TrapType.killMethod*  is equal to *KillMethod.direct*, otherwise will be empty
     */
    var trapSetStatusCounts = [Int: Int]()
    
    /**
     The number of visits to this trap
     */
    var numberOfVisits: Int = 0
    
    /**
     Last visit record for this trap (regardless of whether there was a catch recorded)
     */
    var lastVisit: Visit?
    
    /**
     All visits where a catch was recorded
     */
    var visitsWithCatches = [Visit]()
    
    /**
     Total number of bait eaten
     */
    var baitEaten: Int = 0
    
    /**
     Total number of bait removed
     */
    var baitRemoved: Int = 0
    
    /**
     Total number of bait added
     */
    var baitAdded: Int = 0
    
}
