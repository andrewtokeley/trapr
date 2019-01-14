//
//  HomePresenter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit
import Viperit
import MessageUI

enum visitRecordMenuItem: String {
    case sendReport = "Send report..."
    case viewMap = "Show map"
    case addStation = "Add station..."
    case addTrap = "Add trap..."
    case archiveTrap = "Remove trap..."
    case removeStation = "Remove station..."
    case deleteAllVisits = "Delete all visits..."
}

// MARK: - VisitPresenter Class
final class VisitPresenter: Presenter {
    
    fileprivate var settings: Settings?
    fileprivate var delegate: VisitDelegate?
    
    fileprivate var visitSummary: _VisitSummary!
    fileprivate var currentVisit: _Visit?
    
    fileprivate var trapsToDisplay = [_TrapType]()
    fileprivate var unusedTrapTypes = [_TrapType]()

    fileprivate var allTypeTypes = [_TrapType]()
    
//    fileprivate var trapsToDisplay : [_TrapType] {
//        let active = self.currentStation.trapTypes.filter( { $0.active } )
//        let activeTrapTypeIds = active.map({ $0.trapTpyeId })
//        return allTypeTypes.filter({ activeTrapTypeIds.contains($0.id!) })
//    }
//
//    fileprivate var unusedTrapTypes : [_TrapType] {
//        let inActive = self.currentStation.trapTypes.filter { !$0.active }
//
//        // want to filter all TrapTypes to remove the ones marked as inactive on the station.
//        return self.allTypeTypes.filter ( { (trapType) in
//            // return true if the trapType isn't in the inActive list
//            !inActive.contains { $0.trapTpyeId == trapType.id! }
//        })
//    }
    
    fileprivate var currentStation: _Station {
        return self.visitSummary.stationsOnRoute[stationIndex]
    }
    
    fileprivate var currentTrapTypeId: String?
    
    fileprivate var trapTypeIndex: Int = 0
    fileprivate var currentTrap: _TrapType? {
        
        if trapsToDisplay.count == 0 {
            return nil
        }
        
        // shouldn't need this check but just in case
        if trapTypeIndex >= trapsToDisplay.count {
            trapTypeIndex = 0
        }
        
        return trapsToDisplay[trapTypeIndex]
    }
    
    /**
     Determines how many times to repeat the stations in the carousel.
     
     - parameters:
        - stations: the stations that will be presented.
     
     - returns:
     1 if the number of stations is less than or equal to 3, otherwise 4.
     */
    fileprivate func repeatCount(_ stations: [_Station]) -> Int {
        return stations.count <= 3 ? 1 : 4
    }
    
    /**
     Determines which repeated station group should be displayed first. This is typically the "middle" group of repeated stations.
     
     - parameters:
        - stations: the stations that will be presented.
     
     - returns:
     1 if the number of stations is less than or equal to 3, otherwise 2.
     */
    fileprivate func repeatCountStartGroup(_ stations: [_Station]) -> Int {
        return stations.count <= 3 ? 1 : 2
    }
    
    fileprivate var stationIndex = 0
    
    override func setupView(data: Any) {
        if let setupData = data as? VisitSetup {
            
            visitSummary = setupData.visitSummary
            stationIndex = 0
            trapTypeIndex = 0
            
            
            // set title
            self.updateTitle()
            
            // get any additional initial data required to render view etc
            self.interactor.retrieveInitialState()
            
            // populate stations
            let stations = self.visitSummary.stationsOnRoute
            
            if stations.count > 0 {
                // make sure the presenter knows which traps will be displayed
                self.interactor.retrieveTrapsToDisplay(route: self.visitSummary.route!, station: stations[self.stationIndex], date: self.visitSummary.dateOfVisit) { (trapTypes) in
                        self.trapsToDisplay = trapTypes
                    
                        self.view.setStations(stations: stations, current: stations[self.stationIndex], repeatCount: self.repeatCount(stations))
                        self.view.updateCurrentStation(index: self.stationIndex, repeatedGroup: self.repeatCountStartGroup(stations))
                    
                        self.router.addVisitLogToView()
                }
            }
        }
    }
    
    //MARK: - Menu actions
    
    func menuEditRoute() {
        // TODO: should we store _Route on VisitSummary?
//        let setupData = TraplineSelectSetupData()
//        setupData.delegate = self
//        setupData.route = self.visitSummary.route
//        router.showEditRoute(setupData: setupData)
    }
    
