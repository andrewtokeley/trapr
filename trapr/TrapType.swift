//
//  TrapType.swift
//  trapr
//
//  Created by Andrew Tokeley  on 15/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

enum KillMethod: Int {
    case Poison = 0
    case Direct
}

class TrapType: Object {
    dynamic var name: String? // "Pelifeed", "Possum Master"
    
    dynamic var killMethodRaw = 0
    var killMethod: KillMethod {
        return KillMethod(rawValue: killMethodRaw) ?? .Direct
    }
    
    dynamic var baitDescription: String? // "Muelsi", "Rat Poison", "Egg"...
}
