//
//  LureFirestoreService.swift
//  trapr
//
//  Created by Andrew Tokeley on 26/10/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

class LureFirestoreService: LookupFirestoreService<Lure> {
    
    override func createOrUpdateDefaults(completion: (() -> Void)?) {
        
        let lures = [
            Lure(id: LureCode.cereal.rawValue, name: "Cereal", order: 0),
            Lure(id: LureCode.cerealWithWireMesh.rawValue, name: "Cereal in Wire Mesh", order: 1),
            Lure(id: LureCode.apple.rawValue, name: "Apple", order: 2),
            Lure(id: LureCode.cinnamon.rawValue, name: "Cinnamom", order: 3),
            Lure(id: LureCode.plasticLure.rawValue, name: "Plastic Lure", order: 4),
            Lure(id: LureCode.driedRabbit.rawValue, name: "Dried Rabbit", order: 5),
            Lure(id: LureCode.egg.rawValue, name: "Egg", order: 6),
            Lure(id: LureCode.contracBloxPoison.rawValue, name: "Contrac Blox Poison", order: 7),
            Lure(id: LureCode.contracRodenticidePoison.rawValue, name: "Contrac Rodenticide Poison", order: 8),
            Lure(id: LureCode.other.rawValue, name: "Other", order: 9)
        ]
        
        self.add(lookups: lures) { (error) in
            // ignore errors for now
            completion?()
        }
        
    }
}
