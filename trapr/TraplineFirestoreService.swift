//
//  TraplineFirestoreService.swift
//  trapr
//
//  Created by Andrew Tokeley on 24/10/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import FirebaseFirestore

class TraplineFirestoreService: FirestoreEntityService<Trapline> {
    let COLLECTION_ID_TRAPLINES = "traplines"
}

extension TraplineFirestoreService: TraplineServiceInterface {
    
    func get(stations: [Station], completion: (([Trapline], Error?) -> Void)?) {
        
        // get unique traplineIds from stations
        let traplineIds = stations.map { (station) -> String in
            return station.traplineId ?? ""
        }
        let uniqueTraplineIds = Array(Set(traplineIds))
        
        super.get(ids: uniqueTraplineIds) { (traplines, error) in
            completion?(traplines, error)
        }
    }
    
    func get(traplineId: String, completion: ((Trapline?, Error?) -> Void)?) {
        super.get(id: traplineId) { (trapline, error) in
            completion?(trapline, error)
        }
    }
    
    func extractTraplineReferencesFromStations(stations: [Station]) -> [String] {
        var result = [String]()
        
        for station in stations {
            if let id = station.traplineId {
                // check we haven't already added the id
                if result.filter({ $0 == id }).isEmpty {
                    result.append(id)
                }
            }
        }
        return result
    }
    
    func extractTraplineCodesFromStations(stations: [Station]) -> [String] {
        var result = [String]()
        
        for station in stations {
            if let code = station.traplineCode {
                // check we haven't already added the id
                if result.filter({ $0 == code }).isEmpty {
                    result.append(code)
                }
            }
        }
        return result
    }
    
    func add(trapline: Trapline, completion: ((Trapline?, Error?) -> Void)?) -> String {
        return super.add(entity: trapline) { (trapline, error) in
            completion?(trapline, error)
        }
    }
    
//    func addStation(trapline: Trapline, station: Station, completion: ((Error?) -> Void)?) {
//        // feels like this should be in the StationService
//    }
//    
//    func addTrap(station: Station, trap: TrapType, completion: ((Error?) -> Void)?) {
//        // feels like this should be in the StationService
//    }
    
    func delete(trapline: Trapline, completion: ((Error?) -> Void)?) {
        super.delete(entity: trapline) { (error) in
            completion?(error)
        }
    }
    
    func delete(traplineId: String, completion: ((Error?) -> Void)?) {
        super.delete(entityId: traplineId) { (error) in
            completion?(error)
        }
    }
    
    func delete(traplineIds: [String], completion: ((Error?) -> Void)?) {
        super.delete(entityIds: traplineIds) { (error) in
            completion?(error)
        }
    }
    
    func deleteAll(completion: ((Error?) -> Void)?) {
        super.deleteAllEntities(completion: { (error) in
            completion?(error)
        })
    }

    func get(source: FirestoreSource = .cache, completion: (([Trapline]) -> Void)?) {
        super.get(orderByField: TraplineFields.code.rawValue, source: source) { (traplines, error) in
            completion?(traplines)
        }
    }

    func get(completion: (([Trapline]) -> Void)?) {
        self.get(source: .cache, completion: completion)
    }
    
    func get(regionId: String, completion: (([Trapline]) -> Void)?) {
        super.get(whereField: TraplineFields.regionCode.rawValue, isEqualTo: regionId) { (trapline, error) in
            completion?(trapline)
        }
    }
    
    func get(regionId: String, traplineCode: String, completion: ((Trapline?) -> Void)?) {
        firestore.collection(COLLECTION_ID_TRAPLINES).whereField(TraplineFields.code.rawValue, isEqualTo: traplineCode).whereField(TraplineFields.regionCode.rawValue, isEqualTo: regionId).getDocuments { (snapshot, error) in
            
            completion?(super.getEntitiesFromQuerySnapshot(snapshot: snapshot).first)
        }
    }
    
    func getRecentTraplines(completion: (([Trapline]) -> Void)?) {
        firestore.collection(COLLECTION_ID_TRAPLINES).whereField(TraplineFields.lastVisited.rawValue, isGreaterThan: Date().add(0, -3, 0)).whereField(TraplineFields.lastVisited.rawValue, isLessThan: Date()).getDocuments { (snapshot, error) in
            
            completion?(super.getEntitiesFromQuerySnapshot(snapshot: snapshot))
        }
    }
    
//    private func getTraplinesFromSnapshot(snapshot: QuerySnapshot?) -> [Trapline]? {
//        
//        var results = [Trapline]()
//        
//        if let documents = snapshot?.documents {
//            for document in  documents {
//                if let result = Trapline(dictionary: document.data()) {
//                    result.id = document.documentID
//                    results.append(result)
//                }
//            }
//        }
//        
//        return results.count > 0 ? results : nil
//    }
        
}
