//
//  RouteFirestoreService.swift
//  trapr
//
//  Created by Andrew Tokeley on 16/11/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

class RouteFirestoreService: FirestoreEntityService<_Route>, RouteServiceInterface {
    
    
    //let stationService = ServiceFactory.sharedInstance.stationFirestoreService
    let visitService = ServiceFactory.sharedInstance.visitFirestoreService
    
    func add(route: _Route, completion: ((_Route?, Error?) -> Void)?) {
        let _ = super.add(entity: route) { (route, error) in
            completion?(route, error)
        }
    }
    
    func delete(routeId: String, completion: ((Error?) -> Void)?) {
        super.delete(entityId: routeId) { (error) in
            completion?(error)
        }
    }
    
    func delete(completion: ((Error?) -> Void)?) {
        super.deleteAllEntities { (error) in
            completion?(error)
        }
    }
    
    func insertStationToRoute(routeId: String, stationId: String, at index: Int, completion: ((_Route?, Error?) -> Void)?) {
        self.get(routeId: routeId) { (route, error) in
            if let route = route {
                if index >= 0 && index < route.stationIds.count {
                    route.stationIds.insert(stationId, at: index)
                } else {
                    // index was illegal, just add the station to the end
                    route.stationIds.append(stationId)
                }
                self.update(entity: route, completion: { (error) in
                    completion?(route, error)
                })
            }
        }
    }
    
    func addStationToRoute(routeId: String, stationId: String, completion: ((_Route?, Error?) -> Void)?) {
        
        let dispatchGroup = DispatchGroup()
        var updateRoute: _Route?
        
        // Update route.stationIds array
        self.get(routeId: routeId) { (route, error) in
            if let route = route {
                
                updateRoute = route
                
                // make sure we don't add twice
                if !updateRoute!.stationIds.contains(stationId) {
                    updateRoute!.stationIds.append(stationId)
                }
                dispatchGroup.enter()
                self.update(entity: updateRoute!, completion: { (error) in
                    completion?(updateRoute, error)
                })
            }
        }
        
        // Update station.routeId field
//        self.stationService.get(stationId: stationId) { (station, error) in
//
//            if let station = station {
//                station.routeId = routeId
//                dispatchGroup.enter()
//                self.stationService.add(station: station, completion: { (station, error) in
//                    lastError = error
//                    dispatchGroup.leave()
//                })
//            }
//        }
        
//        dispatchGroup.notify(queue: .main) {
//            completion?(updateRoute, lastError)
//        }
    }
    
    func removeStationFromRoute(routeId: String, stationId: String, completion: ((_Route?, Error?) -> Void)?) {
        
        self.get(routeId: routeId) { (route, error) in
            if let route = route {
                
                // Remove from the Route record
                route.stationIds.removeAll(where: { $0 == stationId })
                self.update(entity: route, completion: { (error) in
                    completion?(route, error)
//                    // Remove from each Station record
//                    self.setRouteForStations(routeId: routeId, stationIds: [stationId], completion: { (error) in
//
//                    })
                })
            } else {
                completion?(nil, FirestoreEntityServiceError.generalError)
            }
        }
        
    }
    
    func replaceStationsOn(routeId: String, stationIds: [String], completion: ((_Route?, Error?) -> Void)?) {

        self.get(routeId: routeId) { (route, error) in
            if let route = route {
                
//                // For any stations that should no longer be part of the route, remove their references to the Route
//                let stationsToRemove = route.stationIds.filter( { !stationIds.contains($0) } )
//                print("Removing stations: \(stationsToRemove)")
//                self.setRouteForStations(routeId: nil, stationIds: stationsToRemove, completion: nil )
//
//                // For any new stations on the route
//                let stationsToAdd = stationIds.filter({ !route.stationIds.contains($0)})
//                print("Adding stations: \(stationsToAdd)")
//                self.setRouteForStations(routeId: routeId, stationIds: stationsToAdd, completion: nil)
                
                // update the route record
                route.stationIds = stationIds
                self.update(entity: route) { (  error) in
                    completion?(route, nil)
                }
            } else {
                completion?(nil, FirestoreEntityServiceError.generalError)
            }
        }
    }
    
//    private func setRouteForStations(routeId: String?, stationIds: [String], completion: ((Error?) -> Void)?) {
//
//        self.stationService.get(stationIds: stationIds, completion: { (stations, error) in
//            for station in stations {
//                station.routeId = routeId
//                self.stationService.add(station: station, completion: nil )
//            }
//            completion?(error)
//        })
//    }
    
    func reorderStations(routeId: String, stationOrder: [String : Int], completion: ((_Route?, Error?) -> Void)?) {
        self.get(routeId: routeId) { (route, error) in
            if let route = route {
                route.stationIds.removeAll()
                for order in stationOrder.sorted(by: { $0.value < $1.value }) {
                    route.stationIds.append(order.key)
                }
                self.update(entity: route, completion: { (error) in
                    completion?(route, error)
                })
            } else {
                completion?(nil, FirestoreEntityServiceError.generalError)
            }
        }
    }
    
