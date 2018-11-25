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
}
class _Route: DocumentSerializable {
    
    var id: String?
    var name: String
    var hidden: Bool = false
    var stationIds = [String]()
    
    var dictionary: [String : Any] {
        var result = [String: Any]()
        
        // return fields that are always defined
        result[RouteFields.name.rawValue] = self.name
        result[RouteFields.hidden.rawValue] = self.hidden
        result[RouteFields.stationIds.rawValue] = self.stationIds
        
        return result
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    required init?(dictionary: [String: Any]) {
        guard
            let name = dictionary[RouteFields.name.rawValue] as? String,
            let hidden = dictionary[RouteFields.hidden.rawValue] as? Bool
        else {
            return nil
        }
        
        self.name = name
        self.hidden = hidden
        
        if let stationIds = dictionary[RouteFields.stationIds.rawValue] as? [String] {
            self.stationIds = stationIds
        }
        
    }
}
