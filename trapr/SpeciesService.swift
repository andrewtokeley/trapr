//
//  SpeciesService.swift
//  trapr
//
//  Created by Andrew Tokeley  on 3/11/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

class SpeciesService: LookupService<Species> {
    
    override func createDefaults() {
        try! realm.write {
            realm.add(Species(code: "POS", name: "Possum", order: 0), update: true)
            realm.add(Species(code: "RAT", name: "Rat", order: 1), update: true)
            realm.add(Species(code: "MOU", name: "Mouse", order: 2), update: true)
            realm.add(Species(code: "HED", name: "Hedgehog", order: 3), update: true)
        }
    }

}
