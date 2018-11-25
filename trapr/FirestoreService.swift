//
//  FirestoreServiceInterface.swift
//  trapr
//
//  Created by Andrew Tokeley on 24/10/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FirestoreEntityServiceError: Error {
    //case entityCreateFailed
    //case cantUpdateEntity
    case entityHasNoId
    case notImplemented
    case deleteFailed
    case addFailed
    case updateFailed
}

class FirestoreEntityService<T: DocumentSerializable>  {
    
    var firestore: Firestore
    private var entityCollectionName: String
    
    var collection: CollectionReference {
        return self.firestore.collection(entityCollectionName)
    }
    
    init(firestore: Firestore, collectionName: String) {
        self.firestore = firestore
        self.entityCollectionName = collectionName
    }
        
    /**
     Adds a new entity to firestore
     
     - parameters:
        - entity: an object that represents a document in firestore that implements DocumentSerializable
        - completion: closure that is called after the add action is complete. The closure will be passed a String? representing the id of the newly added document or an Error? if something went wrong.
     - returns:
     Returns the id of the document that has been created. If the method fails, there may be no document with this id in the database.
     */
    func add(entity: T, completion: ((T?, Error?) -> Void)?) -> String {
        
        // get a reference to where the document will be saved
        let reference = documentReference(entity: entity)
        
        var addedEntity = entity
        
        // in case the entity doesn't already have an id this will ensure it does
        addedEntity.id = reference.documentID

        // Set up to listen for events on the document
        if let block = completion {
            self.notifyOnceOnDocumentChange(reference) { (error) in
                block(addedEntity, error)
            }
        }
        
        // add the data - the listener will know when it's complete
        reference.setData(entity.dictionary)
        
        // immediately return the reference documentid
        return reference.documentID
    }
    
    /**
     Adds a new entity to firestore
     
     - parameters:
        - entities: an array of objects that represent documents in firestore. Each entity must implement DocumentSerializable
        - completion: closure that is called after the add action is complete. The closure will be passed a String? representing the id of the newly added document or an Error? if something went wrong. The block will not be called if offline :-(
     */
    func add(entities: [T], completion: (([T], Error?) -> Void)?) {
        
        let batch = firestore.batch()
        var addedEntities = entities
        
        for entity in addedEntities {
            var addedEntity = entity
            let docRef = documentReference(entity: entity)
            addedEntity.id = docRef.documentID
            batch.setData(addedEntity.dictionary, forDocument:docRef, merge: true)
            addedEntities.append(addedEntity)
        }
        
        batch.commit { (error) in
            completion?(addedEntities, error)
        }
    }
    
    /**
     Updates the document represented by the entity. If the document matching the entity doesn't exist in Firestore, calling this method will NOT add a new document and an error will be returned in the completion closure.
     
     - parameters:
        - entity: the entity to update
        - completion: closure that is called after the save action is complete. The closure will be passed a fully instantiated entity or an Error if the get action failed. The block will still be called if offline.
     
     */
    func update(entity: T, completion: ((Error?) -> Void)?) {
        
        // if the entity doesn't have an id then it's not in Firestore
        guard let _ = entity.id else {
            completion?(FirestoreEntityServiceError.entityHasNoId)
            return
        }
        
        let reference = self.documentReference(entity: entity)
        
        if let block = completion {
            self.notifyOnceOnDocumentChange(reference) { (error) in
                block(error)
            }
        }
        
        reference.updateData(entity.dictionary)
    }
    
    /**
     This will fire if the data is added to the cache or server. When online it's possible the update was a result of another user updating the same entity. Not sure it matters though, the caller of this update will still know an update successfully completed.
     
     */
    func notifyOnceOnDocumentChange(_ reference: DocumentReference, completion: ((Error?) -> Void)?) {
        let dg = DispatchGroup()
        dg.enter()
        
        let listener = reference.addSnapshotListener() { (snapshot, error) in
            completion?(error)
            dg.leave()
        }
        dg.notify(queue: .main) {
            listener.remove()
        }
    }
    
    /**
     Get a specific entity by its id
     
     - parameters:
        - id: the entity id that matches a documentId the collection
        - completion: closure that is called after the get action is complete. The closure will be passed a fully instantiated entity or an Error if the get action failed.
     */
    func get(id: String, completion: ((T?, Error?) -> Void)?) {
        let reference = self.collection.document(id)
        reference.getDocument { (snapshot, error) in
            completion?(self.getEntityFromDocumentSnapshot(snapshot: snapshot), error)
        }
    }
    