    func updateHiddenFlag(routeId: String, isHidden: Bool, completion: ((Error?) -> Void)?) {
        self.get(routeId: routeId) { (route, error) in
            if let route = route {
                route.hidden = isHidden
                self.update(entity: route, completion: { (error) in
                    completion?(error)
                })
            }
        }
    }
    
    func updateDashboardImage(routeId: String, savedImage: SavedImage, completion: ((Error?) -> Void)?) {
        completion?(FirestoreEntityServiceError.notImplemented)
    }
    
    func get(includeHidden: Bool, completion: (([_Route], Error?) -> Void)?) {
        super.get(whereField: RouteFields.hidden.rawValue, isEqualTo: includeHidden) { (routes, error) in
            completion?(routes, error)
        }
    }
    
    func get(completion: (([_Route], Error?) -> Void)?) {
        super.get(orderByField: RouteFields.name.rawValue) { (routes, error) in
            completion?(routes, error)
        }
    }
    
    func get(routeId: String, completion: ((_Route?, Error?) -> Void)?) {
        super.get(id: routeId) { (route, error) in
            completion?(route, error)
        }
    }
        
    func updateStations(routeId: String, stationIds: [String], completion: ((_Route?,  Error?) -> Void)?) {
        //
    }
    
    
    func daysSinceLastVisit(routeId: String, completion: ((Int?) -> Void)?) {
        
        visitService.getMostRecentVisit(routeId: routeId) { (lastVisit) in
            
            if let lastVisit = lastVisit {
                let calendar = NSCalendar.current
                let lastVisitDate = calendar.startOfDay(for: lastVisit.visitDateTime)
                let today = calendar.startOfDay(for: Date())
                
                let components = calendar.dateComponents([.day], from: lastVisitDate, to: today)
                
                completion?(components.day)
            } else {
                completion?(nil)
            }
        }
    }
    
    func daysSinceLastVisitDescription(routeId: String, completion: ((String) -> Void)?) {
        var description: String = "Not Visited"
        self.daysSinceLastVisit(routeId: routeId) { (days) in
            
            if let days = days {
                if days == 0 {
                    description = "Today"
                } else if days == 1 {
                    description = "Yesterday"
                } else {
                    description = "\(days) days"
                }
            }
            completion?(description)
        }
    }
    
    
    // Not used by Firestore service
    
    func add(route: Route) {
        
    }
    
    func insertStationToRoute(route: Route, station: Station, at index: Int) -> Bool {
        return false
    }
    
    func addStationToRoute(route: Route, station: Station) -> Bool {
        return false
    }
    
    func removeStationFromRoute(route: Route, station: Station) {
        
    }
    
    func updateStations(route: Route, stations: [Station]) {
        
    }
    
    func updateHiddenFlag(route: Route, isHidden: Bool) {
        
    }
    
    func updateDashboardImage(route: Route, savedImage: SavedImage) {
    
    }
    
    func replaceStationsOn(route: Route, withStations stations: [Station]) -> Route {
        return Route(name: "", visits: [Visit]())
    }
    
    func reorderStations(route: Route, stationOrder: [Station : Int]) -> Route {
        return Route(name: "", visits: [Visit]())
    }
    
    func getMostRecentVisit(route: Route) -> Visit? {
        return nil
    }
    
    func getAll(includeHidden: Bool) -> [Route] {
        return [Route]()
    }
    
    func getAll() -> [Route] {
        return [Route]()
    }
    
    func getById(id: String) -> Route? {
        return nil
    }
    
    func delete(route: Route) {
        
    }
    
    func delete(route: Route, cascadeDelete: Bool) {
        
    }
    
    func save(route: Route) {
        
    }
    
    func routeExists(route: Route) -> Bool {
        return false
    }
    
    func daysSinceLastVisit(route: Route) -> Int? {
        
        var numberOfDays: Int?
        
        // take the first result - this is the last visit
        
        if let lastVisit = self.getMostRecentVisit(route: route) {
            let calendar = NSCalendar.current
            let lastVisitDate = calendar.startOfDay(for: lastVisit.visitDateTime)
            let today = calendar.startOfDay(for: Date())
            
            let components = calendar.dateComponents([.day], from: lastVisitDate, to: today)
            
            numberOfDays = components.day
        }
        
        return numberOfDays
    }
    
    func daysSinceLastVisitDescription(route: Route) -> String {
        var description: String = "Not Visited"
        
        if let days = daysSinceLastVisit(route: route) {
            if days == 0 {
                description = "Today"
            } else if days == 1 {
                description = "Yesterday"
            } else {
                description = "\(days) days"
            }
        }
        return description
    }
    
    
}
