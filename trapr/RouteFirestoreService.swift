//
//  RouteFirestoreService.swift
//  trapr
//
//  Created by Andrew Tokeley on 16/11/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

class RouteFirestoreService: FirestoreEntityService<_Route>, RouteServiceInterface {
    
    let stationService = ServiceFactory.sharedInstance.stationFirestoreService
    
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
    
    func insertStationToRoute(routeId: String, stationId: String, at index: Int, completion: ((Error?) -> Void)?) {
        self.get(routeId: routeId) { (route, error) in
            if let route = route {
                if index >= 0 && index < route.stationIds.count {
                    route.stationIds.insert(stationId, at: index)
                } else {
                    // index was illegal, just add the station to the end
                    route.stationIds.append(stationId)
                }
                self.update(entity: route, completion: { (error) in
                    completion?(error)
                })
            }
        }
    }
    
    func addStationToRoute(routeId: String, stationId: String, completion: ((Error?) -> Void)?) {
        
        let dispatchGroup = DispatchGroup()
        var lastError: Error?
        
        // Update route.stationIds array
        self.get(routeId: routeId) { (route, error) in
            if let route = route {
                // make sure we don't add twice
                if !route.stationIds.contains(stationId) {
                    route.stationIds.append(stationId)
                }
                dispatchGroup.enter()
                self.update(entity: route, completion: { (error) in
                    lastError = error
                    dispatchGroup.leave()
                })
            }
        }
        
        // Update station.routeId field
        self.stationService.get(stationId: stationId) { (station, error) in
            
            if let station = station {
                station.routeId = routeId
                dispatchGroup.enter()
                self.stationService.add(station: station, completion: { (station, error) in
                    lastError = error
                    dispatchGroup.leave()
                })
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion?(lastError)
        }
    }
    
    func removeStationFromRoute(routeId: String, stationId: String, completion: ((Error?) -> Void)?) {
        self.get(routeId: routeId) { (route, error) in
            if let route = route {
                route.stationIds.removeAll { $0 == stationId }
                self.update(entity: route, completion: { (error) in
                    completion?(error)
                })
            }
        }
    }
    
    func replaceStationsOn(routeId: String, stationIds: [String], completion: ((_Route?, Error?) -> Void)?) {
        self.get(routeId: routeId) { (route, error) in
            if let route = route {
                route.stationIds = stationIds
                self.update(entity: route, completion: { (error) in
                    completion?(route, error)
                })
            } else {
                completion?(nil, error)
            }
        }
    }
    
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
                completion?(nil, error)
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
    
    func updateStations(routeId: String, stationIds: [String], completion: ((Error?) -> Void)?) {
        //
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
        return nil
    }
    
    func daysSinceLastVisitDescription(route: Route) -> String {
        return ""
    }
    
    
}