    func menuDeleteAllVisits() {
        
        interactor.deleteAllVisits(routeId: self.visitSummary.routeId, date: self.visitSummary.dateOfVisit)
        
        // grab a new visit for this day - it will be marked as new so the VisitLog will
        if let trapTypeId = self.currentTrap?.id, let stationId = self.currentStation.id {
            interactor.retrieveVisit(date: visitSummary.dateOfVisit, routeId: self.visitSummary.routeId, stationId: stationId, trapTypeId: trapTypeId)
        }
    }
    
    func menuSendToHandler() {
       
        if let route = visitSummary.route {
            interactor.retrieveHtmlForVisit(date: visitSummary.dateOfVisit, route: route) { (recipient, html) in
                if let routeName = self.visitSummary.route?.name {
                    self.view.showVisitEmail(subject: "Data for \(routeName)", html: html, recipient: recipient)
                }
            }
        }
    }
    
    func menuShowMap() {
            // TODO
//        let stations = ServiceFactory.sharedInstance.stationService.getAll()
//        router.showMap(stations: stations, highlightedStations: self.visitSummary.stationsOnRoute)
    }
    
    //MARK: - Helpers

    func updateTitle() {
        // TODO: put route name on visitSummary
        if let title = self.visitSummary.route?.name {
            let subTitle = self.visitSummary.dateOfVisit.toString(format: Styles.DATE_FORMAT_LONG)
            view.setTitle(title: title, subTitle: subTitle)
        }
    }
    
}

// MARK: - VisitPresenter API
extension VisitPresenter: DatePickerDelegate {

    func datePicker(_ datePicker: DatePickerViewApi, textFor element: DatePickerElement) -> String {
        if element == .title {
            return "Visit Date"
        }
        return element.defaultTextValue
    }
    
    func displayMode(_ datePicker: DatePickerViewApi) -> UIDatePickerMode {
        return UIDatePickerMode.date
    }
    
    func datePicker(_ datePicker: DatePickerViewApi, didSelectDate date: Date) {
        
        // update all the visit records to the new date (but keep the times)
        interactor.updateVisitDates(currentDate: visitSummary.dateOfVisit, routeId: visitSummary.routeId, newDate: date)
        
        visitSummary.dateOfVisit = date
        updateTitle()
        
        // re-fetch the visit for this date
        //interactor.retrieveVisit(date: visitSummary.dateOfVisit, route: visitSummary.route, trap: self.currentTrap)
    }
}


// MARK: - StationSelectDelegate
extension VisitPresenter: StationSelectDelegate {
    
    func newStationsSelected(stations: [_Station]) {
        
        // TODO - this is used for jumping to a selected station - haven't wired up yet from Visit module
        // should only be a single station
//        if let station = stations.first {
//            if let index = visitSummary?.route?.stations.index(where: { $0.longCode == station.longCode }) {
//                stationIndex = index
//
//                view.updateCurrentStation(index: index, repeatedGroup: self.repeatCountStartGroup(stations))
//            }
//        }
    }
}

// MARK: - VisitPresenter API
extension VisitPresenter: VisitPresenterApi {
    
    func didUpdateRoute2(route: _Route, selectedIndex: Int) {
        //self.visitSummary.route = route
        
        // update the navigation strip
        let stations = self.visitSummary.stationsOnRoute
        self.stationIndex = selectedIndex
        
        view.setStations(stations: stations, current: stations[stationIndex], repeatCount: self.repeatCount(stations))
        view.updateCurrentStation(index: stationIndex, repeatedGroup: self.repeatCountStartGroup(stations))
    }
    
    func didSelectToRemoveTrap(trapType: _TrapType) {
        
        _view.presentConfirmation(title: "Remove Trap", message: "Are you sure you want to remove this trap from the station?", response: {
            result in
                if result {
                    self.interactor.deleteOrArchiveTrap(station: self.currentStation, trapTypeId: trapType.id!)
                    
                    // refresh UI and select the same trapIndex if valid, otherwise the one befo
                    self.didSelectStation(index: self.stationIndex, trapIndex: self.trapTypeIndex > 0 ? self.trapTypeIndex - 1 : 0)
                }
        })

    }
    
    func didSelectToAddTrap(trapType: _TrapType) {
        
        interactor.addOrRestoreTrapToStation(station: self.currentStation, trapTypeId: trapType.id!)
        
        // refresh UI and select the last trap (we are assuming this is where the new trap will be added)
        didSelectStation(index: self.stationIndex, trapIndex: trapTypeIndex + 1)
    }