    /**
     Retrieves all documents from the Firestore that are located in the entities collection
     
     - parameters:
        - orderByField: the name of the field to order by (ascending)
        - completion: closure that is called after the get action is complete. The closure will be passed a fully instantiated entity or an Error if the get action failed.
     */
    func get(orderByField: String, completion: (([T], Error?) -> Void)?) {
        
        self.collection.order(by: orderByField).getDocuments { (snapshot, error) in
            
            if let error = error {
                completion?([T](), error)
            } else {
                let entities = self.getEntitiesFromQuerySnapshot(snapshot: snapshot)
                completion?(entities, nil)
            }
        }
        
    }
    
    /**
     Retrieves all documents from the Firestore that are located in the entities collection where the field is equal to value supplied.
     
     - parameters:     
        - whereField: the name of the field to compare with
        - isEqualTo:
        - completion: closure that is called after the get action is complete. The closure will be passed a fully instantiated entity or an Error if the get action failed.
     */
    func get(whereField: String, isEqualTo: Any, completion: (([T], Error?) -> Void)?) {
        
        self.collection.whereField(whereField, isEqualTo: isEqualTo).getDocuments { (snapshot, error) in
            
            if let error = error {
                completion?([T](), error)
            } else {
                let entities = self.getEntitiesFromQuerySnapshot(snapshot: snapshot)
                completion?(entities, nil)
            }
        }
        
    }
    
    /**
     Retrieves all documents from the Firestore that are located in the entities collection where the field is greater than the value supplied.
     
     - Parameters:
        - whereField: the name of the field to compare with
        - isGreaterThan: value to compare against
        - completion: closure that is called after the get action is complete. The closure will be passed a fully instantiated entity or an Error if the get action failed.
     */
    func get(whereField: String, isGreaterThan: Any, completion: (([T], Error?) -> Void)?) {
        
        self.collection.whereField(whereField, isGreaterThan: isGreaterThan).getDocuments { (snapshot, error) in
            
            if let error = error {
                completion?([T](), error)
            } else {
                let entities = self.getEntitiesFromQuerySnapshot(snapshot: snapshot)
                completion?(entities, nil)
            }
        }
        
    }
    
    /**
     Retrieves all documents from the Firestore that are located in the entities collection where the field is less than the value supplied.
     
     - parameters:
        - whereField: the name of the field to compare with
        - isLessThan: value to compare against
        - completion: closure that is called after the get action is complete. The closure will be passed a fully instantiated entity or an Error if the get action failed.
     */
    func get(whereField: String, isLessThan: Any, completion: (([T], Error?) -> Void)?) {
        
        self.collection.whereField(whereField, isLessThan: isLessThan).getDocuments { (snapshot, error) in
            
            if let error = error {
                completion?([T](), error)
            } else {
                let entities = self.getEntitiesFromQuerySnapshot(snapshot: snapshot)
                completion?(entities, nil)
            }
        }
    }
    
    /**
     Retrieves all documents from the Firestore that are located in the entities collection where the field is between isGreaterThan and isLessThan the values supplied.
     
     - Parameters:
        - whereField: the name of the field to compare with.
        - isGreaterThan: value to compare against.
        - andLessThan: value to compare against.
        - completion: closure that is called after the get action is complete. The closure will be passed a fully instantiated entity or an Error if the get action failed.
     */
    func get(whereField: String, isGreaterThan: Any, andLessThan: Any, completion: (([T], Error?) -> Void)?) {
        
        self.collection.whereField(whereField, isGreaterThan: isGreaterThan).whereField(whereField, isLessThan: andLessThan).getDocuments { (snapshot, error) in
            
            if let error = error {
                completion?([T](), error)
            } else {
                let entities = self.getEntitiesFromQuerySnapshot(snapshot: snapshot)
                completion?(entities, nil)
            }
        }
    }
    
