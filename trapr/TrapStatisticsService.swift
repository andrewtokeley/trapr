//
//  RouteStatisticsService.swift
//  trapr
//
//  Created by Andrew Tokeley on 13/07/20.
//  Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation

class TrapStatisticsService: FirestoreService {
    
    fileprivate lazy var visitService = { ServiceFactory.sharedInstance.visitFirestoreService }()
    
    fileprivate func getStatistics(_ visits: [Visit]) -> TrapStatistics? {
        
        var result = TrapStatistics()
        
        for visit in visits {
            
            // Tally TrapSetStatus'
            if let id = visit.trapSetStatusId {
                result.trapSetStatusCounts[id] =  (result.trapSetStatusCounts[id] ?? 0) + 1
            }
            
            // Tally KillCounts
            if let id = visit.speciesId {
                result.killsBySpecies[id] = (result.killsBySpecies[id] ?? 0) + 1
            }
            
            // Bait
            result.baitEaten = result.baitEaten + visit.baitEaten
            result.baitRemoved = result.baitRemoved + visit.baitRemoved
            result.baitAdded = result.baitAdded + visit.baitAdded
        }
        
        result.totalCatches = result.killsBySpecies.reduce(0, { (x, y) in
            x + y.value
        })
        
        result.catchRate = nil
        if visits.count > 0 {
            result.catchRate = Double(result.totalCatches) / Double(visits.count)
        }
        
        result.numberOfVisits = visits.count
        
        // sort by most recent first
        let sortedVisits = (visits.sorted { $0.visitDateTime > $1.visitDateTime })

        result.lastVisit = sortedVisits.first
        result.visitsWithCatches = sortedVisits.filter { $0.speciesId != nil }

        
        return result
    }
}

extension TrapStatisticsService: TrapStatisticsServiceInterface {
    
    func get(routeId: String, stationId: String, trapTypeId: String, completion: ((TrapStatistics?, Error?) -> Void)?) {
        
        // get all the visits for the route, station, traptype
        visitService.get(routeId: routeId, stationId: stationId, trapTypeId: trapTypeId) { (visits, error) in
            
            if let error = error {
                completion?(nil, error)
            } else {
                if let statistics = self.getStatistics(visits) {
                    completion?(statistics, nil)
                } else {
                    completion?(nil, FirestoreEntityServiceError.generalError)
                }
            }
        }
    }
    
    func get(routeId: String, trapTypeId: String, completion: ((TrapStatistics?, Error?) -> Void)?) {
        
    }
    
}
