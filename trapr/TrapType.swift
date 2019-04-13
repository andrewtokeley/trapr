//
//  TrapType.swift
//  trapr
//
//  Created by Andrew Tokeley on 26/10/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

enum _KillMethod: String {
    case poison = "POISON"
    case direct = "DIRECT"
    case unknown = "UNKNOWN" // only used if user is recording a visit against a traptype that isn't in the system
}

enum TrapTypeCode: String {
    case possumMaster = "POS"
    case pellibait = "PEL"
    case doc200 = "DOC200"
    case timms = "TIMM"
    case other = "OTHER"
 
    var walkTheLineName: String {
        switch self {
        case .possumMaster: return "Possum Master"
        case .pellibait: return "Pelifeed"
        case .doc200: return "DOC 200 Single"
        case .timms: return "Timms Cat Trap"
        case .other: return "Other"
        }
    }
}

enum TrapTypeFields: String {
    case defaultLure = "defaultLure"
    case availableLures = "availableLures"
    case catchableSpecies = "catchableSpecies"
    case killMethod = "killMethod"
    case imageName = "imageName"
}

class TrapType: Lookup {
    
    var killMethod: _KillMethod = _KillMethod.direct
    var defaultLure: String?
    var availableLures: [String]?
    var catchableSpecies: [String]?
    var imageName: String?
    
    override var dictionary: [String : Any] {
        var result = super.dictionary
        
        result[TrapTypeFields.killMethod.rawValue] = self.killMethod.rawValue
        
        if let _ = self.imageName {
            result[TrapTypeFields.imageName.rawValue] = self.imageName
        }
        if let _ = self.defaultLure {
            result[TrapTypeFields.defaultLure.rawValue] = self.defaultLure
        }
        if let _ = self.availableLures {
            result[TrapTypeFields.availableLures.rawValue] = self.availableLures
        }
        if let _ = self.catchableSpecies {
            result[TrapTypeFields.catchableSpecies.rawValue] = self.catchableSpecies
        }
        
        return result
    }
    
    override init(id: String, name: String, order: Int) {
        super.init(id: id, name: name, order: order)
        // default image name, even if not defined in store
        self.imageName = "poison"
    }
    
    required init?(dictionary: [String : Any]) {
        
        // load up the standard lookup fields
        super.init(dictionary: dictionary)
        
        // set the other fields
        if let imageName = dictionary[TrapTypeFields.imageName.rawValue] as? String {
            self.imageName = imageName
        }
        if let killMethodId = dictionary[TrapTypeFields.killMethod.rawValue] as? String {
            self.killMethod = _KillMethod(rawValue: killMethodId) ?? _KillMethod.direct
        }
        if let defaultLure = dictionary[TrapTypeFields.defaultLure.rawValue] as? String {
            self.defaultLure = defaultLure
        }
        if let catchableSpecies = dictionary[TrapTypeFields.catchableSpecies.rawValue] as? [String] {
            self.catchableSpecies = catchableSpecies
        }
        if let availableLures = dictionary[TrapTypeFields.availableLures.rawValue] as? [String] {
            self.availableLures = availableLures
        }
    }
}
