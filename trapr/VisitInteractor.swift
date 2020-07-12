//
//  HomeInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - VisitInteractor Class
final class VisitInteractor: Interactor {

    fileprivate lazy var visitService = { ServiceFactory.sharedInstance.visitFirestoreService }()
    fileprivate lazy var visitSummaryService = { ServiceFactory.sharedInstance.visitSummaryFirestoreService }()
    fileprivate lazy var routeService = { ServiceFactory.sharedInstance.routeFirestoreService }()
    fileprivate lazy var stationService = { ServiceFactory.sharedInstance.stationFirestoreService }()
    fileprivate lazy var  trapTypeService = { ServiceFactory.sharedInstance.trapTypeFirestoreService }()
    fileprivate lazy var htmlService = { ServiceFactory.sharedInstance.htmlService }()
    fileprivate lazy var userSettingsService = { ServiceFactory.sharedInstance.userSettingsService }()
    fileprivate lazy var excelService = { ServiceFactory.sharedInstance.excelService }()
    
    fileprivate var trapTypes = [TrapType]()
    
    //fileprivate var visits: [Visit]!
    
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
    
    func generateVisitReportFile(date: Date, route: Route, completion: ((Data?, String?, String?, Error?) -> Void)?) {

        // get the VisitSummary
        visitSummaryService.get(date: date, routeId: route.id!) { (visitSummary, error) in
            if let visitSummary = visitSummary {
                
                // create report
                self.excelService.generateVisitReportFile(visitSummary: visitSummary, completion: { (data, mime, error) in
                    
                    var message = "<p>Hi there, you can find the full report of my visit in the attached file..</p>"
                    
                    // add a summary section
                    if visitSummary.totalKills > 0 {
                        message += "<ul>"
                        for kill in visitSummary.totalKillsBySpecies {
                            message += "<li>\(kill.key) - \(kill.value)</li>"
                        }
                        message += "</ul>"
                    }
                    
                    completion?(data, mime, message, error)
                })
                
            } else {
                completion?(nil, nil, nil, FirestoreEntityServiceError.generalError)
            }
        }
        
        
    }
    
    func getRecipientForVisitReport(completion: ((String?) -> Void)?) {
        self.userSettingsService.get(completion: { (settings, error) in
            if let recipient = settings?.handlerEmail {
                completion?(recipient)
            } else {
                completion?(nil)
            }
        })
    }
    
    func retrieveHtmlForVisit(date: Date, route: Route, completion: ((String, String) -> Void)?) {
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
            self.trapTypes = trapTypes
            self.presenter.didFetchInitialState(trapTypes: trapTypes)
        }
    }
    
    func removeStationFromRoute(route: Route, stationId: String) {
        
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
    
    func deleteStation(route: Route, stationId: String) {
        
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
    
    func addStation(route: Route, station: Station) {
        if let routeId = route.id, let stationId = station.id {
            routeService.addStationToRoute(routeId: routeId, stationId: stationId) { (updatedRoute, error) in
                //
                self.refreshRoute(routeId: routeId, selectedIndex: route.stationIds.count - 1)
            }
        }
    }
    func retrieveTrapsToDisplay(route: Route, station: Station, date: Date, completion: (([TrapType]) -> Void)?) {
        stationService.getActiveOrHistoricTraps(route: route, station: station, date: date) { (trapTypes) in
            print("interactOR: \(trapTypes)")
            completion?(trapTypes)
        }
    }
    
    func getUnusedTrapTypes(allTrapTypes: [TrapType], station: Station) -> [TrapType] {
        let inActive = station.trapTypes.filter { !$0.active }

        // want to filter all TrapTypes to remove the ones marked as inactive on the station.
        return allTrapTypes.filter ( { (trapType) in
            // return true if the trapType isn't in the inActive list
            !inActive.contains { $0.trapTpyeId == trapType.id! }
        })
    }
    
    func deleteOrArchiveTrap(station: Station, trapTypeId: String) {
        
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
    
    func addOrRestoreTrapToStation(station: Station, trapTypeId: String) {
        
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
    
//    func addVisitSync(visitSync: VisitSync) {
//        ServiceFactory.sharedInstance.visitSyncService.add(visitSync: visitSync)
//    }
    
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
    
    func addVisit(date: Date, routeId: String, traplineId: String, stationId: String, trapTypeId: String) {
        let newVisit = Visit(date: date, routeId: routeId, traplineId: traplineId, stationId: stationId, trapTypeId: trapTypeId)
        
        // Set some defaults
        // (this logic should be in the service, but then I'd need to return newVisit outside of the closure, since it isn't fired when offline... fixable, but not now, since this is the only place we create Visits)
        let defaultLureId = self.trapTypes.first( where: { $0.id == trapTypeId })?.defaultLure
        newVisit.lureId = defaultLureId
        
        // default status depends on the trapType
        var defaultTrapSetStatusId = TrapSetStatus.stillSet.rawValue
        if let trapType = TrapTypeCode(rawValue: trapTypeId) {
            defaultTrapSetStatusId = TrapSetStatus.defaultForTrapType(type: trapType).rawValue
        }
        newVisit.trapSetStatusId = defaultTrapSetStatusId
        
        newVisit.trapOperatingStatusId = TrapOperatingStatus.open.rawValue
        
        self.visitService.add(visit: newVisit, completion: nil)
        self.presenter.didFetchVisit(visit: newVisit)
    }
    
    func deleteVisit(visit: Visit) {
        visitService.delete(visit: visit) { (error) in
            // let someone know at least!
        }
    }
    
    func deleteAllVisits(routeId: String, date: Date) {
        visitService.delete(routeId: routeId, date: date) { (error) in
        }
    }
    
    func updateVisitDates(currentDate: Date, routeId: String, newDate: Date) {
        visitService.get(recordedOn: currentDate, routeId: routeId) { (visits, error) in
            for visit in visits {
                if let id = visit.id {
                    
                    // only update the date, not the time, portion of the current date
                    if let date = visit.visitDateTime.setDate(newDate.day, newDate.month, newDate.year) {
                        self.visitService.updateDate(visitId: id, date: date, completion: nil)
                    }
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

