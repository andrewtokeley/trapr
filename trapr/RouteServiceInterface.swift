//
//  RouteServiceInterface.swift
//  trapr
//
//  Created by Andrew Tokeley  on 18/10/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift
import FirebaseFirestore

protocol RouteServiceInterface {
    
    func add(route: _Route, completion: ((_Route?, Error?) -> Void)?) -> String
    func delete(routeId: String, completion: ((Error?) -> Void)?)
    func delete(completion: ((Error?) -> Void)?)
    func insertStationToRoute(routeId: String, stationId: String, at index: Int, completion: ((_Route?, Error?) -> Void)?)
    func addStationToRoute(routeId: String, stationId: String, completion: ((_Route?, Error?) -> Void)?)
    func removeStationFromRoute(routeId: String, stationId: String, completion: ((_Route?, Error?) -> Void)?)
    func updateStations(routeId: String, stationIds: [String], completion: ((_Route?, Error?) -> Void)?)
    func replaceStationsOn(routeId: String, stationIds: [String], completion: ((_Route?, Error?) -> Void)?)
    func reorderStations(routeId: String, stationOrder: [String: Int], completion: ((_Route?, Error?) -> Void)?)
    func updateHiddenFlag(routeId: String, isHidden: Bool, completion: ((Error?) -> Void)?)
    func updateDashboardImage(routeId: String, savedImage: SavedImage, completion: ((Error?) -> Void)?)
    
    /// Gets all routes belonging to the current user by hidden flag
    func get(includeHidden: Bool, completion: (([_Route], Error?) -> Void)?)
    
    /// Gets all routes belong to the current user
    func get(completion: (([_Route], Error?) -> Void)?)
    
    func get(source: FirestoreSource, completion: (([_Route], Error?) -> Void)?)
    
    /// Gets specified route. Note it must be owned by the current user.
    func get(routeId: String, completion: ((_Route?, Error?) -> Void)?)
    
    func daysSinceLastVisit(routeId: String, completion: ((Int?) -> Void)?)
    func daysSinceLastVisitDescription(routeId: String, completion: ((String) -> Void)?)
    
    ///should be in Visit service
    //func getMostRecentVisit(route: Route) -> Visit?
    
    
    // To be deprecated once Realm replaced
    
    /**
     Add a new Route to repository. If the Route exists it is updated
     
     - parameters:
        - route: the Route to add to the repository
     */
    func add(route: Route)
    
    /**
     Insert a station into a Route before the given index. If the station already exists it will not be inserted.
     
     - parameters:
     - route: the Route to insert the station into
     - station: the Station to insert
     - index: the index before which to insert the station
     
     - returns:
     True if the insertion was successful, otherwise false
     */
    func insertStationToRoute(route: Route, station: Station, at index: Int) -> Bool
    
    /**
     Adds a station to the end of the Route's station array. If the station already exists it will not be added.
     
     - parameters:
     - route: the Route to insert the station into
     - station: the Station to insert
     
     - returns:
     True if the addition was successful, otherwuse false.
     */
    func addStationToRoute(route: Route, station: Station) -> Bool
    
    func removeStationFromRoute(route: Route, station: Station)
    
    /**
    Merge existing stations with the stations provided
    */
    func updateStations(route: Route, stations: [Station])
    
    func updateHiddenFlag(route: Route, isHidden: Bool)
    
    func updateDashboardImage(route: Route, savedImage: SavedImage)
    
    func replaceStationsOn(route: Route, withStations stations: [Station]) -> Route
    
    func reorderStations(route: Route, stationOrder: [Station: Int]) -> Route
    
    func getMostRecentVisit(route: Route) -> Visit?
    
    func getAll(includeHidden: Bool) -> [Route]
    
    func getAll() -> [Route]
    
    func getById(id: String) -> Route?

    /**
    Delete the route. Note this will not delete any visits that were recorded for the Route
    */
    func delete(route: Route)
    
    func delete(route: Route, cascadeDelete: Bool)
    
    func save(route: Route)
    
    /**
     Returns true if a Route exists that contains exactly the same stations as the supplied Route.
     
     - parameters:
        - route: the Route to compare with existing Routes
     */
    func routeExists(route: Route) -> Bool
    
    /**
     Returns the number of days since the route was visited. If it has never been visited, nil is returned
     */
    func daysSinceLastVisit(route: Route) -> Int?
    func daysSinceLastVisitDescription(route: Route) -> String
    
    
}
