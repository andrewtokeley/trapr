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

class TrapType: LookupObject {
    
    dynamic var killMethodRaw = 0
    dynamic var defaultLure: Lure?
    let availableLures = List<Lure>()
    dynamic var imageName: String?
    
    var killMethod: KillMethod {
        return KillMethod(rawValue: killMethodRaw) ?? .Direct
    }
    
    
}
