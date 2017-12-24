//
//  Station.swift
//  trapr
//
//  Created by Andrew Tokeley  on 18/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

class Station: Object {
    
    /**
     Primary key
    */
    dynamic var id: String = UUID().uuidString
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    /**
    A code, typically a leading zero number, e.g. "01" for the station. Code need only be unique for the trapline they are part of.
     
     The station code's alphanumeric sort order determines the order in which the stations are located along a trapline. So, it's possible to have "01" followed by "01a", but we recommend sticking to numbers, if possible
    */
    dynamic var code: String?
    
    /**
     Read only, fully qualified station code, that is prefixed with the trapline code. e.g. LW01
     */
    var longCode: String {
        return trapline?.code!.appending(self.code!) ?? id
    }
    
    /**
     Typically only used for debugging purposes to return the station's longCode
     */
    override var description: String {
        return longCode
    }
    
    /**
    The trapline in which the station is located
    */
    private let traplines:LinkingObjects<Trapline> = LinkingObjects(fromType: Trapline.self, property: "stations")
    var trapline:Trapline? {
        return self.traplines.first
    }
    
    /**
    The traps located at this station, e.g. Possum Master, Pellibait traps...
    */
    let traps = List<Trap>()
    
    convenience init(code: String) {
        self.init()
        
        self.code = code
    }
    
    func addTrap(type: TrapType) -> Trap {
        let trap = Trap()
        trap.type = type
        //trap.station = self
        traps.append(trap)
        return trap
    }
    
    static func == (left: Station, right: Station) -> Bool {
        return left.code == right.code
    }
    
    
}
