//
//  TraplineService.swift
//  trapr
//
//  Created by Andrew Tokeley  on 17/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

class TraplineService: Service, TraplineServiceInterface {

    func add(trapline: Trapline) {
        try! realm.write {
            realm.add(trapline)
        }
    }
    
    func getTraplines() -> Results<Trapline> {
        return realm.objects(Trapline.self)
    }
    
    func getTrapline(code: String) -> Trapline? {
        return realm.objects(Trapline.self).filter({ (trapline) in return trapline.code == code }).first
    }
    
}
