//
//  HomeViewInterface.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol VisitViewInterface {
    
    func setTitle(title: String)
    func setStationText(text: String)
    func setTraps(traps: [Trap])
    func enableNavigation(previous: Bool, next: Bool)
    
}
