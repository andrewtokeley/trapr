//
//  VisitSummaryFirebaseService.swift
//  trapr
//
//  Created by Andrew Tokeley on 15/11/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

class VisitSummaryFirebaseService: FirestoreService, VisitSummaryServiceInterface {
    
    let visitService = ServiceFactory.sharedInstance.visitFirestoreService
    let trapTypeService = ServiceFactory.sharedInstance.trapTypeFirestoreService
    let stationService = ServiceFactory.sharedInstance.stationFirestoreService
    
    func get(date: Date, routeId: String, completion: ((_VisitSummary?, Error?) -> Void)?) {

        self.visitService.get(recordedOn: date, routeId: routeId) { (visits, error) in
            
            let visitSummary = _VisitSummary(dateOfVisit: date, routeId: routeId)
            visitSummary.visits = visits

            // calculated the totals
            var totalPoisonAdded: Int = 0
            var totalKills: Int = 0
            var totalKillsBySpecies = [String: Int]()
            
            // need details from the trapTypes to get some extra stats
            self.trapTypeService.get(completion: { (trapTypes, error) in
                
                // ids of all the poison traptypes
                let poisonTrapTypes = trapTypes.filter( { $0.killMethod == _KillMethod.poison }).map( { $0.id! } )
                
                // iterate over visits that were for poison traptypes
                for visit in visits {
                    
                    if poisonTrapTypes.contains(visit.trapTypeId) {
                        totalPoisonAdded += visit.baitAdded
                    }
                    if let species = visit.speciesId {
                        totalKills += 1
                        if let _ = totalKillsBySpecies[species] {
                            totalKillsBySpecies[species]! += 1
                        } else {
                            totalKillsBySpecies[species] = 1
                        }
                    }
                    
                }
                
                // We also need to know how many traps are on the route
                self.stationService.get(routeId: routeId, completion: { (stations) in
                    
                    let numberOfTrapsOnRoute = stations.reduce(0, { (result, station) -> Int in
                        return result + station.trapTypes.count
                    })
                    visitSummary.totalPoisonAdded = totalPoisonAdded
                    visitSummary.totalKills = totalKills
                    visitSummary.totalKillsBySpecies = totalKillsBySpecies
                    visitSummary.numberOfTrapsOnRoute = numberOfTrapsOnRoute
                    completion?(visitSummary, error)
                })                
            })
        }
    }
    
    func get(recordedBetween startDate: Date, endDate: Date, routeId: String, completion: (([_VisitSummary], Error?) -> Void)?) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyy"
        
        var summaries = [_VisitSummary]()
        
        visitService.get(recordedBetween: startDate, dateEnd: endDate, routeId: routeId) { (visits, error) in
            
            // Find the unique days where visits were recorded
            var uniqueDates = [String]()
            for visit in visits {
                let visitDate = dateFormatter.string(from: visit.visitDateTime)
                if !uniqueDates.contains(visitDate) {
                    uniqueDates.append(visitDate)
                }
            }
            
            // Create a VisitSummary for each day's visit
            for aDate in uniqueDates {
                if let date = dateFormatter.date(from: aDate) {
                    let visitSummary = _VisitSummary(dateOfVisit: date, routeId: routeId)
                    visitSummary.visits = visits.filter({ (visit) -> Bool in
                        return dateFormatter.string(from: visit.visitDateTime) == aDate
                    })
                    summaries.append(visitSummary)
                }
            }
            
            completion?(summaries, nil)
        }
    }
    
    func get(mostRecentOn routeId: String, completion: ((_VisitSummary?, Error?) -> Void)?) {
        
    }
    
    func getStatistics(from visitSummaries: [_VisitSummary], completion: ((VisitSummariesStatistics?, Error?) -> Void)?) {
        
    }
    
    
}
