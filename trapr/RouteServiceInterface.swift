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
    
    /// Create a new Route. The current user will be marked as the owner of the Route in RouteUserSettings.
    func add(route: Route, completion: ((Route?, Error?) -> Void)?) -> String

    func addStationToRoute(routeId: String, stationId: String, completion: ((Route?, Error?) -> Void)?)

    /// Temporary method to add RouteUserSettings records for all existing Routes to ensure the user who created the route has access and is marked as the owner.
    func _addOwnerToOwnerlessRoutes(completion: (() -> Void)?)
    
    func daysSinceLastVisit(routeId: String, completion: ((Int?) -> Void)?)
    
    func daysSinceLastVisitDescription(routeId: String, completion: ((String) -> Void)?)
    
    /// Delete a given route. If the current user doesn't have access to the Route it will not be added to the batch
    //func delete(routeId: String, batch: WriteBatch)
    
    /// Delete a route, including all related RouteUserSettings. The calling user must be the owner of the route.
    func delete(routeId: String, completion: ((Error?) -> Void)?)
    
    /// Delete all routes, including all related RouteUserSettings, that the current user is the owner of.
    func delete(completion: ((Error?) -> Void)?)

    /**
     Returns the specified `Route`. Note, the route must be accessible to the user, otherwise the closure will return nil. Access is determined by the existence of a [RouteUserSettings](x-source-tag://RouteUserSettings) record. If the user doesn't have access the closure will return a FirestoreEntityServiceError.accessDenied error.
     
     - important:
     This method only searches the local cache.

     - parameters:
        - routeId: the id of the Route
     */
    func get(routeId: String, completion: ((Route?, Error?) -> Void)?)

    /**
     Gets all routes the current user has access to. Access is determined by the existence of a [RouteUserSettings](x-source-tag://RouteUserSettings) record.
     
    - important:
     This method only searches the local cache. Use [get(:FirestoreSource)](x-source-tag://getFirestoreSource) to control the source of the search.
     
    - parameters:
         - includeHidden: if true, the closure will return Routes the user has marked as hidden. The default is false.
        - completion: closure that will be called with the results of the request.
     
    */
    func get(includeHidden: Bool, completion: (([Route], Error?) -> Void)?)
    
    /**
Returns all Routes accessible to the current user. Access is determined by the existence of a [RouteUserSettings](x-source-tag://RouteUserSettings) record.
     
- important:
     This method only searches the local cache and routes the user has chosen to hide are NOT returned.
     
- parameters:
    - completion: closure that will be called with the results of the request.
     */
    func get(completion: (([Route], Error?) -> Void)?)
    
    /**
 Returns all `Route` instances accessible to the current user. Access is determined by the existence of a [RouteUserSettings](x-source-tag://RouteUserSettings) record.
 
 - parameters:
     - source: set whether to read from the cache or server
     - includeHidden: set to true to return routes hidden by the user
     - completion: closure that will be called with the results of the request.
 
 - Tag: getFirestoreSource
    */
    func get(source: FirestoreSource, includeHidden: Bool, completion: (([Route], Error?) -> Void)?)
    
    func insertStationToRoute(routeId: String, stationId: String, at index: Int, completion: ((Route?, Error?) -> Void)?)
    
    func removeStationFromRoute(routeId: String, stationId: String, completion: ((Route?, Error?) -> Void)?)
    
    func reorderStations(routeId: String, stationOrder: [String: Int], completion: ((Route?, Error?) -> Void)?)

    func moveStationOnRoute(routeId: String, sourceIndex: Int, destinationIndex: Int, completion: ((Route?, Error?) -> Void)?)
    
    func replaceStationsOn(routeId: String, stationIds: [String], completion: ((Route?, Error?) -> Void)?)
    
    func updateDashboardImage(routeId: String, savedImage: SavedImage, completion: ((Error?) -> Void)?)

    func updateHiddenFlag(routeId: String, isHidden: Bool, completion: ((Error?) -> Void)?)
    
    func updateStations(routeId: String, stationIds: [String], completion: ((Route?, Error?) -> Void)?)

}
