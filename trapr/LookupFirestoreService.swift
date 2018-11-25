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
//        let batch = firestore.batch()
//
//        for lookup in lookups {
//            if let id = lookup.id {
//                batch.setData(lookup.dictionary, forDocument: self.firestore.collection(self.lookupCollectionName).document(id), merge: true)
//            }
//        }
//
//        batch.commit { (error) in
//            completion?(error)
//        }
    }


//    func add(lookup: _Lookup, completion: (() -> Void)?) {
//
//        self.add(lookup: lookup) { (error) in
//            // ignore errors
//            completion?()
//        }
//    }
    
    func add(lookup: T, completion: ((Error?) -> Void)?) {
        let _ = super.add(entity: lookup) { (lookup, error) in
            completion?(error)
        }
    }
    
    func get(completion: (([T], Error?) -> Void)?) {
        
        super.get(orderByField: "order") { (lookups, error) in
            completion?(lookups, error)
        }
//        self.firestore.collection(self.lookupCollectionName).getDocuments(completion: {
//        (snapshot, error) in
//
//            var results = [T]()
//
//            if let documents = snapshot?.documents {
//                for document in  documents {
//                    if let result = T(dictionary: document.data()) {
//                        result.id = document.documentID
//                        results.append(result)
//                    }
//                }
//            }
//
//            completion?(results, error)
//        })
    }
    
    /**
     Return all the lookups that match the given codes. If none match the completion closure returns nil
     */
    func get(codes: [String], completion: (([T]?, Error?) -> Void)?) {
        
        // currently no way to do this in a single call, need to get each document and merge
        var results = [T]()
        var lastError: Error?
        var i = 0
        let dispatchGroup = DispatchGroup()
        
        while i < codes.count {
            let code = codes[i]
            i += 1
            dispatchGroup.enter()
            self.get(code: code) { (result, error) in
                
                if let error = error {
                    lastError = error
                } else if let result = result {
                    results.append(result)
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion?(results, lastError)
        }
    }
    
    func get(code: String, completion: ((T?, Error?) -> Void)?) {
        super.get(id: code) { (lookup, error) in
            completion?(lookup, error)
        }
//        let document = self.firestore.collection(self.lookupCollectionName).document(code)
//        document.getDocument(completion: { (snapshot, error) in
//
//            var result:T?
//
//            if let id = snapshot?.documentID, let dictionary = snapshot?.data() {
//                result = T(dictionary: dictionary)
//                result?.id = id
//            }
//
//            completion?(result, error)
//        })
    }
    
    func deleteAll(completion: ((Error?) -> Void)?) {
        super.deleteAllEntities { (error) in
            completion?(error)
        }
    }
}
