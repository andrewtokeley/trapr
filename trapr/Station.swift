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
    A unique code for the station. 
 
    The station code's alphanumeric sort order determines the order in which the stations are located along a trapline.
    */
    dynamic var code: String?
    
    var longCode: String {
        return trapline!.code!.appending(self.code!)
    }
    
    /**
    The trapline in which the station is located
    */
    dynamic var trapline: Trapline?
    
    /**
    The traps located at this station
    */
    let traps = List<Trap>()
    
    convenience init(code: String, trapline: Trapline) {
        self.init()
        
        self.code = code
        self.trapline = trapline
    }
    
    func addTrap(type: TrapType) -> Trap {
        let trap = Trap()
        trap.type = type
        trap.station = self
        traps.append(trap)
        return trap
    }
}
