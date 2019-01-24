//
//  RouteServiceInterface.swift
//  trapr
//
//  Created by Andrew Tokeley  on 18/10/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol RouteServiceInterface {
    
    func add(route: _Route, completion: ((_Route?, Error?) -> Void)?) -> String

    func addStationToRoute(routeId: String, stationId: String, completion: ((_Route?, Error?) -> Void)?)
    
    func daysSinceLastVisit(routeId: String, completion: ((Int?) -> Void)?)
    
    func daysSinceLastVisitDescription(routeId: String, completion: ((String) -> Void)?)
    
    func delete(routeId: String, completion: ((Error?) -> Void)?)
    
    func delete(completion: ((Error?) -> Void)?)

    /// Gets specified route. Note it must be owned by the current user.
    func get(routeId: String, completion: ((_Route?, Error?) -> Void)?)

    /// Gets all routes belonging to the current user by hidden flag
    func get(includeHidden: Bool, completion: (([_Route], Error?) -> Void)?)
    
    /// Gets all routes belong to the current user
    func get(completion: (([_Route], Error?) -> Void)?)
    
    /// Gets all routes for the given source
    func get(source: FirestoreSource, completion: (([_Route], Error?) -> Void)?)
    
    func insertStationToRoute(routeId: String, stationId: String, at index: Int, completion: ((_Route?, Error?) -> Void)?)
    
    func removeStationFromRoute(routeId: String, stationId: String, completion: ((_Route?, Error?) -> Void)?)
    
    func reorderStations(routeId: String, stationOrder: [String: Int], completion: ((_Route?, Error?) -> Void)?)

    func replaceStationsOn(routeId: String, stationIds: [String], completion: ((_Route?, Error?) -> Void)?)
    
    func updateDashboardImage(routeId: String, savedImage: SavedImage, completion: ((Error?) -> Void)?)

    func updateHiddenFlag(routeId: String, isHidden: Bool, completion: ((Error?) -> Void)?)
    
    func updateStations(routeId: String, stationIds: [String], completion: ((_Route?, Error?) -> Void)?)

}
