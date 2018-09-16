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
    @objc dynamic var id: String = UUID().uuidString
    override static func primaryKey() -> String? {
        return "id"
    }
    
    /**
     Station at which the trap is location. Multiple traps can be located at the same station
    */
    //dynamic var station: Station?
    private let stations:LinkingObjects<Station> = LinkingObjects(fromType: Station.self, property: "traps")
    var station:Station? {
        return self.stations.first
    }
    
    /**
     True if the trap has been archived
     */
    @objc dynamic var archive: Bool = false
    
    /**
     The type of trap. e.g. Possum Master, Pelifeed...
     */
    @objc dynamic var type: TrapType?
    
    /**
    Latitude of the trap location
    */
    @objc dynamic var latitude: Double = 0
    
    /**
    Longitude of the trap location
    */
    @objc dynamic var longitude: Double = 0
    
    /**
     Notes about the trap
    */
    @objc dynamic var notes: String?
    
    var longDescription: String {
        let longCode = self.station?.longCode ?? ""
        let typeName = self.type?.name ?? ""
        return "\(longCode) \(typeName)"
    }
}
