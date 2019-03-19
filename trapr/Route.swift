//
//  _Route.swift
//  trapr
//
//  Created by Andrew Tokeley on 4/11/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

enum RouteFields: String {
    case name = "name"
    case hidden = "hidden"
    case stationIds = "stations"
    case userId = "user"
    case users = "users"
}
class Route: DocumentSerializable {
    
    var id: String?
    var name: String
    
    /// Whether to hide the route from the main dashboard (DEPRECATE, needs to be per user)
    var hidden: Bool = false
    
    /// The ids of the stations on the Route and their default ordering
    var stationIds = [String]()
    
    /// the user who created the Route (DEPRECATE, may not need this)
    var userId: String
    
    var dictionary: [String : Any] {
        var result = [String: Any]()
        
        // return fields that are always defined
        result[RouteFields.name.rawValue] = self.name
        result[RouteFields.hidden.rawValue] = self.hidden
        result[RouteFields.stationIds.rawValue] = self.stationIds
        result[RouteFields.userId.rawValue] = self.userId
        
        return result
    }
    
    /**
     Initialise a new `Route`. If the calling user is not authenticated an exception is thrown.
     
     - throws: `FirestoreEntityServiceError.accessDenied` if there is no currently logged in user
     
    */
    init(name: String, stationIds: [String]) throws {
        
        self.name = name
        self.stationIds = stationIds
        
        if let userId = ServiceFactory.sharedInstance.userService.currentUser?.id {
            self.userId = userId
        } else {
            throw FirestoreEntityServiceError.accessDenied
        }
    }
    
    required init?(dictionary: [String: Any]) {
        guard
            let name = dictionary[RouteFields.name.rawValue] as? String,
            let hidden = dictionary[RouteFields.hidden.rawValue] as? Bool
        else {
            return nil
        }
        
        // userId is mandatory but some old records won't have it set
        let userId = dictionary[RouteFields.userId.rawValue] as? String ?? "anon"
        self.userId = userId

        self.name = name
        self.hidden = hidden
        
        if let stationIds = dictionary[RouteFields.stationIds.rawValue] as? [String] {
            self.stationIds = stationIds
        }
        
    }
}

extension Route: Equatable {
    static func == (left: Route, right: Route) -> Bool {
        return left.id == right.id
    }
}

extension Route: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let route = Route(dictionary: self.dictionary)
        route?.id = self.id
        return route
    }
}