    /// Deprecating
    func didSendEmailSuccessfully() {
        // create a sync record
        // NOTE: we can't know if someone has changed the recipient so we're just assuming it's what's in settings for now
//        let visitSync = VisitSync(visitSummary: self.visitSummary, syncDateTime: Date(), sentTo: self.settings?.emailVisitsRecipient)
//
//        interactor.addVisitSync(visitSync: visitSync)
    }
    
    func visitLogDidScroll(contentOffsetY: CGFloat) {
        // tell the view to move!
    }
    
    func setVisitDelegate(delegate: VisitDelegate) {
        self.delegate = delegate
    }
    func didSelectInfoButton() {
        _view.presentConfirmation(response: nil)
    }
    
    func didSelectMenuButton() {
        
        // can send on if there's at least one visit
        
        self.interactor.numberOfVisits(routeId: visitSummary.routeId!, date: visitSummary.dateOfVisit) { (count) in
         
            let options = [
                OptionItem(title: visitRecordMenuItem.sendReport.rawValue, isEnabled: count > 0),
                OptionItem(title: visitRecordMenuItem.viewMap.rawValue, isEnabled: true),
                OptionItem(title: visitRecordMenuItem.addTrap.rawValue, isEnabled: self.unusedTrapTypes.count > 0),
                OptionItem(title: visitRecordMenuItem.archiveTrap.rawValue, isEnabled: self.currentVisit == nil),
                OptionItem(title: visitRecordMenuItem.addStation.rawValue, isEnabled: true, isDestructive: false),
                OptionItem(title: visitRecordMenuItem.removeStation.rawValue, isEnabled: true, isDestructive: false),
                OptionItem(title: visitRecordMenuItem.deleteAllVisits.rawValue, isEnabled: count > 0, isDestructive: true)
            ]
            self.view.displayMenuOptions(options: options)
        }
    }
    
    func didSelectMenuItem(title: String) {
        if title == visitRecordMenuItem.sendReport.rawValue {
            self.menuSendToHandler()
        }
        if title == visitRecordMenuItem.viewMap.rawValue {
            self.menuShowMap()
        }
        if title == visitRecordMenuItem.deleteAllVisits.rawValue {
            
            interactor.numberOfVisits(routeId: visitSummary.routeId!, date: visitSummary.dateOfVisit) { (count) in
                self.view.showConfirmation(title: "Delete All \(count) Visits", message: "Are you sure",
                    yes: {
                        self.menuDeleteAllVisits()
                    },
                    no: {
                        // do nothing
                    })
            }
        }
        if title == visitRecordMenuItem.addStation.rawValue {
            didSelectAddStation()
        }
        
        if title == visitRecordMenuItem.removeStation.rawValue {
            view.confirmDeleteStationMethod()
        }
        
        if title == visitRecordMenuItem.addTrap.rawValue {
            let setupData = ListPickerSetupData()
            setupData.delegate = self
            setupData.embedInNavController = false
            self.router.showListPicker(setupData: setupData)
        }
        
        if title == visitRecordMenuItem.archiveTrap.rawValue {
            if let trap = self.currentTrap {
                self.didSelectToRemoveTrap(trapType: trap)
            }
        }
    }
    
    func didSelectDate() {
        //view.showDatePicker(date: self.visitSummary!.dateOfVisit)
        let setupData = DatePickerSetupData()
        setupData.initialDate = visitSummary!.dateOfVisit
        setupData.delegate = self
        
        router.showDatePicker(setupData: setupData)
    }
    
    func didSelectTrap(index: Int) {
        print("presenter: didSelectTrap")
        trapTypeIndex = index
        if let trapTypeId = self.currentTrap?.id, let stationId = self.currentStation.id {
            interactor.retrieveVisit(date: visitSummary.dateOfVisit, routeId: visitSummary.routeId, stationId: stationId, trapTypeId: trapTypeId)
        }
    }
    
    func didSelectAddStation() {
        let data = StationSearchSetupData()
        data.delegate = self
        // TODO - currently can't navigate from visitSummary to Region
        
        //data.region = self.visitSummary.stationsOnRoute.first?.tr
        
        router.showAddStation(setupData: data)
    }
    
    func didSelectRemoveStation() {
        
        interactor.removeStationFromRoute(route: self.visitSummary.route!, stationId: self.currentStation.id!)
    }
    
    func didSelectDeleteStation() {
        interactor.deleteStation(route: self.visitSummary.route!, stationId: self.currentStation.id!)
    }
    
    func didFetchInitialState(trapTypes: [_TrapType]) {
        self.allTypeTypes = trapTypes
    }
    
    func didFetchVisit(visit: _Visit) {
        
        // hold a reference to this visit - needed if user requests to delete it
        self.currentVisit = visit
        
        // isNew will be true if this is
        delegate?.didChangeVisit(visit: visit)
    }
    
