//
//  _Station.swift
//  trapr
//
//  Created by Andrew Tokeley on 3/11/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import FirebaseFirestore

enum StationFields: String {
    case number = "number"
    case coordinates = "location"
    case traplineId = "traplineId"
    case traplineCode = "traplineCode"
    case route = "routeId"
    case region = "regionId"
    case traps = "traps"
    case traps_active = "active"
    case traps_traptype = "trapTypeId"
}

struct TrapTypeStatus {
    var trapTpyeId: String
    var active: Bool
}

class _Station: DocumentSerializable {
    
    /**
     Primary key
     */
    var id: String?
    
    /**
     A number, typically a leading zero number, e.g. "01" for the station. Code need only be unique for the trapline they are part of.
     
     The station code's alphanumeric sort order determines the order in which the stations are located along a trapline. So, it's possible to have "01" followed by "01a", but we recommend sticking to numbers, if possible
     */
    var number: Int
    
    /**
     Returns the station code as a number. If the station code contains non-numerics then nil is returned.
     */
    var codeFormated: String {
        return String(format: "%02d", number)
    }
    
    /**
     Read only, fully qualified station code, that is prefixed with the trapline code. e.g. LW01
     */
    //var longCode: String {
    //    return traplineCode.appending(self.code)
    //}
    
    /**
     Latitude of station
     */
    var latitude: Double?
    
    /**
     Longitude of station
     */
    var longitude: Double?
    
    /// Route the station belongs to. Stations can only belong to one route.
    var routeId: String?
    
    /**
     The id of the trapline in which the station is located
     */
    var traplineId: String?
    
    /**
     The code of the trapline. e.g. LW. Note this may not be unique if the same code is used in another region.
     */
    var traplineCode: String?
    
    /**
     Array containing the traps located at this station and their status (active/inactive), e.g. Possum Master, Pellibait traps...
     */
    var trapTypes = [TrapTypeStatus]()
    
    var dictionary: [String: Any] {
        
        var result = [String: Any]()
        
        result[StationFields.number.rawValue] = self.number
        
        // optional fields, only return in dictionary if they're defined
        
        if let trapTypeId = self.traplineId {
            result[StationFields.traplineId.rawValue] = trapTypeId
        }
        
        if let trapTypeCode = self.traplineCode {
            result[StationFields.traplineCode.rawValue] = trapTypeCode
        }
        
        if let routeId = self.routeId {
            result[StationFields.route.rawValue] = routeId
        }
        
        if let latitude = self.latitude, let longitude = self.longitude {
            result[StationFields.coordinates.rawValue] = GeoPoint(latitude: latitude, longitude: longitude)
        }
        
        var arrayOfMaps = [[String: Any]]()
        for trapType in self.trapTypes {
            arrayOfMaps.append([
                StationFields.traps_traptype.rawValue: trapType.trapTpyeId,
                StationFields.traps_active.rawValue: trapType.active
            ])
        }
        if arrayOfMaps.count > 0 {
            result[StationFields.traps.rawValue] = arrayOfMaps
        }
        
        return result
    }
    
    init(number: Int) {
        self.number = number
    }
    
    required init?(dictionary: [String : Any]) {
        
        // check that mandatory fields are in the dictionary
        guard
            let number = dictionary[StationFields.number.rawValue] as? Int
        else {
            return nil
        }
        
        // set mandatory fields
        self.number = number
        
        // set optional fields
        
        if let coordinates = dictionary[StationFields.coordinates.rawValue] as? GeoPoint {
            self.latitude = coordinates.latitude
            self.longitude = coordinates.longitude
        }

        if let traplineId = dictionary[StationFields.traplineId.rawValue] as? String {
            self.traplineId = traplineId
        }

        if let routeId = dictionary[StationFields.route.rawValue] as? String {
            self.routeId = routeId
        }
        
        if let traplineCode = dictionary[StationFields.traplineCode.rawValue] as? String {
            self.traplineCode = traplineCode
        }
        
        if let traps = dictionary[StationFields.traps.rawValue] as? [[String: Any]] {
            
            self.trapTypes = [TrapTypeStatus]()
            for trapTypeMap in traps {
                if let trapTypeId = trapTypeMap[StationFields.traps_traptype.rawValue] as? String,
                    let trapTypeActive = trapTypeMap[StationFields.traps_active.rawValue] as? Bool {
                    self.trapTypes.append(TrapTypeStatus(trapTpyeId: trapTypeId, active: trapTypeActive))
                }
            }
            
        }
    }
}

extension _Station: Equatable {
    static func == (left: _Station, right: _Station) -> Bool {
        return left.id == right.id
    }
}

