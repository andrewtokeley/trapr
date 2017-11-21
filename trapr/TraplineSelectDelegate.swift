//
//  TraplineSelectDelegate.swift
//  trapr
//
//  Created by Andrew Tokeley  on 7/10/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol TraplineSelectDelegate {
    
    func didCreateRoute(route: Route)
    func didUpdateRoute(route: Route)
}
