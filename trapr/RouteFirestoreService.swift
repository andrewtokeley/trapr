//
//  RouteFirestoreService.swift
//  trapr
//
//  Created by Andrew Tokeley on 16/11/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import FirebaseFirestore

class RouteFirestoreService: FirestoreEntityService<Route> {
    
    fileprivate lazy var visitService = { ServiceFactory.sharedInstance.visitFirestoreService }()
    fileprivate lazy var userService = { ServiceFactory.sharedInstance.userService }()
    fileprivate lazy var routeUserSettingsService = { ServiceFactory.sharedInstance.routeUserSettingsFirestoreService }()
}

extension RouteFirestoreService: RouteServiceInterface {
    
    func add(route: Route, completion: ((Route?, Error?) -> Void)?) -> String {
        
        if let userId = self.userService.currentUser?.id {
            
            let batch = super.firestore.batch()
            
            let id = super.add(entity: route, batch: batch, completion: nil)
            
            // Create permissions to see the route
            // the user who created the Route should be marked as the owner
            let routeUserSetting = RouteUserSettings(routeId: id, userId: userId)
            routeUserSetting.isOwner = true
            routeUserSetting.hidden = false
            let _ = self.routeUserSettingsService.add(routeUserSettings: routeUserSetting, batch: batch, completion: nil)
            
            // Write the Route and RouteUserSettinbs inside a batch
            batch.commit { (error) in
                completion?(route, error)
            }
            
            return id
            
        } else {
            return ""
        }

    }
    
    func _addOwnerToOwnerlessRoutes(completion: (() -> Void)?) {
        
        // get all routes, regardless of owner - an allows search on the server.
        super.get(source: .server) { (routes, error) in
            
            // make sure there is an owner.
            self.routeUserSettingsService._addOwnerToOwnerlessRoutes(routes: routes) {
                completion?()
            }
        }
    }
    
    func delete(routeId: String, completion: ((Error?) -> Void)?) {
        
        self.routeUserSettingsService.get(routeId: routeId) { (routeUserSettings, error) in
            let isOwner = routeUserSettings?.isOwner ?? false
            if isOwner {
                
                let batch = self.firestore.batch()
                
                self.routeUserSettingsService.delete(routeId: routeId, batch: batch) { (error) in
                    super.delete(entityId: routeId, batch: batch)
                    batch.commit { (error) in
                        completion?(error)
                    }
                }
            } else {
                completion?(FirestoreEntityServiceError.accessDenied)
            }
        }
    }
    
