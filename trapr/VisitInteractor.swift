//
//  HomeInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift
import Viperit

// MARK: - VisitInteractor Class
final class VisitInteractor: Interactor {

    fileprivate var visits: [Visit]!
}

// MARK: - VisitInteractor API
extension VisitInteractor: VisitInteractorApi {
    
    func getTrapsToDisplay(route: Route, station: Station, date: Date) -> [Trap] {
        return ServiceFactory.sharedInstance.stationService.getActiveOrHistoricTraps(route:route, station:station, date:date)
    }
    
    func deleteOrArchiveTrap(trap: Trap) {
        
        let hasVisits = ServiceFactory.sharedInstance.visitService.hasVisits(trap: trap)
        
        if hasVisits {
            //archive
            ServiceFactory.sharedInstance.trapService.setArchiveState(trap: trap, archive: true)
        } else {
            // delete
            ServiceFactory.sharedInstance.trapService.deleteTrap(trap: trap)
        }
    }
    
    func addOrRestoreTrapToStation(station: Station, trapType: TrapType) {
        
        // find out if the station has an archived trap of this type that we can restore
        if let existingTrap = station.traps.filter({ $0.type == trapType }).first {
            ServiceFactory.sharedInstance.trapService.setArchiveState(trap: existingTrap, archive: false)
        } else {
        
            // create a trap of the correct type
            let trap = Trap()
            trap.type = trapType
            trap.latitude = station.latitude
            trap.longitude = station.longitude
            
            ServiceFactory.sharedInstance.traplineService.addTrap(station: station, trap: trap)
            
        }
    }
    
    func getUnusedTrapTypes(station: Station) -> [TrapType] {
        let allTrapTypes = ServiceFactory.sharedInstance.trapTypeService.getAll()
        let existingTraps = station.traps
        
        let unusedTrapTypes = allTrapTypes.filter( {
            (trapType) in
            return !existingTraps.contains(where: {
                    (trap: Trap) in
                    return trap.type == trapType && !trap.archive }) } )
        
        return unusedTrapTypes
    }
    
    func addVisitSync(visitSync: VisitSync) {
        ServiceFactory.sharedInstance.visitSyncService.add(visitSync: visitSync)
    }
    
    func retrieveVisit(date: Date, route: Route, trap: Trap) {
        
        let visits = Array(ServiceFactory.sharedInstance.visitService.getVisits(recordedOn: date, route: route, trap: trap))
        
        // Find the visit for the given trap
        // NOTE: not supporting multiple visits to the same trap on the same day
        if visits.count > 0 {
            
            // visit exists for this day
            presenter.didFetchVisit(visit: visits[0])
        } else {
            // no visit exists
            presenter.didFindNoVisit()
            
            // create a new Visit, with time now (but date the same as being requested)
//            if let dateNow = date.setTimeToNow() {
//                let newVisit = Visit(date: dateNow, route: route, trap: trap)
//                presenter.didFetchVisit(visit: newVisit)
//            }
        }
    }
    
    func addVisit(visit: Visit) {
        ServiceFactory.sharedInstance.visitService.add(visit: visit)
        presenter.didFetchVisit(visit: visit)
    }
    
    func deleteVisit(visit: Visit) {
        if let visitToDelete = ServiceFactory.sharedInstance.visitService.getById(id: visit.id) {
            ServiceFactory.sharedInstance.visitService.delete(visit: visitToDelete)
        }
    }
    
    func deleteAllVisits(route: Route, date: Date) {
        let visits = ServiceFactory.sharedInstance.visitService.getVisits(recordedOn: date, route: route)
        for visit in visits {
            deleteVisit(visit: visit)
        }
    }
    
    func updateVisitDates(currentDate: Date, route: Route, newDate: Date) {
        let visits = ServiceFactory.sharedInstance.visitService.getVisits(recordedOn: currentDate, route: route)
        for visit in visits {
            ServiceFactory.sharedInstance.visitService.updateDate(visit: visit, date: newDate)
        }
    }
    
}

// MARK: - Interactor Viper Components Api
private extension VisitInteractor {
    var presenter: VisitPresenterApi {
        return _presenter as! VisitPresenterApi
    }
}

