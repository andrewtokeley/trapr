//
//  TraplineService.swift
//  trapr
//
//  Created by Andrew Tokeley  on 17/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

class TraplineService: RealmService, TraplineServiceInterface {

    func add(trapline: Trapline) {
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
