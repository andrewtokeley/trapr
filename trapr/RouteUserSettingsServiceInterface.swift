//
//  RouteUserSettingsServiceInterface.swift
//  trapr
//
//  Created by Andrew Tokeley on 20/02/19.
//  Copyright © 2019 Andrew Tokeley . All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol RouteUserSettingsServiceInterface {
    
    /// Temporary method to add RouteUserSettings records for all existing Routes to ensure the user who created the route has access and is marked as the owner.
    func _addOwnerToOwnerlessRoutes(routes: [Route], completion: (() -> Void)?)
    
    /// Adds, or updates if it already exists, a new routeUserSetting record to the store.
    func add(routeUserSettings: RouteUserSettings, batch: WriteBatch?, completion: ((RouteUserSettings?, Error?) -> Void)?) -> String
    
    /// Deletes the current user's routeUserSettings record for the route.
    func delete(routeId: String, completion: ((Error?) -> Void)?)
    
    /// Deletes the routeUserSettings record matching the id inside a batch transaction. A delete action will not be added to the batch if the current user is not associated with the RouteUserSetting
    func delete(id: String, batch: WriteBatch, completion: ((Error?) -> Void)?)
    
    /// Delete all the routeUserSettings related to the given route. Delete actions will not be added to the batch for RouteUserSettings that are not associated with the current user.
    func delete(routeId: String, batch: WriteBatch, completion: ((Error?) -> Void)?)
    
    /// Delete all RouteUserSettings for the current user, removing their access to all Routes.
    func delete(batch: WriteBatch, completion: ((Error?) -> Void)?)
    
    /// Gets the settings for each `Route` the current user has access to. Overriding the default behaviour of reading from the cache
    func get(source: FirestoreSource, completion: (([RouteUserSettings], Error?) -> Void)?)
    
    /// Gets the settings for each Route the current user has access to.
    func get(completion: (([RouteUserSettings], Error?) -> Void)?)
    
    /// Gets the specified `RouteUserSetting`. If the id refers to a RouteUserSettings object that is not associated with the current user, a nil object and an Error will be returned via the closure.
    func get(id: String, completion: ((RouteUserSettings?, Error?) -> Void)?)
    
    /// Gets the `RouteUserSetting` object for the given `Route` and current user. If the current user does not have access to the Route, both parameters of the closure will be nil.
    func get(routeId: String, completion: ((RouteUserSettings?, Error?) -> Void)?)
    
}
