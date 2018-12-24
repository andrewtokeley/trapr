//
//  _Lookup.swift
//  trapr
//
//  Created by Andrew Tokeley on 25/10/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

enum LookupFields: String {
    case name = "name"
    case order = "order"
}

extension _Lookup: Hashable {
    /// Returns a unique hash value for the lookup instance
    public var hashValue: Int {
        if let id = self.id {
            return id.hashValue
        } else {
            return "something".hashValue
        }
    }
}

class _Lookup: DocumentSerializable {
    
    /**
     Human readable unique id for the lookup. e.g. POS
     */
    var id: String?
    var name: String
    var order: Int
    
    var dictionary: [String: Any] {
        return [
            LookupFields.name.rawValue: name,
            LookupFields.order.rawValue: order
        ]
    }

    init(id: String, name: String, order: Int) {
        self.id = id
        self.name = name
        self.order = order
    }
    
    required init?(dictionary: [String : Any]) {
        
        guard let name = dictionary[LookupFields.name.rawValue] as? String,
            let order = dictionary[LookupFields.order.rawValue] as? Int
            else { return nil }
        
        self.name = name
        self.order = order
    }

}

extension _Lookup: Equatable {
    static func == (left: _Lookup, right: _Lookup) -> Bool {
        return left.id == right.id
    }
}