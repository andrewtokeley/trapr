//
//  TrapTypeFirestoreService.swift
//  trapr
//
//  Created by Andrew Tokeley on 26/10/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

class TrapTypeFirestoreService: LookupFirestoreService<_TrapType> {
    
    override func createOrUpdateDefaults(completion: (() -> Void)?) {
        
        let trapTypes = [
            possumMaster,
            timms,
            doc200,
            pellibait,
            other
        ]
        
        self.add(lookups: trapTypes) { (error) in
            // ignore errors for now
            completion?()
        }
        
    }
    
    /**
     Only used for a visit if the type of trap installed isn't available in Trapr
     */
    private var other: _TrapType {
        let  trap = _TrapType(id: TrapTypeCode.other.rawValue, name: "Other", order: 100)
        trap.killMethod = _KillMethod.unknown
        trap.availableLures = [
            LureCode.other.rawValue
        ]
        trap.catchableSpecies = [
            SpeciesCode.other.rawValue
        ]
        trap.defaultLure = LureCode.other.rawValue
        return trap
    }
    
    private var pellibait: _TrapType {
        let  trap = _TrapType(id: TrapTypeCode.pellibait.rawValue, name: "Pellibait", order: 0)
        trap.killMethod = _KillMethod.poison
        trap.availableLures = [
            LureCode.contracBloxPoison.rawValue,
            LureCode.contracRodenticidePoison.rawValue,
            LureCode.other.rawValue
        ]
        trap.defaultLure = LureCode.contracBloxPoison.rawValue
        return trap
    }
    
    private var doc200: _TrapType {
        let  trap = _TrapType(id: TrapTypeCode.doc200.rawValue, name: "DOC200", order: 2)
        trap.killMethod = _KillMethod.direct
        trap.availableLures = [
            LureCode.driedRabbit.rawValue,
            LureCode.egg.rawValue,
            LureCode.other.rawValue
        ]
        trap.defaultLure = LureCode.driedRabbit.rawValue
        trap.catchableSpecies = [
            SpeciesCode.rat.rawValue,
            SpeciesCode.mouse.rawValue,
            SpeciesCode.stoat.rawValue,
            SpeciesCode.hedgehog.rawValue,
            SpeciesCode.other.rawValue
        ]
        
        return trap
    }
    
    private var possumMaster: _TrapType {
        let  trap = _TrapType(id: TrapTypeCode.possumMaster.rawValue, name: "Possum Master", order: 1)
        trap.killMethod = _KillMethod.direct
        trap.availableLures = [
            LureCode.cereal.rawValue,
            LureCode.cerealWithWireMesh.rawValue,
            LureCode.other.rawValue
        ]
        trap.defaultLure = LureCode.cereal.rawValue
        trap.catchableSpecies = [
            SpeciesCode.possum.rawValue,
            SpeciesCode.cat.rawValue,
            SpeciesCode.other.rawValue
        ]
        
        return trap
    }
    
    private var timms: _TrapType {
        let  trap = _TrapType(id: TrapTypeCode.timms.rawValue, name: "Timms", order: 2)
        trap.killMethod = _KillMethod.direct
        trap.availableLures = [
            LureCode.cereal.rawValue,
            LureCode.driedRabbit.rawValue,
            LureCode.apple.rawValue,
            LureCode.other.rawValue
        ]
        trap.defaultLure = LureCode.driedRabbit.rawValue
        trap.catchableSpecies = [
            SpeciesCode.possum.rawValue,
            SpeciesCode.cat.rawValue,
            SpeciesCode.hedgehog.rawValue,
            SpeciesCode.stoat.rawValue,
            SpeciesCode.other.rawValue
        ]
        
        return trap
    }
}


