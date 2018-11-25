//
//  _Lookup.swift
//  trapr
//
//  Created by Andrew Tokeley on 25/10/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

class _Lookup: DocumentSerializable {
    
    /**
     Human readable unique id for the lookup. e.g. POS
     */
    var id: String?
    var name: String
    var order: Int
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "order": order
        ]
    }

    init(id: String, name: String, order: Int) {
        self.id = id
        self.name = name
        self.order = order
    }
    
    required init?(dictionary: [String : Any]) {
        
        guard let name = dictionary["name"] as? String,
            let order = dictionary["order"] as? Int
            else { return nil }
        
        self.name = name
        self.order = order
    }

}

