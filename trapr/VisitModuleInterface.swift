//
//  HomeModuleInterface.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol VisitModuleInterface {
    
    var visit: Visit? { get set }
    func viewWillAppear()
}
