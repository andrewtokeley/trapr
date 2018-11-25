//
//  DocumentSerializable.swift
//  trapr
//
//  Created by Andrew Tokeley on 19/10/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

/**
 A type that can be initialized from a Firestore document.
 */
protocol DocumentSerializable {
    var id: String? { get set }
    var dictionary: [String: Any] { get }
    
    /**
     Initialise the type from a dictionary of fields, typically retrieved from the database
     */
    init?(dictionary: [String: Any])
}

protocol DocumentSerializableWithId {
    init?(id: String, dictionary: [String: Any])
}