    func delete(completion: ((Error?) -> Void)?) {
        let dispatchGroup = DispatchGroup()
        var lastError: Error?
        
        // get the routes the user has access to and batch up the deletes
        self.get { (routes, error) in
            for route in routes {
                if let routeId = route.id {
                    dispatchGroup.enter()
                    self.delete(routeId: routeId, completion: { (error) in
                        lastError = error
                        dispatchGroup.leave()
                    })
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion?(lastError)
        }
    }
    
    func insertStationToRoute(routeId: String, stationId: String, at index: Int, completion: ((Route?, Error?) -> Void)?) {
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
    
    func addStationToRoute(routeId: String, stationId: String, completion: ((Route?, Error?) -> Void)?) {
        
        var updateRoute: Route?
        
        // Update route.stationIds array
        self.get(routeId: routeId) { (route, error) in
            if let route = route {
                
                updateRoute = route
                
                // make sure we don't add twice
                if !updateRoute!.stationIds.contains(stationId) {
                    updateRoute!.stationIds.append(stationId)
                }
                self.update(entity: updateRoute!, completion: { (error) in
                    completion?(updateRoute, error)
                })
            }
        }
    }
    
    func removeStationFromRoute(routeId: String, stationId: String, completion: ((Route?, Error?) -> Void)?) {
        
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
    
    func replaceStationsOn(routeId: String, stationIds: [String], completion: ((Route?, Error?) -> Void)?) {

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
    
    func moveStationOnRoute(routeId: String, sourceIndex: Int, destinationIndex: Int, completion: ((Route?, Error?) -> Void)?) {
        
        self.get(routeId: routeId) { (route, error) in
            if let route = route {
                let stationIdToMove = route.stationIds[sourceIndex]
                route.stationIds.remove(at: sourceIndex)
                route.stationIds.insert(stationIdToMove, at: destinationIndex)
                
                self.update(entity: route, completion: { (error) in
                    // should really log errors, even if we don't tell the user
                })
                
                completion?(route, nil)
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
    
    func reorderStations(routeId: String, stationOrder: [String : Int], completion: ((Route?, Error?) -> Void)?) {
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
        
        self.routeUserSettingsService.get(routeId: routeId) { (routeUserSettings, error) in
            if let routeUserSettings = routeUserSettings {
                routeUserSettings.hidden = isHidden
                self.routeUserSettingsService.add(routeUserSettings: routeUserSettings, batch: nil, completion: { (routeUserSettings, error) in
                    completion?(error)
                })
            }
        }
    }
    
    func updateDashboardImage(routeId: String, savedImage: SavedImage, completion: ((Error?) -> Void)?) {
        completion?(FirestoreEntityServiceError.notImplemented)
    }
    
//    func get(includeHidden: Bool, completion: (([Route], Error?) -> Void)?) {
//        
//        // get all the routes the user has access to
//        self.get { (routes, error) in
//            
//            var routesToReturn = routes
//            // filter on whether to show hidden or not
//            if !includeHidden {
//                routesToReturn = routes.filter({ $0.hidden == false })
//            }
//            
//            completion?(routesToReturn, error)
//        }
//    }
    
    func get(completion: (([Route], Error?) -> Void)?) {
        self.get(source: .cache, includeHidden: false, completion: { (routes, error) in
            completion?(routes, error)
        })
    }
    
    func get(includeHidden: Bool, completion: (([Route], Error?) -> Void)?) {
        self.get(source: .cache, includeHidden: includeHidden, completion: { (routes, error) in
            completion?(routes, error)
        })
    }
    
    func get(source: FirestoreSource, includeHidden: Bool = true, completion: (([Route], Error?) -> Void)?) {
        
        self.routeUserSettingsService.get(source: source) { (routeUserSettings, error) in
            
            
            // Get the routeId of the routes the users has access and honour the includeHidden flag
            let routeIds = routeUserSettings.filter{ $0.hidden == includeHidden || includeHidden}.map { $0.routeId! }

            // Get the full Route instances for the routeIds
            
            super.get(ids: routeIds, source: source, completion: { (routes, error) in
                
                for route in routes {
                    
                    // for convenience, get the hidden status (for the current user) and put it on the route
                    if let hidden = routeUserSettings.first(where: { $0.routeId == route.id })?.hidden {
                        route.hidden = hidden
                    }
                    
                    // if the user has overridden the station order then update the Route instance
                    if let userStationOrder = routeUserSettings.first(where: {$0.routeId == route.id!} )?.stationIds {
                        route.stationIds = userStationOrder
                    }
                }
                
                completion?(routes, error)
            })
        }
    }
    
    func get(routeId: String, completion: ((Route?, Error?) -> Void)?) {
        super.get(id: routeId) { (route, error) in
            if route?.userId == self.userService.currentUser?.id {
                completion?(route, nil)
            } else {
                completion?(nil, FirestoreEntityServiceError.generalError)
            }
        }
    }
        
    func updateStations(routeId: String, stationIds: [String], completion: ((Route?,  Error?) -> Void)?) {
        //
    }
    
    
    func daysSinceLastVisit(routeId: String, completion: ((Int?) -> Void)?) {
        
        visitService.getMostRecentVisit(routeId: routeId) { (lastVisit) in
            
            if let lastVisit = lastVisit {
                print("Latest date: \(lastVisit.visitDateTime)")
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
}
