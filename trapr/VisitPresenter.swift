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
    case removeStation = "Remove station..."
    case deleteAllVisits = "Delete all visits..."
}

// MARK: - VisitPresenter Class
final class VisitPresenter: Presenter {
    
    fileprivate var settings: Settings?
    fileprivate var delegate: VisitDelegate?
    
    fileprivate var visitSummary: VisitSummary!
    fileprivate var currentVisit: Visit?
    
    fileprivate var trapsToDisplay = [Trap]()
    fileprivate var unusedTrapTypes = [TrapType]()
    
    fileprivate var currentTrap: Trap? {
        
        if trapsToDisplay.count == 0 {
            return nil
        }
        
        // shouldn't need this check but just in case
        if trapIndex >= trapsToDisplay.count {
            trapIndex = 0
        }
        
        return trapsToDisplay[trapIndex]
    }
    
    fileprivate var currentStation: Station {
        return self.visitSummary.route.stations[stationIndex]
    }
    
    /**
     Determines how many times to repeat the stations in the carousel.
     
     - parameters:
        - stations: the stations that will be presented.
     
     - returns:
     1 if the number of stations is less than or equal to 3, otherwise 4.
     */
    fileprivate func repeatCount(_ stations: [Station]) -> Int {
        return stations.count <= 3 ? 1 : 4
    }
    
    /**
     Determines which repeated station group should be displayed first. This is typically the "middle" group of repeated stations.
     
     - parameters:
        - stations: the stations that will be presented.
     
     - returns:
     1 if the number of stations is less than or equal to 3, otherwise 2.
     */
    fileprivate func repeatCountStartGroup(_ stations: [Station]) -> Int {
        return stations.count <= 3 ? 1 : 2
    }
    
    fileprivate var stationIndex = 0 {
        didSet {
            // whenever the current station changes, refresh the available trapTypes
            self.unusedTrapTypes = interactor.getUnusedTrapTypes(station: currentStation)
        }
    }
    
    fileprivate var trapIndex = 0
    
    open override func setupView(data: Any) {
        if let summary = data as? VisitSummary {
            
            visitSummary = summary
            stationIndex = 0
            trapIndex = 0
            
            // set title
            self.updateTitle()
            
            // populate stations
            let stations = Array(self.visitSummary.route.stations)
            view.setStations(stations: stations, current: stations[self.stationIndex], repeatCount: self.repeatCount(stations))
            view.updateCurrentStation(index: stationIndex, repeatedGroup: self.repeatCountStartGroup(stations))
            
            router.addVisitLogToView()
        }
    }
    
    //MARK: - Menu actions
    
    func menuEditRoute() {
        let setupData = TraplineSelectSetupData()
        setupData.delegate = self
        setupData.route = self.visitSummary.route
        router.showEditRoute(setupData: setupData)
    }
    
    func menuDeleteAllVisits() {

        interactor.deleteAllVisits(route: self.visitSummary.route, date: self.visitSummary.dateOfVisit)
        
        // grab a new visit for this day - it will be marked as new so the VisitLog will
        if let trap = self.currentTrap {
            interactor.retrieveVisit(date: visitSummary.dateOfVisit, route: self.visitSummary.route, trap: trap)
        }
    }
    
    func menuSendToHandler() {
        self.settings = ServiceFactory.sharedInstance.settingsService.getSettings()
        view.showVisitEmail(visitSummary: self.visitSummary, recipient: self.settings!.emailVisitsRecipient)
    }
    
    func menuShowMap() {
        
        let stations = ServiceFactory.sharedInstance.stationService.getAll()
        router.showMap(stations: stations, highlightedStations: Array(self.visitSummary.route.stations))
    }
    
    //MARK: - Helpers

    func updateTitle() {
        if let title = self.visitSummary.route.name {
            let subTitle = self.visitSummary.dateOfVisit.toString(from: Styles.DATE_FORMAT_LONG)
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
        interactor.updateVisitDates(currentDate: visitSummary.dateOfVisit, route: visitSummary.route, newDate: date)
        
        visitSummary.dateOfVisit = date
        updateTitle()
        
        // re-fetch the visit for this date
        //interactor.retrieveVisit(date: visitSummary.dateOfVisit, route: visitSummary.route, trap: self.currentTrap)
    }
}


// MARK: - StationSelectDelegate
extension VisitPresenter: StationSelectDelegate {
    
    func newStationsSelected(stations: [Station]) {
        
        // TODO - this is used for jumping to a selected station - haven't wired up yet from Visit module
        // should only be a single station
        if let station = stations.first {
            if let index = visitSummary?.route?.stations.index(where: { $0.longCode == station.longCode }) {
                stationIndex = index
                
                view.updateCurrentStation(index: index, repeatedGroup: self.repeatCountStartGroup(stations))
            }
        }
    }
}

// MARK: - VisitPresenter API
extension VisitPresenter: VisitPresenterApi {
    
    func didUpdateRoute2(route: Route, selectedIndex: Int) {
        self.visitSummary.route = route
        
        // update the navigation strip
        let stations = Array(route.stations)
        stationIndex = selectedIndex
        view.setStations(stations: stations, current:  stations[stationIndex], repeatCount: self.repeatCount(stations))
        view.updateCurrentStation(index: stationIndex, repeatedGroup: self.repeatCountStartGroup(stations))
    }
    
