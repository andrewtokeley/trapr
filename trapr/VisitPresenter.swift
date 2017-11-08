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

// MARK: - VisitPresenter Class
final class VisitPresenter: Presenter {
    
    var visitSummary: VisitSummary!
    var visitDelegate: VisitDelegate?
    
    var currentTrap: Trap {
        return self.visitSummary.route.stations[stationIndex].traps[trapIndex]
    }
    var currentStation: Station {
        return self.visitSummary.route.stations[stationIndex]
    }
    
    var stationIndex = 0
    var trapIndex = 0
    
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
    
    
    //MARK: - Helpers

    func updateTitle() {
        let title = self.visitSummary.dateOfVisit.string(from: Styles.DATE_FORMAT_LONG)
        view.setTitle(title: title)
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
        interactor.retrieveVisit(trap: self.currentTrap, date: visitSummary.dateOfVisit)
    }
}


// MARK: - StationSelectDelegate
extension VisitPresenter: StationSelectDelegate {
    
    func didSelectStations(stations: [Station]) {
        
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
    
    
    func setVisitDelegate(delegate: VisitDelegate) {
        self.visitDelegate = delegate
    }
    
    func didSelectMenuButton() {
        view.displayMenuOptions(options: ["Send Report", "Add/Remove Trapline", "Remove Visit", "View Map"])
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
        interactor.retrieveVisit(trap: self.currentTrap, date: visitSummary.dateOfVisit)
    }
    
    func didFetchVisit(visit: Visit) {
        visitDelegate?.didChangeVisit(visit: visit)
    }
    
    func didSelectStation(index: Int) {
        self.stationIndex = index
        
        // get the traps for the new station
        self.trapIndex = 0
        view.setTraps(traps: Array(self.currentStation.traps))
    
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
