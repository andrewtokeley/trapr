//
//  RouteService.swift
//  trapr
//
//  Created by Andrew Tokeley  on 18/10/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

class RouteService: RealmService, RouteServiceInterface {
    
    func add(route: Route) {
        try! realm.write {
            realm.add(route)
        }
    }
    
    func save(route: Route) {
        try! realm.write {
            realm.add(route, update: true)
        }
    }
    
    func updateStations(route: Route, stations: [Station]) {
        
        // merge the new stations with the ones already defined on the route
        var mergeStations = [Station]()
        mergeStations.append(contentsOf: route.stations)
        
        // check whether any of he existing stations have been removed
        for existingStation in route.stations {
            if !stations.contains(existingStation) {
                if let index = route.stations.index(of: existingStation) {
                    route.stations.remove(at: index)
                }
            }
        }
        
        // check for new stations that need to be added to the route
        for station in stations {
            
            // if the station is not defined on the route already...
            if (!route.stations.contains(station)) {
                
                // add it to the end
                mergeStations.append(station)
            }
        }
        
        // replace the route stations with the merged stations
        try! realm.write {
            route.stations.removeAll()
            
            for station in mergeStations {
                route.stations.append(station)
            }
        }
        
        
    }
    
    func getAll() -> [Route] {
        return Array(realm.objects(Route.self))
    }
    
    func delete(route: Route) {
        try! realm.write {
            realm.delete(route)
        }
    }
    
    func routeExists(route: Route) -> Bool {
        
        // get all the routes
        let routes = getAll()
        
        return routes.contains(where: {
            $0.longDescription == route.longDescription
        })
    }
    
    func daysSinceLastVisit(route: Route) -> Int? {
        
        var numberOfDays: Int?
        
        // find all the visits for this route, ordered from the most recent (the default ordering)
        let visits = ServiceFactory.sharedInstance.visitService.getVisits(recordedBetween: Date().add(0, 0, -100), dateEnd: Date(), route: route)
        
        // take the first result - this is the last visit
        if let lastVisit = visits.first {
            let calendar = NSCalendar.current
            let lastVisitDate = calendar.startOfDay(for: lastVisit.visitDateTime)
            let today = calendar.startOfDay(for: Date())
            
            let components = calendar.dateComponents([.day], from: lastVisitDate, to: today)
            
            numberOfDays = components.day
        }
        
        return numberOfDays
    }
}
