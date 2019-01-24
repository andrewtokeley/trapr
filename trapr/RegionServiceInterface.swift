//
//  RegionServiceInterface.swift
//  trapr
//
//  Created by Andrew Tokeley on 27/05/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

protocol RegionServiceInterface {
    
    /**
     Add or update a region to repository. The region will be updated if it is considered to already exist by the region code (primary key)
     
     - parameters:
        - region: the Region to add/update to the repository
     */
    func add(region: Region)
    func save(region: Region)
    /**
     Return all regions
     */
    func getAllRegions() -> [Region]?
}
