//
//  TrapTypeService.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/11/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

class TrapTypeService: LookupService<TrapType> {

    private var lureService: LookupService<Lure> {
        return ServiceFactory.sharedInstance.lureService
    }
    
    override func createOrUpdateDefaults() {
        try! realm.write {
            realm.add(possumMaster(), update:true)
            realm.add(doc200(), update:true)
            realm.add(pelifeed(), update:true)
        }
    }
    
    private func doc200() -> TrapType {
        let trapType = TrapType()
        trapType.code = "D200"
        trapType.name = "DOC200"
        trapType.killMethodRaw = KillMethod.Direct.rawValue
        trapType.defaultLure = lureService.get(.driedRabbit)

        trapType.availableLures.append(lureService.get(.driedRabbit)!)
        trapType.availableLures.append(lureService.get(.egg)!)
        trapType.availableLures.append(lureService.get(.other)!)

        //trapType.imageName = "doc200"
        return trapType
    }
    
    private func possumMaster() -> TrapType {
        let trapType = TrapType()
        trapType.code = "PMA"
        trapType.name = "Possum Master"
        trapType.killMethodRaw = KillMethod.Direct.rawValue
        
        trapType.defaultLure = lureService.get(.cereal)
        trapType.availableLures.append(lureService.get(.cereal)!)
        trapType.availableLures.append(lureService.get(.cerealWithWireMesh)!)
        trapType.availableLures.append(lureService.get(.apple)!)
        trapType.availableLures.append(lureService.get(.cinnamon)!)
        trapType.availableLures.append(lureService.get(.other)!)
        
        trapType.imageName = "possumMaster"
        return trapType
    }
    
    private func pelifeed() -> TrapType {
        let trapType = TrapType()
        trapType.code = "PEL"
        trapType.name = "Pellibait"
        trapType.killMethodRaw = KillMethod.Poison.rawValue
        
        trapType.defaultLure = lureService.get(.contracBloxPoison)
        trapType.availableLures.append(lureService.get(.contracBloxPoison)!)
        trapType.availableLures.append(lureService.get(.contracRodenticidePoison)!)
        trapType.availableLures.append(lureService.get(.other)!)
        trapType.imageName = "pelifeed"
        return trapType
    }
}
