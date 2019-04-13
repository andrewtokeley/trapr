//
//  _Species.swift
//  trapr
//
//  Created by Andrew Tokeley on 25/10/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

enum SpeciesCode: String {
    case possum = "POS"
    case rat = "RAT"
    case mouse = "MOU"
    case hedgehog = "HED"
    case cat = "CAT"
    case stoat = "STO"
    case other = "OTHR"
    
    var walkTheLineCode: String {
        switch self {
        case .possum: return "P"
        case .rat: return "R"
        case .mouse: return "M"
        case .hedgehog: return "H"
        case .cat: return "C"
        case .stoat: return "S"
        case .other: return "O"
        }
    }
}

class Species: Lookup {
    
}
