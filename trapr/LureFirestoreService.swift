//
//  LureFirestoreService.swift
//  trapr
//
//  Created by Andrew Tokeley on 26/10/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

class LureFirestoreService: LookupFirestoreService<_Lure> {
    
    override func createOrUpdateDefaults(completion: (() -> Void)?) {
        
        let lures = [
            _Lure(id: LureCode.cerealWithWireMesh.rawValue, name: "Cereal in Wire Mesh", order: 1),
            _Lure(id: LureCode.apple.rawValue, name: "Apple", order: 2),
            _Lure(id: LureCode.cinnamon.rawValue, name: "Cinnamom", order: 3),
            _Lure(id: LureCode.plasticLure.rawValue, name: "Plastic Lure", order: 4),
            _Lure(id: LureCode.driedRabbit.rawValue, name: "Dried Rabbit", order: 5),
            _Lure(id: LureCode.egg.rawValue, name: "Egg", order: 6),
            _Lure(id: LureCode.contracBloxPoison.rawValue, name: "Contrac Blox Poison", order: 7),
            _Lure(id: LureCode.contracRodenticidePoison.rawValue, name: "Contrac Rodenticide Poison", order: 8),
            _Lure(id: LureCode.other.rawValue, name: "Other", order: 9)
        ]
        
        self.add(lookups: lures) { (error) in
            // ignore errors for now
            completion?()
        }
        
    }
}