    func didSelectToRemoveTrap(trap: Trap) {
        interactor.deleteOrArchiveTrap(trap: trap)
        
        // refresh UI and select the same trapIndex if valid, otherwise the one befo
        didSelectStation(index: self.stationIndex, trapIndex: trapIndex > 0 ? trapIndex - 1 : 0)
    }
    
    func didSelectToAddTrap(trapType: TrapType) {
        interactor.addOrRestoreTrapToStation(station: self.currentStation, trapType: trapType)
        
        // refresh UI and select the last trap (we are assuming this is where the new trap will be added)
        didSelectStation(index: self.stationIndex, trapIndex: trapIndex + 1)
    }
    
    func didSendEmailSuccessfully() {
        // create a sync record
        // NOTE: we can't know if someone has changed the recipient so we're just assuming it's what's in settings for now
        let visitSync = VisitSync(visitSummary: self.visitSummary, syncDateTime: Date(), sentTo: self.settings?.emailVisitsRecipient)
        
        interactor.addVisitSync(visitSync: visitSync)
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
        let hasVisits = ServiceFactory.sharedInstance.visitService.getVisits(recordedOn: self.visitSummary.dateOfVisit, route: self.visitSummary.route).count > 0
        
        let options = [
            OptionItem(title: visitRecordMenuItem.sendReport.rawValue, isEnabled: hasVisits),
            OptionItem(title: visitRecordMenuItem.viewMap.rawValue, isEnabled: true),
            //OptionItem(title: visitRecordMenuItem.addTrap.rawValue, isEnabled: unusedTrapTypes.count > 0),
            //OptionItem(title: visitRecordMenuItem.archiveTrap.rawValue, isEnabled: self.currentVisit == nil),
            OptionItem(title: visitRecordMenuItem.addStation.rawValue, isEnabled: true, isDestructive: false),
            OptionItem(title: visitRecordMenuItem.removeStation.rawValue, isEnabled: true, isDestructive: false),
            OptionItem(title: visitRecordMenuItem.deleteAllVisits.rawValue, isEnabled: hasVisits, isDestructive: true)
            
        ]
        view.displayMenuOptions(options: options)
    }
    
    func didSelectMenuItem(title: String) {
        if title == visitRecordMenuItem.sendReport.rawValue {
            self.menuSendToHandler()
        }
        if title == visitRecordMenuItem.viewMap.rawValue {
            self.menuShowMap()
        }
        if title == visitRecordMenuItem.deleteAllVisits.rawValue {
            
            let count = ServiceFactory.sharedInstance.visitService.getVisits(recordedOn: self.visitSummary.dateOfVisit, route: self.visitSummary.route).count
            
            view.showConfirmation(title: "Delete All \(count) Visits", message: "Are you sure",
                                  yes: {
                                    self.menuDeleteAllVisits()
            },
                                  no: {
                                    // do nothing
            })
            
        }
        if title == visitRecordMenuItem.addStation.rawValue {
            didSelectAddStation()
        }
        
        if title == visitRecordMenuItem.removeStation.rawValue {
            view.confirmDeleteStationMethod()
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
        trapIndex = index
        if let trap = self.currentTrap {
            interactor.retrieveVisit(date: visitSummary.dateOfVisit, route: visitSummary.route, trap: trap)
        }
    }
    
    func didSelectAddStation() {
        let data = StationSearchSetupData()
        data.delegate = self
        data.region = self.visitSummary.route.stations.first?.trapline?.region
        
        router.showAddStation(setupData: data)
    }
    
    func didSelectRemoveStation() {
        interactor.removeStationFromRoute(route: self.visitSummary.route, station: self.currentStation)
    }
    
    func didSelectDeleteStation() {
        interactor.deleteStation(route: self.visitSummary.route, station: self.currentStation)
    }
    
    func didFetchVisit(visit: Visit) {
        
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
        
        // note we don't always want to return all the traps of the station, only those not-archived or archived but with a visit recorded
        self.trapsToDisplay = interactor.getTrapsToDisplay(route: self.visitSummary.route, station: self.currentStation, date: self.visitSummary.dateOfVisit)
        view.setTraps(traps: self.trapsToDisplay)
    
        // define the trapTypes that haven't been used yet - used if we add new TrapTypes to the Station
        self.unusedTrapTypes = interactor.getUnusedTrapTypes(station: self.currentStation)
        
        view.selectTrap(index: trapIndex)
    }

//    func didAddStation(station: Station) {
//        
//    }
}

extension VisitPresenter: StationSearchDelegate {
    func stationSearch(_ stationSearch: StationSearchView, didSelectStation station: Station) {
        
        if let route = self.visitSummary.route {
        
            // insert station after the current station
            if stationIndex == route.stations.count - 1 {
                // add to end
                interactor.addStation(route: route, station: station)
            } else {
                // insert after the current index, i.e. before the next one!
                let index = stationIndex + 1
                interactor.insertStation(route: route, station: station, at: index)
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
                let newVisit = Visit(date: date , route: self.visitSummary.route, trap: trap)
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
        return self.unusedTrapTypes[index].name ?? "-"
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
    
    func didCreateRoute(route: Route) {
        // may not use
    }
    
    func didUpdateRoute(route: Route) {
        // decide what to do with Visits no longer on route
        
        self.visitSummary.route = route
        
        // update the navigation strip
        let stations = Array(route.stations)
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
