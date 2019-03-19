//
//  RouteUserSettingsFirestoreService.swift
//  trapr
//
//  Created by Andrew Tokeley on 20/02/19.
//  Copyright © 2019 Andrew Tokeley . All rights reserved.
//

import Foundation
import FirebaseFirestore

/**
 The `RouteUserSettingsFirestoreService` is responsible for requesting and persisting data to the Firestore document represented by the `RouteUserSettings`type.
 */
class RouteUserSettingsFirestoreService: FirestoreEntityService<RouteUserSettings> {
    
    fileprivate lazy var userService = { ServiceFactory.sharedInstance.userService }()
    fileprivate lazy var routeService = { ServiceFactory.sharedInstance.routeFirestoreService }()
}

extension RouteUserSettingsFirestoreService: RouteUserSettingsServiceInterface {
    
    func _addOwnerToOwnerlessRoutes(routes: [Route], completion: (() -> Void)?) {
        let dispatchGroup = DispatchGroup()
        for route in routes {
            dispatchGroup.enter()
            if let id = route.id {
                super.get(whereField: RouteUserSettingsFields.routeId.rawValue, isEqualTo: id, source: .server) { (routeUserSettings, error) in
                
                    // check that the owner has a record
                    let ownerSettings = routeUserSettings.first(where: {$0.userId == route.userId})
                    let ownerHasAccess = ownerSettings?.isOwner ?? false
                    
                    // give access to the owner if they don't already
                    if !ownerHasAccess {
                        let newOwnerSettings = RouteUserSettings(routeId: id, userId: route.userId)
                        newOwnerSettings.isOwner = true
                        let _ = super.add(entity: newOwnerSettings) { (settings, error) in
                            dispatchGroup.leave()
                        }
                    } else {
                        dispatchGroup.leave()
                    }
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion?()
        }        
    }
    
    func add(routeUserSettings: RouteUserSettings, completion: ((RouteUserSettings?, Error?) -> Void)?) -> String {
        // can only add your own settings
        guard userService.currentUser?.id == routeUserSettings.id else {
            completion?(nil, FirestoreEntityServiceError.accessDenied)
            return ""
        }
        return super.add(entity: routeUserSettings) { (routeUserSettings, error) in
            completion?(routeUserSettings, error)
        }
    }
    
    func delete(id: String, batch: WriteBatch, completion: ((Error?) -> Void)?) {
        self.get(id: id) { (routeUserSettings, error) in
            
            // only delete if the settings are for the current user
            if routeUserSettings?.userId == self.userService.currentUser?.id {
                super.delete(entityId: id, batch: batch)
                completion?(nil)
            } else {
                // this should never happen!
                completion?(FirestoreEntityServiceError.generalError)
            }
        }
    }
    
    func delete(batch: WriteBatch, completion: ((Error?) -> Void)?) {
        
        let displayGroup = DispatchGroup()
        // get the routeUserSettings for the current user
        self.get { (routeUserSettings, error) in
            for entity in routeUserSettings {
                if let id = entity.id {
                    displayGroup.enter()
                    self.delete(id: id, batch: batch) { (error) in
                        displayGroup.leave()
                    }
                }
            }
        }
        
        displayGroup.notify(queue: .main) {
            completion?(nil)
        }
    }
    
    func delete(routeId: String, completion: ((Error?) -> Void)?) {
        self.get(routeId: routeId) { (routeUserSettings, error) in
            if let id = routeUserSettings?.id {
                super.delete(entityId: id, completion: { (error) in
                    completion?(error)
                })
            } else {
                // the user doesn't have access to this route, so do nothing
                completion?(nil)
            }
        }
    }
    
    func delete(routeId: String, batch: WriteBatch, completion: ((Error?) -> Void)?) {
        self.get(routeId: routeId) { (routeUserSettings, error) in
            if let id = routeUserSettings?.id {
                self.delete(id: id, batch: batch) { (error) in
                    completion?(error)
                }
            } else {
                completion?(nil)
            }
        }
    }
    
    func get(id: String, completion: ((RouteUserSettings?, Error?) -> Void)?) {
        if let userId = self.userService.currentUser?.id {
            super.get(id: id) { (routeUserSetting, error) in
                if routeUserSetting?.userId == userId {
                    completion?(routeUserSetting, error)
                } else {
                    completion?(nil, FirestoreEntityServiceError.accessDenied)
                }
            }
        }
    }
    
    func get(source: FirestoreSource, completion: (([RouteUserSettings], Error?) -> Void)?) {
        if let userId = userService.currentUser?.id {
            super.get(whereField: RouteUserSettingsFields.userId.rawValue, isEqualTo: userId, source: source) { (routeUserSettings, error) in
                completion?(routeUserSettings, error)
            }
        } else {
            completion?([RouteUserSettings](), FirestoreEntityServiceError.accessDenied)
        }
    }
    
    
    func get(completion: (([RouteUserSettings], Error?) -> Void)?) {
        self.get(source: .cache) { (routeUserSettings, error) in
            completion?(routeUserSettings, error)
        }
    }
    
    func get(routeId: String, completion: ((RouteUserSettings?, Error?) -> Void)?) {
        
        // get the routes the user has access to
        self.get { (routeUserSettings, error) in
            // filter by the route of interest
            if let routeUserSettingsForRoute = routeUserSettings.first(where: {$0.routeId == routeId}) {
                completion?(routeUserSettingsForRoute, nil)
            } else {
                completion?(nil, nil)
            }
        }
    }
}
