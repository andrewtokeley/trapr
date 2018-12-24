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
}
class _Route: DocumentSerializable {
    
    var id: String?
    var name: String
    var hidden: Bool = false
    var stationIds = [String]()
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
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
        
        if let userId = ServiceFactory.sharedInstance.userService.currentUser?.id {
            self.userId = userId
        } else {
            self.userId = "anon"
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

extension _Route: Equatable {
    static func == (left: _Route, right: _Route) -> Bool {
        return left.id == right.id
    }
}

extension _Route: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        let route = _Route(dictionary: self.dictionary)
        route?.id = self.id
        return route
    }
}
