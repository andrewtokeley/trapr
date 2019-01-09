//
//  CachePrimerServiceInterface.swift
//  trapr_production
//
//  Created by Andrew Tokeley on 20/12/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol CachePrimerServiceInterface {
    func primeCache(progress: ((Double, String) -> Void)?)
    func cachePrimed(completion: ((Bool) -> Void)?)
}
