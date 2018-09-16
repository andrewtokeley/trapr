//
//  RouteDashboardInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley on 2/01/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit
import Photos

// MARK: - RouteDashboardInteractor Class
final class RouteDashboardInteractor: Interactor {
    
}

// MARK: - RouteDashboardInteractor API
extension RouteDashboardInteractor: RouteDashboardInteractorApi {
    
    func setRouteImage(route: Route, asset: PHAsset, completion: (() -> Swift.Void)?) {
        
        ServiceFactory.sharedInstance.savedImageService.addOrUpdateSavedImage(asset: asset, completion: {
            (savedImage) in
            // let presenter know we've got a new image.
            ServiceFactory.sharedInstance.routeService.updateDashboardImage(route: route, savedImage: savedImage)
            
            completion?()
        })
    }
    
    func lastVisitSummary(route: Route) -> VisitSummary? {
        return ServiceFactory.sharedInstance.visitService.getVisitSummaryMostRecent(route: route)
    }
    
    func timeDescription(route: Route) -> String {
        
        // get the times for all visitSummaries
        let summaries = ServiceFactory.sharedInstance.visitService.getVisitSummaries(recordedBetween: Date().add(0, 0, -100), endDate: Date(), route: route)
        
        if let visitStatistics = ServiceFactory.sharedInstance.visitService.getStatistics(visitSummaries: summaries) {
            return "Fastest: \(visitStatistics.fastestTimeTaken.formatInTimeUnits()!) | Average: \(visitStatistics.averageTimeTaken.formatInTimeUnits()!)"
        } else {
            return "-"
        }
    }
    
    func lastVisitedText(route: Route) -> String? {
        var text:String?
        
        if let lastVisitSummary = lastVisitSummary(route: route) {
            text = lastVisitSummary.visits.first?.visitDateTime.toString(from: "dd MMM yyyy, h:mm a")
        }
        
        return text
    }
    
    func getStationSequence(_ from: Station, _ to:Station) -> [Station]? {
        return ServiceFactory.sharedInstance.stationService.getStationSequence(from, to)
    }
    
    func killCounts(frequency: TimeFrequency, period: TimeFrequency, route: Route) -> StackCount? {
        
        // TODO: ignoring frequency/period for now, support quarterly charts perhaps?
        
        let allSpecies = ServiceFactory.sharedInstance.speciesService.getAll()
        var indexOfSpeciesWithCount = [Int]()
        
        // will contain an array for each month, with space for counts for every species
        var yValues = [[Int]](repeatElement([Int](repeatElement(0, count: allSpecies.count)), count: 12))
        
        for barIndex in 0...11 {
            let monthOffset = -(12 - (barIndex + 1))
            let counts = ServiceFactory.sharedInstance.visitService.killCounts(monthOffset: monthOffset, route: route)
            
            // put each species count in the right place
            for species in counts.keys {
                if let position = allSpecies.index(of: species) {
                    if (!indexOfSpeciesWithCount.contains(position)) {
                        indexOfSpeciesWithCount.append(position)
                    }
                    yValues[barIndex][position] = counts[species] ?? 0
                }
            }
        }
        
        // remove any species which have zero counts for all barIndexes
        let trimmedYValues = yValues.map({
            (values) -> [Int] in
            var trimmedValues: [Int] = [Int]()
            
            for species in allSpecies {
                if let indexOfSpecies = allSpecies.index(of: species) {
                    if indexOfSpeciesWithCount.contains(indexOfSpecies) {
                        trimmedValues.append(values[indexOfSpecies])
                    }
                }
            }
            return trimmedValues
        })
        
        var trimmedSpecies: [Species] = [Species]()
        for index in 0...11 {
            if indexOfSpeciesWithCount.contains(index) {
                trimmedSpecies.append(allSpecies[index])
            }
        }
        let stackLabels = trimmedSpecies.map({ $0.name ?? "" } )
        
        return StackCount(stackLabels, trimmedYValues)
        
    }
    
    func poisonCounts(frequency: TimeFrequency, period: TimeFrequency, route: Route) -> StackCount? {
        
        let stackLabels = ["Poison"]
        var counts = [[Int]]()
        
        for barIndex in 0...11 {
            let monthOffset = -(12 - (barIndex + 1))
            counts.append([ServiceFactory.sharedInstance.visitService.poisonCount(monthOffset: monthOffset, route: route)])
        }
        return StackCount(stackLabels, counts)
    }
    
    func getRouteName() -> String {
        return "Untitled Route"
    }
    
    func deleteRoute(route: Route)
    {
        // sometimes we're given a copy of the route, best to get from realm first.
        if let routeToDelete = ServiceFactory.sharedInstance.routeService.getById(id: route.id) {
            
            // cascade delete all the visits too
            ServiceFactory.sharedInstance.routeService.delete(route: routeToDelete, cascadeDelete: true)
        }
    }
    
    func addStationToRoute(route: Route, station: Station) -> Route {
        let service = ServiceFactory.sharedInstance.routeService
        let _ = service.addStationToRoute(route: route, station: station)
        return service.getById(id: route.id)!
    }
    
    func removeStationFromRoute(route: Route, station: Station) -> Route {
        let service = ServiceFactory.sharedInstance.routeService
        service.removeStationFromRoute(route: route, station: station)
        return service.getById(id: route.id)!
    }
    
    func visitsExistForRoute(route: Route) -> Bool {
        let service = ServiceFactory.sharedInstance.visitService
        return service.visitsExistForRoute(route: route)
    }
    
    func numberOfVisits(route: Route) -> Int {
        let service = ServiceFactory.sharedInstance.visitService
        
        // Get all the summaries from year dot, order with the most recent first
        let visitSummaries = service.getVisitSummaries(recordedBetween: Date().add(0, 0, -100), endDate: Date(), route: route)
        
        return visitSummaries.count
    }
    
}

// MARK: - Interactor Viper Components Api
private extension RouteDashboardInteractor {
    var presenter: RouteDashboardPresenterApi {
        return _presenter as! RouteDashboardPresenterApi
    }
}
