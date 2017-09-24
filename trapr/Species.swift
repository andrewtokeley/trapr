//
//  Species.swift
//  trapr
//
//  Created by Andrew Tokeley  on 13/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

class Species: Object {
    
    dynamic var name: String?
    dynamic var order:Int = 0
}
