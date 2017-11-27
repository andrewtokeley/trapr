//
//  SpeciesService.swift
//  trapr
//
//  Created by Andrew Tokeley  on 3/11/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

enum SpeciesCode: String {
    case possum = "POS"
    case rat = "RAT"
    case mouse = "MOU"
    case hedgehog = "HED"
    case cat = "CAT"
    case other = "OTHR"
}

class SpeciesService: LookupService<Species> {
    
    override func createOrUpdateDefaults() {
        try! realm.write {
            realm.add(Species(code: SpeciesCode.possum.rawValue, name: "Possum", order: 0), update: true)
            realm.add(Species(code: SpeciesCode.rat.rawValue, name: "Rat", order: 1), update: true)
            realm.add(Species(code: SpeciesCode.mouse.rawValue, name: "Mouse", order: 2), update: true)
            realm.add(Species(code: SpeciesCode.hedgehog.rawValue, name: "Hedgehog", order: 3), update: true)
            realm.add(Species(code: SpeciesCode.cat.rawValue, name: "Cat", order: 4), update: true)
            realm.add(Species(code: SpeciesCode.other.rawValue, name: "Other", order: 5), update: true)
        }
    }
}

extension LookupService where T: Species {
    func get(_ code: SpeciesCode) -> T? {
        return get(code: code.rawValue)
    }
}