    /**
     Deletes the document, referenced by the entity, from firestore
     
     - parameters:
        - entityId: the entity id representing the document to delete
        - completion: closure that is called after the delete action is complete. The closure will be passed Error if the delete action failed, otherwise nil.
     */
    func delete(entityId: String, completion: ((Error?) -> Void)?) {
        
        let reference = self.collection.document(entityId)
        
        // Set up to listen for events on the document
        if let block = completion {
            self.notifyOnceOnDocumentChange(reference) { (error) in
                block(error)
            }
        }

        // perform the delete - this will trigger the listener whether online or not
        self.collection.document(entityId).delete()
    }
    
    /**
     Deletes the document, referenced by the entity, from firestore
     
     - parameters:
        - entity: an object that represents a document in firestore that implements DocumentSerializable
        - completion: closure that is called after the delete action is complete. The closure will be passed Error if the delete action failed, otherwise nil. Unlike Firestore API this closure will be called even if you're offline.
     */
    func delete(entity: T, completion: ((Error?) -> Void)?) {
        if let id = entity.id {
            self.delete(entityId: id) { (error) in
                completion?(error)
            }
        } else {
            completion?(FirestoreEntityServiceError.entityHasNoId)
        }
    }
    
    /**
     Deletes all the document, referenced by the entities, from firestore
     
     - parameters:
     - entities: array of enitites that represents a document in firestore that implements DocumentSerializable
     - completion: closure that is called after the delete action is complete. The closure will be passed Error if the delete action failed, otherwise nil. Unlike Firestore API this closure will be called even if you're offline.
     */
    func delete(entities: [T], completion: ((Error?) -> Void)?) {
        var lastError: Error?
        let dispatchGroup = DispatchGroup()
        for entity in entities {
            dispatchGroup.enter()
            self.delete(entity: entity) { (error) in
                lastError = error
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion?(lastError)
        }
    }

    /**
     Deletes all documents from the firestore collection
     
     - parameters:
     - completion: optional closure that is called after the delete action is complete. The closure will be passed Error if the delete action failed, otherwise nil.
     */
    func deleteAllEntities(completion: ((Error?) -> Void)?) {
        
        var lastError: Error?
        let dispatchGroup = DispatchGroup()
        print("deleting all documents from \(self.collection.collectionID)")
        dispatchGroup.enter()
        self.collection.getDocuments { (snapshot, error) in
            lastError = error
            if let snapshot = snapshot {
                print("\(self.collection.collectionID): \(snapshot.count) documents")
                if snapshot.count > 0 {
                    let entities = self.getEntitiesFromQuerySnapshot(snapshot: snapshot)
                    print("\(self.collection.collectionID): \(entities.count) entities")
                    for entity in entities {
                        
                        dispatchGroup.enter()
                        self.delete(entity: entity) { (error) in
                            lastError = error
                            dispatchGroup.leave()
                        }
                    }
                } else {
                    // noththing to delete?
                    lastError = FirestoreEntityServiceError.deleteFailed
                }
            } else {
                lastError = FirestoreEntityServiceError.deleteFailed
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main, execute: {
            completion?(lastError)
        })
    }
    
    //MARK: - Private functionas
    
    /**
     Extract typed entity from a document snapshot.
     
     - parameters:
     - snapshot: a DocumentSnapshot instance as returned from Firestore query
     */
    func getEntityFromDocumentSnapshot(snapshot: DocumentSnapshot?) -> T? {

        var result: T?
        if let snapshot = snapshot, let data = snapshot.data() {
            result = T(dictionary: data)
            result?.id = snapshot.documentID
        }
        return result
    }
    
    /**
     Extract typed entities from the document snapshot.
     
     - parameters:
        - snapshot: a QuerySnapshot instance as returned from Firestore query
     */
    func getEntitiesFromQuerySnapshot(snapshot: QuerySnapshot?) -> [T] {
        
        var results = [T]()
        
        if let documents = snapshot?.documents {
            for document in  documents {
                var result = T(dictionary: document.data())
                result?.id = document.documentID
                if result != nil {
                    results.append(result!)
                }
            }
        }
        return results
    }
    
    /**
     Returns a DocumentReference pointing to where the entity exists, or will exist, in Firestore.
     */
    private func documentReference(entity: T) -> DocumentReference {
        var docRef: DocumentReference
        if let id = entity.id {
            docRef = self.collection.document(id)
        } else {
            docRef = self.collection.document()
        }
        return docRef
    }
}

class FirestoreService  {
    
    var firestore: Firestore
    
    init(firestore: Firestore) {
        self.firestore = firestore
    }
}