    func didFindNoVisit() {
        self.currentVisit = nil
        delegate?.didChangeVisit(visit: nil)
    }
    
    func didSelectStation(index: Int, trapIndex: Int = 0) {
        self.stationIndex = index
        print("presenter: didSelectStation")
        // note we don't always want to return all the traps of the station, only those not-archived or archived but with a visit recorded
        interactor.retrieveTrapsToDisplay(route: self.visitSummary.route!, station: self.currentStation, date: self.visitSummary.dateOfVisit) { (trapTypes) in
            
            print("interactor: retrieveTrapsToDisplay:complete")
            self.trapsToDisplay = trapTypes
            self.view.setTraps(trapTypes: self.trapsToDisplay)
            
            // define the trapTypes that haven't been used yet - used if we add new TrapTypes to the Station
            self.unusedTrapTypes = self.interactor.getUnusedTrapTypes(allTrapTypes: self.allTypeTypes, station: self.currentStation)
            self.view.selectTrap(index: trapIndex)
        }
    }

//    func didAddStation(station: Station) {
//        
//    }
}

extension VisitPresenter: StationSearchDelegate {
    func stationSearch(_ stationSearch: StationSearchView, didSelectStation station: _Station) {
        
        if let route = self.visitSummary.route {
        
            // insert station after the current station
            if stationIndex == route.stationIds.count - 1 {
                // add to end
                interactor.addStation(route: route, station: station)
            } else {
                // insert after the current index, i.e. before the next one!
                let index = stationIndex + 1
                
                interactor.insertStation(routeId: route.id!, stationId: station.id!, at: index)
            }
        }
    }
}

extension VisitPresenter: VisitLogDelegate {
    
    func didSelectToRemoveVisit() {
        if let visit = self.currentVisit {
            interactor.deleteVisit(visit: visit)
            delegate?.didChangeVisit(visit: nil)
            self.currentVisit = nil
        }
    }
    
    func didSelectToCreateNewVisit() {

        // get the current time on the same day as the visitSummary
        if let date = self.visitSummary.dateOfVisit.setTimeToNow() {
            if let trap = self.currentTrap {
                let newVisit = _Visit(date: date, routeId: self.visitSummary.routeId, traplineId: self.currentStation.traplineId!, stationId: self.currentStation.id!, trapTypeId: trap.id!)
                interactor.addVisit(visit: newVisit)
            }
        }
    }
}

//MARK: - TraplineSelectDelegate
extension VisitPresenter: ListPickerDelegate {
    
    func listPickerTitle(_ listPicker: ListPickerView) -> String {
        return "Trap"
    }
    
    func listPickerNumberOfRows(_ listPicker: ListPickerView) -> Int {
        return self.unusedTrapTypes.count
    }
    
    func listPickerHeaderText(_ listPicker: ListPickerView) -> String {
        return "Trap"
    }
    
    func listPicker(_ listPicker: ListPickerView, itemTextAt index: Int) -> String {
        return self.unusedTrapTypes[index].name
    }

    func listPicker(_ listPicker: ListPickerView, imageViewAt index: Int) -> UIImage? {
        if let imageName = self.unusedTrapTypes[index].imageName {
            return UIImage(named: imageName)
        }
        return nil
    }
    
    func listPicker(_ listPicker: ListPickerView, didSelectItemAt index: Int) {
        didSelectToAddTrap(trapType: self.unusedTrapTypes[index])
    }
}

//MARK: - TraplineSelectDelegate
extension VisitPresenter: TraplineSelectDelegate {
    
    func didCreateRoute(route: _Route) {
        // may not use
    }
    
    func didUpdateRoute(route: _Route) {
        // decide what to do with Visits no longer on route
        
        self.visitSummary.route = route
        
        // update the navigation strip
        let stations = self.visitSummary.stationsOnRoute
        
        stationIndex = stationIndex >= stations.count ? stations.count - 1 : stationIndex
        view.setStations(stations: stations, current:  stations[stationIndex], repeatCount: self.repeatCount(stations))
        view.updateCurrentStation(index: stationIndex, repeatedGroup: self.repeatCountStartGroup(stations))
    }
}

// MARK: - Visit Viper Components
private extension VisitPresenter {
    var view: VisitViewApi {
        return _view as! VisitViewApi
    }
    var interactor: VisitInteractorApi {
        return _interactor as! VisitInteractorApi
    }
    var router: VisitRouterApi {
        return _router as! VisitRouterApi
    }
}
