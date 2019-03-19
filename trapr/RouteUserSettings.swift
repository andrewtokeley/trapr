//
//  RouteUserSettings.swift
//  trapr
//
//  Created by Andrew Tokeley on 18/02/19.
//  Copyright © 2019 Andrew Tokeley . All rights reserved.
//

import Foundation

enum RouteUserSettingsFields: String {
    case routeId
    case userId
    case hidden
    case isOwner
    case stationIds
}

/**
 - Tag: RouteUserSettings
 */
class RouteUserSettings: DocumentSerializable {
    
    /// Composite primary key in the format routeId_userId
    var id: String?
    var routeId: String?
    var userId: String?
    var isOwner: Bool = false
    var hidden: Bool = false
    var stationIds = [String]()
    
    var dictionary: [String : Any] {
        var result = [String: Any]()
        
        // return fields that are always defined
        result[RouteUserSettingsFields.routeId.rawValue] = self.routeId
        result[RouteUserSettingsFields.userId.rawValue] = self.userId
        result[RouteUserSettingsFields.hidden.rawValue] = self.stationIds
        result[RouteUserSettingsFields.stationIds.rawValue] = stationIds
        result[RouteUserSettingsFields.isOwner.rawValue] = isOwner
        return result
    }
    
    init(routeId: String, userId: String, stationIds: [String] = [String]()) {
        self.id = routeId + "_" + userId
        self.routeId = routeId
        self.userId = userId
        self.stationIds = stationIds
    }
    
    required init?(dictionary: [String: Any]) {
        guard
            let routeId = dictionary[RouteUserSettingsFields.routeId.rawValue] as? String,
            let userId = dictionary[RouteUserSettingsFields.userId.rawValue] as? String,
            let stationIds = dictionary[RouteUserSettingsFields.stationIds.rawValue] as? [String],
            let isOwner = dictionary[RouteUserSettingsFields.isOwner.rawValue] as? Bool
            else {
                return nil
        }
        
        self.routeId = routeId
        self.userId = userId
        self.stationIds = stationIds
        self.isOwner = isOwner
    }
}
