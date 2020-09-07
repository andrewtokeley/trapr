//
//  _Lure.swift
//  trapr
//
//  Created by Andrew Tokeley on 26/10/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

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
    
    var name: String {
        switch self {
        case .cereal: return "Cereal"
        case .cerealWithWireMesh: return "Cereal in Mesh"
        case .apple: return "Apple"
        case .cinnamon: return "Cinnamon"
        case .plasticLure: return "Plastic Lure"
        case .driedRabbit: return "Rabbit"
        case .egg: return "Egg"
        case .contracBloxPoison: return "Contrac Blox"
        case .contracRodenticidePoison: return "Contrac Rodenticide"
        case .other: return "Other"
        }
    }
}

class Lure: Lookup {
    
}
