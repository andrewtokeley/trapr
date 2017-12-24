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

enum visitRecordMenuItem: String {
    case sendReport = "Send report"
    case deleteVisitRecord = "Delete"
    case viewMap = "View map"
}

// MARK: - VisitPresenter Class
final class VisitPresenter: Presenter {
    
    fileprivate var visitSummary: VisitSummary!
    fileprivate var visitDelegate: VisitDelegate?
    fileprivate var currentVisit: Visit?
    
    fileprivate var currentTrap: Trap {
        return self.visitSummary.route.stations[stationIndex].traps.sorted(byKeyPath: "type.order")[trapIndex]
    }
    
    fileprivate var currentStation: Station {
        return self.visitSummary.route.stations[stationIndex]
    }
    
    fileprivate var stationIndex = 0
    fileprivate var trapIndex = 0
    
    open override func setupView(data: Any) {
        if let summary = data as? VisitSummary {
            
            visitSummary = summary
            stationIndex = 0
            trapIndex = 0
            
            // set title
            self.updateTitle()
            
            // populate stations
            let stations = self.visitSummary.route.stations
            view.setStations(stations: Array(stations), current: stations[self.stationIndex])
            view.updateCurrentStation(index: stationIndex, repeatedGroup: 2)
            
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
    
    func menuDeleteVisit() {
        if let visit = self.currentVisit {
            interactor.deleteVisit(visit: visit)
        }
        
        // grab a new visit for this day - it will be marked as new so the VisitLog will
        interactor.retrieveVisit(date: visitSummary.dateOfVisit, route: self.visitSummary.route, trap: self.currentTrap)
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
        
        visitSummary.dateOfVisit = date
        updateTitle()
        
        // re-fetch the visit for this date
        interactor.retrieveVisit(date: visitSummary.dateOfVisit, route: visitSummary.route, trap: self.currentTrap)
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
                
                view.updateCurrentStation(index: index, repeatedGroup: 2)
            }
        }
    }
}

// MARK: - VisitPresenter API
extension VisitPresenter: VisitPresenterApi {
    
    func visitLogDidScroll(contentOffsetY: CGFloat) {
        // tell the view to move!
    }
    
    func setVisitDelegate(delegate: VisitDelegate) {
        self.visitDelegate = delegate
    }
    
    func didSelectMenuButton() {
        
        let deleteTitle = "\(visitRecordMenuItem.deleteVisitRecord.rawValue) \(self.currentTrap.longDescription) record"
        
        let options = [
            OptionItem(title: visitRecordMenuItem.sendReport.rawValue, isEnabled: true),
            OptionItem(title: visitRecordMenuItem.viewMap.rawValue, isEnabled: true),
            OptionItem(title: deleteTitle, isEnabled: true)
        ]
        view.displayMenuOptions(options: options)
    }
    
    func didSelectMenuItem(title: String) {
        if title.contains(visitRecordMenuItem.sendReport.rawValue) {
            //self.sendReport()
        }
        if title.contains(visitRecordMenuItem.viewMap.rawValue) {
            //self.viewMap()
        }
        if title.contains(visitRecordMenuItem.deleteVisitRecord.rawValue) {
            self.menuDeleteVisit()
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
        interactor.retrieveVisit(date: visitSummary.dateOfVisit, route: visitSummary.route, trap: self.currentTrap)
    }
    
    func didFetchVisit(visit: Visit, isNew: Bool) {
        // hold a reference to this visit - needed if user requests to delete it
        self.currentVisit = visit
        visitDelegate?.didChangeVisit(visit: visit, isNew: isNew)
    }
    
    func didSelectStation(index: Int) {
        self.stationIndex = index
        
        // get the traps for the new station
        self.trapIndex = 0
        view.setTraps(traps: Array(self.currentStation.traps.sorted(byKeyPath: "type.order")))
    
    }
}

extension VisitPresenter: TraplineSelectDelegate {
    
    func didCreateRoute(route: Route) {
        // may not use
    }
    
    func didUpdateRoute(route: Route) {
        // decide what to do with Visits no longer on route
        
        self.visitSummary.route = route
        
        // update the navigation strip
        let stations = route.stations
        stationIndex = stationIndex >= stations.count ? stations.count - 1 : stationIndex
        view.setStations(stations: Array(stations), current:  stations[stationIndex])
        view.updateCurrentStation(index: stationIndex, repeatedGroup: 2)
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
