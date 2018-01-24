//
//  RouteServiceInterface.swift
//  trapr
//
//  Created by Andrew Tokeley  on 18/10/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

protocol RouteServiceInterface: RealmServiceInterface {
    
    /**
     Add a new Route to repository. If the Route exists it is updated
     
     - parameters:
        - route: the Route to add to the repository
     */
    func add(route: Route)
    
    func addStationToRoute(route: Route, station: Station)
    
    func removeStationFromRoute(route: Route, station: Station)
    
    /**
    Merge existing stations with the stations provided
    */
    func updateStations(route: Route, stations: [Station])
    
    func updateHiddenFlag(route: Route, isHidden: Bool)
    
    func replaceStationsOn(route: Route, withStations stations: [Station]) -> Route
    
    func reorderStations(route: Route, stationOrder: [Station: Int]) -> Route
    
    func getAll(includeHidden: Bool) -> [Route]
    
    func getAll() -> [Route]
    
    func getById(id: String) -> Route?
    
    func delete(route: Route)
    
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
}
