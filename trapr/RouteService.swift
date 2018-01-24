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
            let _ = realm.create(Route.self, value: route, update: true)
        }
    }
    
    func addStationToRoute(route: Route, station: Station) {
        
        // for now just add to the end - should be smarter to get the order right
        try! realm.write {
            route.stations.append(station)
        }
    }
    
    func removeStationFromRoute(route: Route, station: Station) {
        if let index = route.stations.index(of: station) {
            try! realm.write {
                route.stations.remove(at: index)
            }
        }
    }
    
    func reorderStations(route: Route, stationOrder: [Station: Int]) -> Route {
        
        guard stationOrder.count == route.stations.count else { return route }
        
        // flatten out the stations in the right order
        let stations = stationOrder.sorted(by: { $0.value < $1.value }).map({ $0.key })
        
        // replace the route stations with the merged stations
        try! realm.write {
            route.stations.removeAll()
            route.stations.append(objectsIn: stations)
        }
        
        return route
    }
    
    func replaceStationsOn(route: Route, withStations stations: [Station]) -> Route {
        
        try! realm.write {
            route.stations.removeAll()
            route.stations.append(objectsIn: stations)
        }
        
        return route
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
    
    func updateHiddenFlag(route: Route, isHidden: Bool) {
        try! realm.write {
            route.isHidden = isHidden
        }
    }
    
    func getAll(includeHidden: Bool) -> [Route] {
        if !includeHidden {
            return Array(realm.objects(Route.self).filter( {$0.isHidden == false }))
        } else {
            return Array(realm.objects(Route.self))
        }
    }
    
    func getAll() -> [Route] {
        return Array(realm.objects(Route.self))
    }
    
    func getById(id: String) -> Route? {
        return realm.object(ofType: Route.self, forPrimaryKey: id)
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
