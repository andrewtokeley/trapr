//
//  TrapTypeService.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/11/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

enum TrapTypeCode: String {
    case possumMaster = "POS"
    case pellibait = "PEL"
    case doc200 = "DOC200"
    case timms = "TIMM"
    case other = "OTHER"
}

class TrapTypeService: LookupService<TrapType> {

    private var lureService: LookupService<Lure> {
        return ServiceFactory.sharedInstance.lureService
    }
    
    private var speciesService: LookupService<Species> {
        return ServiceFactory.sharedInstance.speciesService
    }
    
    override func createOrUpdateDefaults() {
        try! realm.write {
            realm.add(possumMaster(), update:true)
            realm.add(doc200(), update:true)
            realm.add(pelifeed(), update:true)
            realm.add(timms(), update:true)
        }
    }
    
    private func doc200() -> TrapType {
        let trapType = TrapType()
        trapType.code = TrapTypeCode.doc200.rawValue
        trapType.name = "DOC200"
        trapType.order = 2
        trapType.killMethodRaw = KillMethod.direct.rawValue
        trapType.defaultLure = lureService.get(.driedRabbit)

        trapType.availableLures.append(lureService.get(.driedRabbit)!)
        trapType.availableLures.append(lureService.get(.egg)!)
        trapType.availableLures.append(lureService.get(.other)!)

        trapType.catchableSpecies.append(speciesService.get(.rat)!)
        trapType.catchableSpecies.append(speciesService.get(.mouse)!)
        trapType.catchableSpecies.append(speciesService.get(.stoat)!)
        trapType.catchableSpecies.append(speciesService.get(.hedgehog)!)
        trapType.catchableSpecies.append(speciesService.get(.other)!)
        
        trapType.imageName = "doc200"
        return trapType
    }
    
    private func timms() -> TrapType {
        let trapType = TrapType()
        trapType.code = TrapTypeCode.timms.rawValue
        trapType.name = "Timms Trap"
        trapType.order = 3
        trapType.killMethodRaw = KillMethod.direct.rawValue
        trapType.defaultLure = lureService.get(.cereal)
        
        trapType.availableLures.append(lureService.get(.cereal)!)
        trapType.availableLures.append(lureService.get(.apple)!)
        trapType.availableLures.append(lureService.get(.other)!)
        
        trapType.catchableSpecies.append(speciesService.get(.possum)!)
        trapType.catchableSpecies.append(speciesService.get(.hedgehog)!)
        trapType.catchableSpecies.append(speciesService.get(.cat)!)
        trapType.catchableSpecies.append(speciesService.get(.stoat)!)
        trapType.catchableSpecies.append(speciesService.get(.other)!)
        
        trapType.imageName = "timms"
        return trapType
    }
    private func possumMaster() -> TrapType {
        let trapType = TrapType()
        trapType.code = TrapTypeCode.possumMaster.rawValue
        trapType.name = "Possum Master"
        trapType.order = 1
        trapType.killMethodRaw = KillMethod.direct.rawValue
        
        trapType.defaultLure = lureService.get(.cereal)
        trapType.availableLures.append(lureService.get(.cereal)!)
        trapType.availableLures.append(lureService.get(.cerealWithWireMesh)!)
        trapType.availableLures.append(lureService.get(.apple)!)
        trapType.availableLures.append(lureService.get(.cinnamon)!)
        trapType.availableLures.append(lureService.get(.other)!)
        
        trapType.catchableSpecies.append(speciesService.get(.possum)!)
        trapType.catchableSpecies.append(speciesService.get(.cat)!)
        trapType.catchableSpecies.append(speciesService.get(.other)!)
        
        trapType.imageName = "possumMaster"
        return trapType
    }
    
    private func pelifeed() -> TrapType {
        let trapType = TrapType()
        trapType.code = TrapTypeCode.pellibait.rawValue
        trapType.name = "Pellibait"
        trapType.order = 0
        trapType.killMethodRaw = KillMethod.poison.rawValue
        
        trapType.defaultLure = lureService.get(.contracBloxPoison)
        trapType.availableLures.append(lureService.get(.contracBloxPoison)!)
        trapType.availableLures.append(lureService.get(.contracRodenticidePoison)!)
        trapType.availableLures.append(lureService.get(.other)!)
        
        trapType.imageName = "pelifeed"
        return trapType
    }
    
}

extension LookupService where T: TrapType {
    func get(_ code: TrapTypeCode) -> T? {
        return get(code: code.rawValue)
    }
}
