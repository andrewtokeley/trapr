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
    let routeService = ServiceFactory.sharedInstance.routeFirestoreService
    
    private func createVisitSummary(date: Date, routeId: String, visits: [Visit], completion: ((VisitSummary?, Error?) -> Void)?) {
        
        let visitSummary = VisitSummary(dateOfVisit: date, routeId: routeId)
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
            visitSummary.totalPoisonAdded = totalPoisonAdded
            visitSummary.totalKills = totalKills
            visitSummary.totalKillsBySpecies = totalKillsBySpecies
            
            // We also need to know how many traps/stations are on the route
            self.stationService.get(routeId: routeId, completion: { (stations) in
                
                visitSummary.stationsOnRoute = stations
                
                let numberOfTrapsOnRoute = stations.reduce(0, { (result, station) -> Int in
                    return result + station.trapTypes.count
                })
                visitSummary.numberOfTrapsOnRoute = numberOfTrapsOnRoute
                
                // And the route itself.
                self.routeService.get(routeId: routeId, completion: { (route, error) in
                    visitSummary.route = route
                    
                    // All done
                    completion?(visitSummary, error)
                })
            })
        })
    }
    
    func createNewVisitSummary(date: Date, routeId: String, completion: ((VisitSummary?, Error?) -> Void)?) {
        self.createVisitSummary(date: date, routeId: routeId, visits: [Visit]()) { (visitSummary, error) in
            completion?(visitSummary, error)
        }
    }
    
    func get(date: Date, routeId: String, completion: ((VisitSummary?, Error?) -> Void)?) {

        self.visitService.get(recordedOn: date, routeId: routeId) { (visits, error) in
            
            self.createVisitSummary(date: date, routeId: routeId, visits: visits, completion: { (summaries, error) in
                completion?(summaries, error)
            })
            
        }
    }
    
    func get(recordedBetween startDate: Date, endDate: Date, routeId: String, completion: (([VisitSummary], Error?) -> Void)?) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyy"
        
        var summaries = [VisitSummary]()
        
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
            let dispatchGroup = DispatchGroup()
            for aDate in uniqueDates {
                if let date = dateFormatter.date(from: aDate) {
                    
                    let visits = visits.filter({ dateFormatter.string(from: $0.visitDateTime) == aDate })
                    dispatchGroup.enter()
                    self.createVisitSummary(date: date, routeId: routeId, visits: visits) { (visitSummary, error) in
                        if let visitSummary = visitSummary {
                            summaries.append(visitSummary)
                        }
                        dispatchGroup.leave()
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main, execute: {
                completion?(summaries.sorted(by: { $0.dateOfVisit > $1.dateOfVisit}), nil)
            })
            
        }
    }
    
    func get(mostRecentOn routeId: String, completion: ((VisitSummary?, Error?) -> Void)?) {
        
        self.get(recordedBetween: Date().add(0, -3, 0), endDate: Date(), routeId: routeId) { (visitSummaries, error) in
            if let error = error {
                completion?(nil, error)
            } else {
                // latest
                let mostRecent = visitSummaries.sorted(by: { $0.dateOfVisit > $1.dateOfVisit }).first
                completion?(mostRecent, nil)
            }
        }
    }
    
    func getStatistics(from visitSummaries: [VisitSummary], completion: ((VisitSummariesStatistics?, Error?) -> Void)?) {
        
        var visitStats = VisitSummariesStatistics()
        
        // Get all the visits across all the visitSummaries
        let visits = visitSummaries.flatMap { (summary) -> [Visit] in
            return summary.visits
        }
        
        // Need details from the trapTypes to get some extra stats
        self.trapTypeService.get { (trapTypes, error) in
            
            // ids of all the poison traptypes
            let poisonTrapTypes = trapTypes.filter( { $0.killMethod == _KillMethod.poison }).map( { $0.id! } )
            
            // iterate over visits to count poison and kills
            for visit in visits {
                
                if poisonTrapTypes.contains(visit.trapTypeId) {
                    visitStats.totalPoisonAdded += visit.baitAdded
                }
                if let speciesId = visit.speciesId {
                    visitStats.totalKills += 1
                    if let _ = visitStats.totalKillsBySpecies[speciesId] {
                        visitStats.totalKillsBySpecies[speciesId]! += 1
                    } else {
                        visitStats.totalKillsBySpecies[speciesId] = 1
                    }
                }
            }
            
            // for average and fastest times only consider when all traps were visited.
            let fullyVisitedSummaries = visitSummaries.filter({ $0.numberOfTrapsOnRoute == $0.numberOfTrapsVisited }).sorted(by: { $0.timeTaken < $1.timeTaken })
            
            // Average time
            let totalTimeTakenOnFullyVisitedSummaries = fullyVisitedSummaries.reduce(0, { $0 + $1.timeTaken })
            visitStats.averageTimeTaken = totalTimeTakenOnFullyVisitedSummaries/Double(fullyVisitedSummaries.count)
            
            // Fastest time
            if let fastestTime = fullyVisitedSummaries.first?.timeTaken {
                visitStats.fastestTimeTaken = fastestTime
            }
            
            completion?(visitStats, nil)
        }
    }
    
}
