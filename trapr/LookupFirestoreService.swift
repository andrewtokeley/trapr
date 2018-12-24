//
//  LookupFirebaseService.swift
//  trapr
//
//  Created by Andrew Tokeley on 25/10/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import FirebaseFirestore

enum LookupErrors: Error {
    case MustImplementLookupMethod
}

class LookupFirestoreService<T: _Lookup>: FirestoreEntityService<T> {
    
    var lookupCollectionName: String = ""
    
    init(firestore: Firestore, lookupCollectionName: String) {
        super.init(firestore: firestore, collectionName: lookupCollectionName)
    }
    
    func createOrUpdateDefaults(completion: (() -> Void)?) {
        // Must be overriden for specific Type
        completion?()
    }
    
    func add(lookups: [T], completion: ((Error?) -> Void)?) {
        super.add(entities: lookups) { (lookups, error) in
            completion?(error)
        }
    }
    
    func add(lookup: T, completion: ((Error?) -> Void)?) {
        let _ = super.add(entity: lookup) { (lookup, error) in
            completion?(error)
        }
    }
    
    func get(completion: (([T], Error?) -> Void)?) {
        super.get(orderByField: LookupFields.order.rawValue) { (lookups, error) in
            completion?(lookups, error)
        }
    }
    
    func deleteAll(completion: ((Error?) -> Void)?) {
        super.deleteAllEntities { (error) in
            completion?(error)
        }
    }
}
