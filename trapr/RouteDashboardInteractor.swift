//
//  RouteDashboardInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley on 2/01/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - RouteDashboardInteractor Class
final class RouteDashboardInteractor: Interactor {
    
}

// MARK: - RouteDashboardInteractor API
extension RouteDashboardInteractor: RouteDashboardInteractorApi {
    
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
        service.addStationToRoute(route: route, station: station)
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
    
}

// MARK: - Interactor Viper Components Api
private extension RouteDashboardInteractor {
    var presenter: RouteDashboardPresenterApi {
        return _presenter as! RouteDashboardPresenterApi
    }
}
