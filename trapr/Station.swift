//
//  Station.swift
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

protocol LocatableEntity {
    var locationId: String { get }
    var title: String { get }
    var subTitle: String { get }
    var latitude: Double? { get set }
    var longitude: Double? { get set }
}

extension Station: LocatableEntity {
    var title: String {
        return self.codeFormated
    }
    
    var subTitle: String {
        return self.longCode
    }
    
    /**
     Always available id for location entity
     */
    var locationId: String {
        if let id = self.id {
            return id
        }
        return ""
    }
    
}

class Station: DocumentSerializable {
    
    /**
     Composite primary key in the format traplineCode-stationCodeFormated, e.g. EHRP-LW-01 for East Harbour Regional Park, trapline LW, station 01.
     */
    var id: String?

    /**
     A number for the station. Stations along a line typically have sequential numbers.
     */
    var number: Int
    
    /**
     Returns the station code as a number. If the station code contains non-numerics then nil is returned.
     */
    var codeFormated: String {
        return String(format: "%02d", number)
    }
    
    /**
     Latitude of station
     */
    var latitude: Double?
    
    /**
     Longitude of station
     */
    var longitude: Double?
    
    /**
     Read only, fully qualified station code, that is prefixed with the trapline code. e.g. LW01
     */
    var longCode: String {
        return "\(traplineCode ?? "**")\(codeFormated)"
    }
    
    /**
     Read only, fully qualified station code,  as per the definition Walk the Line. e.g. always three characters, U01, LW1, LW32. I think the rule is to always true and make the code 3 characters - I guess they're assuming there's not a GC10.
        
     Rule:
     - If the traplineCode length equals 1 then format number to 2 characters
     - if the traplineCode length equals 2 then don't format the number at all
     */
    var longCodeWalkTheLine: String {
        let codeLength = traplineCode?.count ?? 0
        let numberLength = String(number).count
        
        if codeLength == 1 && numberLength <= 2 {
            // gaurenteed to be length of three
            return longCode
        } else {
            return "\(traplineCode ?? "**")\(String(number))"
        }
    }
    
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
    
    init(traplineId: String, number: Int) {
        self.id = "\(traplineId)-\(String(format: "%02d", number))"
        self.traplineId = traplineId
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

extension Station: Equatable {
    static func == (left: Station, right: Station) -> Bool {
        return left.id == right.id
    }
}

extension Station: Hashable {
    
    /**
        Implementing this method allows Lookup instances to be compared based on their id
    */
    func hash(into hasher: inout Hasher) {
        if let id = self.id {
            hasher.combine(id)
        } else {
            // we don't care about comparing stations without ids
            hasher.combine("something")
        }
    }
    
//    var hashValue: Int {
//        if let id = id {
//            return id.hashValue
//        } else {
//            return "sameforall".hashValue
//        }
//    }
}
