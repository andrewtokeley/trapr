//
//  TraplineFirestoreService.swift
//  trapr
//
//  Created by Andrew Tokeley on 24/10/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import FirebaseFirestore

class TraplineFirestoreService: FirestoreEntityService<_Trapline> {
    let COLLECTION_ID_TRAPLINES = "traplines"
}

extension TraplineFirestoreService: TraplineServiceInterface {
    
    func extractTraplineReferencesFromStations(stations: [_Station]) -> [String] {
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
    
    func extractTraplineCodesFromStations(stations: [_Station]) -> [String] {
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
    
    func add(trapline: _Trapline, completion: ((_Trapline?, Error?) -> Void)?) -> String {
        return super.add(entity: trapline) { (trapline, error) in
            completion?(trapline, error)
        }
    }
    
    func addStation(trapline: _Trapline, station: _Station, completion: ((Error?) -> Void)?) {
        // feels like this should be in the StationService
    }
    
    func addTrap(station: _Station, trap: _TrapType, completion: ((Error?) -> Void)?) {
        // feels like this should be in the StationService
    }
    
    func delete(trapline: _Trapline, completion: ((Error?) -> Void)?) {
        super.delete(entity: trapline) { (error) in
            completion?(error)
        }
    }
    
    func deleteAll(completion: ((Error?) -> Void)?) {
        super.deleteAllEntities(completion: { (error) in
            completion?(error)
        })
    }
    
    func get(completion: (([_Trapline]) -> Void)?) {
        super.get(orderByField: "code") { (traplines, error) in
            completion?(traplines)
        }
    }
    
    func get(regionId: String, completion: (([_Trapline]) -> Void)?) {
        super.get(whereField: TraplineFields.regionCode.rawValue, isEqualTo: regionId) { (trapline, error) in
            completion?(trapline)
        }
    }
    
    func get(regionId: String, traplineCode: String, completion: ((_Trapline?) -> Void)?) {
        firestore.collection(COLLECTION_ID_TRAPLINES).whereField(TraplineFields.code.rawValue, isEqualTo: traplineCode).whereField(TraplineFields.regionCode.rawValue, isEqualTo: regionId).getDocuments { (snapshot, error) in
            
            completion?(super.getEntitiesFromQuerySnapshot(snapshot: snapshot).first)
        }
    }
    
    func getRecentTraplines(completion: (([_Trapline]) -> Void)?) {
        firestore.collection(COLLECTION_ID_TRAPLINES).whereField(TraplineFields.lastVisited.rawValue, isGreaterThan: Date().add(0, -3, 0)).whereField(TraplineFields.lastVisited.rawValue, isLessThan: Date()).getDocuments { (snapshot, error) in
            
            completion?(super.getEntitiesFromQuerySnapshot(snapshot: snapshot))
        }
    }
    
//    private func getTraplinesFromSnapshot(snapshot: QuerySnapshot?) -> [_Trapline]? {
//        
//        var results = [_Trapline]()
//        
//        if let documents = snapshot?.documents {
//            for document in  documents {
//                if let result = _Trapline(dictionary: document.data()) {
//                    result.id = document.documentID
//                    results.append(result)
//                }
//            }
//        }
//        
//        return results.count > 0 ? results : nil
//    }
    
    //MARK: - Will be deleted
    
    func add(trapline: Trapline) throws {
        
    }
    
    func addStation(trapline: Trapline, station: Station) {
        
    }
    
    func addTrap(station: Station, trap: Trap) {
        
    }
    
    func delete(trapline: Trapline) {
        
    }
    
    func getTraplines() -> [Trapline]? {
        return nil
    }
    
    func getTraplines(region: Region) -> [Trapline]? {
        return nil
    }
    
    func getTraplines(from stations: [Station]) -> [Trapline]
    {
        return [Trapline]()
    }
    
    func getTrapline(region: Region, code: String) -> Trapline? {
        return nil
    }
    
    func getTrapline(code: String) -> Trapline? {
        return nil
    }
    
    func getRecentTraplines() -> [Trapline]? {
        return nil
    }
    
}
