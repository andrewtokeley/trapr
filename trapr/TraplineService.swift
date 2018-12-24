//
//  TraplineService.swift
//  trapr
//
//  Created by Andrew Tokeley  on 17/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift
import FirebaseFirestore

enum TraplineServiceError: Error {
    case traplineHasNoRegion
}

class TraplineService: RealmService {
    
}

extension TraplineService: TraplineServiceInterface {
    

    /**
     Not used for Realm
     */
    
    func get(stations: [_Station], completion: (([_Trapline], Error?) -> Void)?) {}
    func get(traplineId: String, completion: ((_Trapline?, Error?) -> Void)?) {}
    
    func extractTraplineReferencesFromStations(stations: [_Station]) -> [String] {
        return [String]()
    }
    func extractTraplineCodesFromStations(stations: [_Station]) -> [String] {
        return [String]()
    }
    //MARK - Helpers
    
    func add(trapline: _Trapline, completion: ((_Trapline?, Error?) -> Void)?) -> String {
        return ""
    }
    
    func deleteAll(completion: ((Error?) -> Void)?) {
        
    }
    
    func addStation(trapline: _Trapline, station: _Station, completion: ((Error?) -> Void)?) {
        
    }
    
    func addTrap(station: _Station, trap: _TrapType, completion: ((Error?) -> Void)?) {
        
    }
    
    func delete(trapline: _Trapline, completion: ((Error?) -> Void)?) {
        
    }
    
    func get(completion: (([_Trapline]) -> Void)?) {
}
    func get(source: FirestoreSource, completion: (([_Trapline]) -> Void)?) {
        
    }
    
    func get(regionId: String, completion: (([_Trapline]) -> Void)?) {
        
    }
    
    func get(regionId: String, traplineCode: String, completion: ((_Trapline?) -> Void)?) {
        
    }
    
    func get(traplineCode: String, completion: ((_Trapline?) -> Void)?) {
        
    }
    
    func getRecentTraplines(completion: (([_Trapline]) -> Void)?) {
        
    }
    
    func add(trapline: Trapline) throws {
        guard trapline.region != nil else {
            // don't let a trapline be saved without defining a region
            throw TraplineServiceError.traplineHasNoRegion
        }
        
        try! realm.write {
            realm.add(trapline, update: true)
        }
    }
    
    func addStation(trapline: Trapline, station: Station) {
        try! realm.write {
            
            // only add the station to the trapline if it's not there already
            if !trapline.stations.contains(where: { $0.code == station.code }) {
                
                // add the station to the trapline
                trapline.stations.append(station)
                
                // save the upated trapline
                realm.add(trapline, update: true)
            } else {
                // nothing to do as this station already exists.
            }
        }
    }
    
    func addTrap(station: Station, trap: Trap) {
        try! realm.write {
            
            var updatingTrap: Trap?
            
            // check if a trap exists of this type
            updatingTrap = station.traps.first(where: { $0.type == trap.type } )
            
            // if not, create a new trap
            if updatingTrap == nil {
                updatingTrap = Trap()
                station.traps.append(updatingTrap!)
            }
            
            // update properties
            updatingTrap!.longitude = trap.longitude
            updatingTrap!.latitude = trap.latitude
            updatingTrap!.notes = trap.notes
            updatingTrap!.type = trap.type
            
            realm.add(station, update: true)
        }
    }
    
    func delete(trapline: Trapline) {
        try! realm.write {
            realm.delete(trapline)
        }
    }
    
    
    func getTraplines() -> [Trapline]? {
        return Array(realm.objects(Trapline.self).sorted(byKeyPath: "code"))
    }
    
    func getTraplines(region: Region) -> [Trapline]? {
        return Array(realm.objects(Trapline.self).filter({ (trapline) in return trapline.region == region }))
    }
    
    /**
     Get references to traplines from an array of stations
     */
    func getTraplines(from stations: [Station]) -> [Trapline] {
        
        var traplines = [Trapline]()
        
        for station in stations {
            if let trapline = station.trapline {
                if traplines.filter({ $0.code == trapline.code }).isEmpty {
                    traplines.append(trapline)
                }
            }
        }
        
        return traplines
    }

    func getTrapline(region: Region, code: String) -> Trapline? {
        return realm.objects(Trapline.self).filter({ (trapline) in return trapline.region == region && trapline.code == code }).first
    }
    
    func getTrapline(code: String) -> Trapline? {
        return realm.objects(Trapline.self).filter({ (trapline) in return trapline.code == code }).first
    }
    
    func getRecentTraplines() -> [Trapline]? {
        let visitsInLast3Months = ServiceFactory.sharedInstance.visitService.getVisitSummaries(recordedBetween: Date().add(0, -3, 0), endDate: Date(), includeHidden: false)
        
        var traplines = [Trapline]()
        for visitSummary in visitsInLast3Months {
            
            for trapline in visitSummary.route.traplines {
                if !traplines.contains(trapline) {
                    traplines.append(trapline)
                }
            }
        }
        
        return traplines
    }
}
