//
//  RegionService.swift
//  trapr
//
//  Created by Andrew Tokeley on 27/05/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

class RegionService: RealmService, RegionServiceInterface {
    
    func add(region: Region) {
        try! realm.write {
            realm.add(region, update: true)
        }
    }
    
    func save(region: Region) {
        
        try! realm.write {
            let _ = realm.create(Route.self, value: region, update: true)
        }
    }
    
    func getRegions() -> [Region]? {
        return Array(realm.objects(Region.self).sorted(byKeyPath: "name"))
    }
}
