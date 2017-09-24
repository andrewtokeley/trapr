//
//  TraplineServiceInterface.swift
//  trapr
//
//  Created by Andrew Tokeley  on 17/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

protocol TraplineServiceInterface {
    
    func add(trapline: Trapline)
    func getTraplines() -> Results<Trapline>
    func getTrapline(code: String) -> Trapline?
    
}
