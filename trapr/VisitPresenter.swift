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
    
    var visitSummary: VisitSummary? {
        willSet {
            if visitSummary !== newValue {
                // reset to the first trap
                self.trapIndex = TrapIndexPath(traplineIndex: 0, stationIndex: 0, trapIndex: 0)
            }
        }
    }
    
    var trapIndex = TrapIndexPath(traplineIndex: 0, stationIndex: 0, trapIndex: 0)
    var stationIndex = 0
    
    open override func setupView(data: Any) {
        if let convertedData = data as? VisitSummary {
            visitSummary = convertedData
        }
    }
    
    open override func viewIsAboutToAppear() {

        updateTitle()
        updateForNewLocation()
        
    }
    
    //MARK: - Helpers
    
    func updateTitle() {
        if let title = self.visitSummary?.dateOfVisit.string(from: Styles.DATE_FORMAT_LONG) {
            view.setTitle(title: title)
        }
    }
    
    func updateForNewLocation() {
        
//        if let station = visitSummary?.traplines[trapIndex.traplineIndex].stations[trapIndex.stationIndex]

        if let station = visitSummary?.route?.stations[stationIndex]
        {
            // Update the station label
            view.setStationText(text: station.longCode)
            
            // Get the traps for the station
            view.setTraps(traps: Array(station.traps))
            
            // Get the visit for this station
            //interactor?.retrieveVisit(trap
        }
    }
}

// MARK: - VisitPresenter API
extension VisitPresenter: DatePickerDelegate {
    
    
    func displayMode(datePicker: DatePickerViewApi) -> UIDatePickerMode {
        return UIDatePickerMode.date
    }
    
    func datePicker(datePicker: DatePickerViewApi, didSelectDate: Date) {
        visitSummary?.dateOfVisit = didSelectDate
        updateTitle()
    }
    
    func showTodayButton(datePicker: DatePickerViewApi) -> Bool {
        return true
    }
}


// MARK: - VisitPresenter API
extension VisitPresenter: StationSelectDelegate {
    
    func didSelectStations(stations: [Station]) {
        
        // should only be a single station
        if let station = stations.first {
            if let index = visitSummary?.route?.stations.index(where: { $0.longCode == station.longCode }) {
                stationIndex = index
                updateForNewLocation()
            }
        }
    }
}

// MARK: - VisitPresenter API
extension VisitPresenter: VisitPresenterApi {
    
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
    
    func didSelectPreviousStation() {
//        if trapIndex.stationIndex == 0 {
//            if trapIndex.traplineIndex != 0 {
//                trapIndex.traplineIndex -= 1
//            } else {
//                trapIndex.traplineIndex = visitSummary!.traplines.count - 1
//            }
//            trapIndex.stationIndex = visitSummary!.traplines[trapIndex.traplineIndex].stations.count - 1
//        } else {
//            trapIndex.stationIndex -= 1
//        }
//
//        // always reset to the first trap
//        trapIndex.trapIndex = 0

        stationIndex -= 1
        if stationIndex < 0 {
            if let index = visitSummary?.route?.stations.count {
                // go to the end of the list of stations
                stationIndex = index - 1
            } else
            {
                // should never happen
                stationIndex = 0
            }
    
        }
        updateForNewLocation()
    }
    
    func didSelectNextStation() {
//        if trapIndex.stationIndex == visitSummary!.traplines[trapIndex.traplineIndex].stations.count - 1 {
//            if trapIndex.traplineIndex != visitSummary!.traplines.count - 1 {
//                trapIndex.traplineIndex += 1
//            } else {
//                trapIndex.traplineIndex = 0
//            }
//            trapIndex.stationIndex = 0
//        } else {
//            trapIndex.stationIndex += 1
//        }
//
//        // always reset to the first trap
//        trapIndex.trapIndex = 0

        stationIndex += 1
        if let index = visitSummary?.route?.stations.count {
            if stationIndex >= index {
                stationIndex = 0
            }
        }
        
        updateForNewLocation()
    }
    
    func didSelectTrap(index: Int) {
        trapIndex.trapIndex = index
        
        // if a visit exists, populate screen
        
        // if no visit then...
        updateForNewLocation()
    }
    
    func didFetchVisit(visit: Visit?) {
        
    }
    
    func didSelectStation() {
        if let route = visitSummary?.route {
        
            let stationSelectSetupData = StationSelectSetupData(traplines: route.traplines, selectedStations: route.stations)
            stationSelectSetupData.allowMultiselect = false
            stationSelectSetupData.showAllStations = false
            stationSelectSetupData.stationSelectDelegate = self
            router.showStationSelectModule(setupData: stationSelectSetupData)
        } else {
            // may not allow no station to appear.
        }
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
