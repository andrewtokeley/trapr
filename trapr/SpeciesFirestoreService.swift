//
//  SpeciesFirebaseService.swift
//  trapr
//
//  Created by Andrew Tokeley on 25/10/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

class SpeciesFirestoreService: LookupFirestoreService<_Species> {

    override func createOrUpdateDefaults(completion: (() -> Void)?) {
        
        let species = [
            _Species(id: SpeciesCode.possum.rawValue, name: "Possum", order: 0),
            _Species(id: SpeciesCode.rat.rawValue, name: "Rat", order: 1),
            _Species(id: SpeciesCode.mouse.rawValue, name: "Mouse", order: 2),
            _Species(id: SpeciesCode.hedgehog.rawValue, name: "Hedgehog", order: 3),
            _Species(id: SpeciesCode.stoat.rawValue, name: "Stoat", order: 5),
            _Species(id: SpeciesCode.cat.rawValue, name: "Cat", order: 4),
            _Species(id: SpeciesCode.other.rawValue, name: "Other", order: 6)
        ]
                
        self.add(lookups: species) { (error) in
            // ignore errors for now
            completion?()
        }
        
    }
}

