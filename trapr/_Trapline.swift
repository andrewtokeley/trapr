//
//  _Trapline.swift
//  trapr
//
//  Created by Andrew Tokeley on 3/11/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import FirebaseFirestore

enum TraplineFields: String {
    case code = "code"
    case name = "name"
    case regionCode = "region"
    case lastVisited = "lastVisited"
}

class _Trapline: DocumentSerializable {

    /**
     Unique key, across all regions, for the trapline. Can be nil if this is a new Trapline/
     */
    var id: String?
    
    /**
     Trapline code, unique for region, e.g. LW
     */
    var code: String
    
    /**
     Description of the trapline, e.g. Lowry Bay Track
     */
    var details: String
    
    /**
     The code of the Region in which the Trapline exists
     */
    var regionCode: String
    
    /**
     Date and time when the Trapline was last visited. Can be nil if the Trapline has never been visited
     */
    var lastVisited: Date?
    
    //MARK: - DocumentSerializable
    
    var dictionary: [String: Any] {
        
        var result = [String: Any]()
        
        // all these fields will exist
        result[TraplineFields.code.rawValue] = self.code
        result[TraplineFields.name.rawValue] = self.details
        result[TraplineFields.regionCode.rawValue] = self.regionCode
        
        // set non-nil optionals
        if let _ = lastVisited { result[TraplineFields.lastVisited.rawValue] = Timestamp(date: lastVisited!) }
        
        return result
    }
    
    init(code: String, regionCode: String, details: String) {
        self.code = code
        self.regionCode = regionCode
        self.details = details
    }
    
    required init?(dictionary: [String: Any]) {
        
        // check for mandatory fields
        guard
            let code = dictionary[TraplineFields.code.rawValue] as? String,
            let name = dictionary[TraplineFields.name.rawValue] as? String,
            let regionCode = dictionary[TraplineFields.regionCode.rawValue] as? String
        else {
            return nil
        }
        
        self.code = code
        self.details = name
        self.regionCode = regionCode
        
        // set optional if they're in the dictionary
        if let lastVisited = dictionary[TraplineFields.lastVisited.rawValue] as? Timestamp {
            self.lastVisited = lastVisited.dateValue()
        }
    }
    
    
}
