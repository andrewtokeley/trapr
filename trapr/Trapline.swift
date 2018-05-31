//
//  Trapline.swift
//  trapr
//
//  Created by Andrew Tokeley  on 13/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

class Trapline: Object {
    
    /**
     The trapline Primary key is a composite between region.code and trapline code. You should use the configure(region, code) initializer in order for the primary key to be set correctly
     */
    @objc dynamic var id: String?
    override static func primaryKey() -> String? {
        return "id"
    }
    
    /**
     Initialise a new trapline. Calling this method ensures the region and code are set and that the composite primary key is correct.
    */
    convenience init(region: Region, code: String) {
        self.init()
        configure(region: region, code: code)
    }
    
    /**
     This function sets the region, code and importantly the composite primary key for the object.
     You must use this func whenever updating an existing trapline.
     
     Never update the region and code properties directly. Use this method or init(region, code).
     */
    func configure(region: Region, code: String) {
        self.region = region
        self.code = code
        self.id = compositeKey
    }
    
    var compositeKey: String? {
        if let _ = region, let _ = code {
            return "\(region!.code!)-\(code!)"
        } else {
            return UUID().uuidString
        }
    }
    
    @objc dynamic var region: Region? = nil // "East Harbour Regional Park"
    
    @objc dynamic var code: String? = nil // "LW"
    
    @objc dynamic var details: String? = nil // "Lowry Bay track"
    
    let stations = List<Station>() // LW01, LW02...
    
    static func == (left: Trapline, right: Trapline) -> Bool {
        return left.code == right.code
    }
}


