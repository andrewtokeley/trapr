//
//  Trapline.swift
//  trapr
//
//  Created by Andrew Tokeley  on 13/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

class Trapline: Object {
    
    dynamic var code: String? = nil // "LW"
    dynamic var details: String? = nil // "Lowry Bay track"
    let stations = List<Station>() // LW01, LW02...
    
    func addStation(code: String) -> Station {
        let station = Station(code: code, trapline: self)
        stations.append(station)
        return station
    }
    
    static func == (left: Trapline, right: Trapline) -> Bool {
        return left.code == right.code
    }
}
