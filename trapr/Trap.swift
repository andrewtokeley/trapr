//
//  Trap.swift
//  trapr
//
//  Created by Andrew Tokeley  on 13/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

class Trap: Object {
    
    
    // Primary key
    dynamic var id: String = UUID().uuidString
    override static func primaryKey() -> String? {
        return "id"
    }
    
    /**
     Station at which the trap is location. Multiple traps can be located at the same station
    */
    dynamic var station: Station?
    
    /**
     The type of trap. e.g. Possum Master, Pelifeed...
     */
    dynamic var type: TrapType?
    
    /**
    Latitude of the trap location
    */
    dynamic var latitude: Double = 0
    
    /**
    Longitude of the trap location
    */
    dynamic var longitude: Double = 0
    
    var longDescription: String {
        let longCode = self.station?.longCode ?? ""
        let typeName = self.type?.name ?? ""
        return "\(longCode) \(typeName)"
    }
}
