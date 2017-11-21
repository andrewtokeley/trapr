//
//  LureService.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/11/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

enum LureCode: String {
    case cereal = "CERE"
    case cerealWithWireMesh = "CMSH"
    case apple = "APPL"
    case cinnamon = "CINN"
    case plasticLure = "PLAS"
    case driedRabbit = "RABB"
    case egg = "EGG"
    case contracBloxPoison = "CBLOX"
    case contracRodenticidePoison = "CRODT"
    case other = "OTHR"
}

class LureService: LookupService<Lure> {
    
    override func createOrUpdateDefaults() {
        try! realm.write {
            realm.add(Lure(code: LureCode.cereal.rawValue, name: "Cereal", order: 0), update:true)
            realm.add(Lure(code: LureCode.cerealWithWireMesh.rawValue, name: "Cereal in Wire Mesh", order: 1), update:true)
            realm.add(Lure(code: LureCode.apple.rawValue, name: "Apple", order: 2), update:true)
            realm.add(Lure(code: LureCode.cinnamon.rawValue, name: "Cinnamon", order: 3), update:true)
            realm.add(Lure(code: LureCode.plasticLure.rawValue, name: "Plastic Lure", order: 4), update:true)
            realm.add(Lure(code: LureCode.driedRabbit.rawValue, name: "Dried Rabbit", order: 5), update:true)
            realm.add(Lure(code: LureCode.egg.rawValue, name: "Egg", order: 6), update:true)
            realm.add(Lure(code: LureCode.contracBloxPoison.rawValue, name: "Contrac Blox Poison", order: 7), update:true)
            realm.add(Lure(code: LureCode.contracRodenticidePoison.rawValue, name: "Contrac Rodenticide Poison", order: 8), update:true)
            realm.add(Lure(code: LureCode.other.rawValue, name: "Other", order: 100), update:true)
        }
    }
}

extension LookupService where T: Lure {
    func get(_ code: LureCode) -> T? {
        return get(code: code.rawValue)
    }
}

