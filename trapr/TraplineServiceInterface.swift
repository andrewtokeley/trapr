//
//  TraplineServiceInterface.swift
//  trapr
//
//  Created by Andrew Tokeley  on 17/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

protocol TraplineServiceInterface: RealmServiceInterface {
    
    func add(trapline: Trapline) throws
    func addStation(trapline: Trapline, station: Station)
    func addTrap(station: Station, trap: Trap)
    func delete(trapline: Trapline)
    func getTraplines() -> [Trapline]?
    func getTraplines(region: Region) -> [Trapline]?
    func getTrapline(region: Region, code: String) -> Trapline?
    func getTrapline(code: String) -> Trapline?
    func getRecentTraplines() -> [Trapline]?
    
}
