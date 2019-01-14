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

    fileprivate lazy var visitService = { ServiceFactory.sharedInstance.visitFirestoreService }()
    fileprivate lazy var routeService = { ServiceFactory.sharedInstance.routeFirestoreService }()
    fileprivate lazy var stationService = { ServiceFactory.sharedInstance.stationFirestoreService }()
    fileprivate lazy var  trapTypeService = { ServiceFactory.sharedInstance.trapTypeFirestoreService }()
    fileprivate lazy var htmlService = { ServiceFactory.sharedInstance.htmlService }()
    fileprivate lazy var userSettingsService = { ServiceFactory.sharedInstance.userSettingsService }()
    
    fileprivate var visits: [Visit]!
    
    fileprivate func refreshRoute(routeId: String, selectedIndex: Int) {
        // retrieve the route from the database again (with the new station)
        self.routeService.get(routeId: routeId, completion: { (route, error) in
            if let route = route  {
                self.presenter.didUpdateRoute2(route: route, selectedIndex: selectedIndex)
            }
        })
    }
}

// MARK: - VisitInteractor API
extension VisitInteractor: VisitInteractorApi {
    
    func retrieveHtmlForVisit(date: Date, route: _Route, completion: ((String, String) -> Void)?) {
        self.htmlService.getVisitsAsHtml(recordedOn: date, route: route) { (html) in
            if let html = html {
                self.userSettingsService.get(completion: { (settings, error) in
                    if let recipient = settings?.handlerEmail {
                        completion?(recipient, html)
                    }
                })
            }
        }
    }
    
    func numberOfVisits(routeId: String, date: Date, completion: ((Int) -> Void)?) {
        
        // Super inefficient way to test this!
        var result = 0
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        visitService.get(recordedOn: date, routeId: routeId) { (visits, error) in
            result = visits.count
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion?(result)
        }
    }
    
    func retrieveInitialState() {
        trapTypeService.get { (trapTypes, error) in
            self.presenter.didFetchInitialState(trapTypes: trapTypes)
        }
    }
    
    func removeStationFromRoute(route: _Route, stationId: String) {
        
        if let index = route.stationIds.firstIndex(of: stationId),
            let routeId = route.id {
            routeService.removeStationFromRoute(routeId: routeId, stationId: stationId) { (route, error) in
                if let _ = error {
                    //
                } else {
                    self.refreshRoute(routeId: routeId, selectedIndex: index)
                }
            }
        }
    }
    
    func deleteStation(route: _Route, stationId: String) {
        
        if let index = route.stationIds.firstIndex(of: stationId), let routeId = route.id {
            stationService.delete(stationId: stationId) { (error) in
                if let _ = error {
                    //
                } else {
                    self.refreshRoute(routeId: routeId, selectedIndex: index)
                }
            }
        }
    }
    
    func insertStation(routeId: String, stationId: String, at index: Int) {
        routeService.insertStationToRoute(routeId: routeId, stationId: stationId, at: index) { (route, error) in
            self.refreshRoute(routeId: routeId, selectedIndex: index)
        }
    }
    
    func addStation(route: _Route, station: _Station) {
        if let routeId = route.id, let stationId = station.id {
            routeService.addStationToRoute(routeId: routeId, stationId: stationId) { (updatedRoute, error) in
                //
                self.refreshRoute(routeId: routeId, selectedIndex: route.stationIds.count - 1)
            }
        }
    }
    func retrieveTrapsToDisplay(route: _Route, station: _Station, date: Date, completion: (([_TrapType]) -> Void)?) {
        stationService.getActiveOrHistoricTraps(route: route, station: station, date: date) { (trapTypes) in
            completion?(trapTypes)
        }
    }
    
    func getUnusedTrapTypes(allTrapTypes: [_TrapType], station: _Station) -> [_TrapType] {
        let inActive = station.trapTypes.filter { !$0.active }

        // want to filter all TrapTypes to remove the ones marked as inactive on the station.
        return allTrapTypes.filter ( { (trapType) in
            // return true if the trapType isn't in the inActive list
            !inActive.contains { $0.trapTpyeId == trapType.id! }
        })
    }
    
    func deleteOrArchiveTrap(station: _Station, trapTypeId: String) {
        
        // check if the trap has visits - if it does just archive, otherwise delete
        visitService.hasVisits(stationId: station.id!, trapTypeId: trapTypeId) { (hasVisits, error) in
            
            if hasVisits {
                self.stationService.updateActiveState(station: station, trapTypeId: trapTypeId, active: false, completion: { (station, error) in
                    // let the presenter know
                })
            } else {
                self.stationService.removeTrapType(station: station, trapTypeId: trapTypeId) { (station, error) in
                    // let the presenter know
                }
            }
        }
    }
    
    func addOrRestoreTrapToStation(station: _Station, trapTypeId: String) {
        
        // find out if the station has an archived trap of this type that we can restore
        if let _ = station.trapTypes.filter({ $0.trapTpyeId == trapTypeId }).first {
            self.stationService.updateActiveState(station: station, trapTypeId: trapTypeId, active: true) { (station, error) in
                    // let presenter know
            }
        } else {
        
            // create a trap of the correct type
            self.stationService.addTrapTypeToStation(station: station, trapTypeId: trapTypeId, completion: nil)
        }
    }
    
    func addVisitSync(visitSync: VisitSync) {
        ServiceFactory.sharedInstance.visitSyncService.add(visitSync: visitSync)
    }
    
    func retrieveVisit(date: Date, routeId: String, stationId: String, trapTypeId: String) {
        print("interactor: retrieveVisit")
        
        visitService.get(recordedOn: date, routeId: routeId, stationId: stationId, trapTypeId: trapTypeId) { (visits, error) in
            // Find the visit for the given trap
            // NOTE: not supporting multiple visits to the same trap on the same day
            if visits.count > 0 {
                // visit exists for this day
                self.presenter.didFetchVisit(visit: visits[0])
            } else {
                // no visit exists
                self.presenter.didFindNoVisit()
            }
        }
    }
    
    func addVisit(visit: _Visit) {
        visitService.add(visit: visit, completion: nil)
        presenter.didFetchVisit(visit: visit)
    }
    
    func deleteVisit(visit: _Visit) {
        visitService.delete(visit: visit) { (error) in
            // let someone know at least!
        }
    }
    
    func deleteAllVisits(routeId: String, date: Date) {
        visitService.delete(routeId: routeId, date: date, completion: nil)
    }
    
    func updateVisitDates(currentDate: Date, routeId: String, newDate: Date) {
        visitService.get(recordedOn: currentDate, routeId: routeId) { (visits, error) in
            for visit in visits {
                if let id = visit.id {
                    self.visitService.updateDate(visitId: id, date: newDate, completion: { (error) in
                        //
                    })
                }
            }
        }
    }
    
}

// MARK: - Interactor Viper Components Api
private extension VisitInteractor {
    var presenter: VisitPresenterApi {
        return _presenter as! VisitPresenterApi
    }
}

