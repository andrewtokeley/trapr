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
    case poison = 0
    case direct
}

class TrapType: LookupObject {
    
    @objc dynamic var killMethodRaw = 0
    var killMethod: KillMethod {
        return KillMethod(rawValue: killMethodRaw) ?? .direct
    }
    
    @objc dynamic var defaultLure: Lure?
    let availableLures = List<Lure>()
    let catchableSpecies = List<Species>()
    @objc dynamic var imageName: String?
    
}
