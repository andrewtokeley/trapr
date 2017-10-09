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
    
    open override func setupView(data: Any) {
        if let convertedData = data as? VisitSummary {
            visitSummary = convertedData
        }
    }
    
    open override func viewIsAboutToAppear() {

        // Title should be set to the date of the visits
        if let title = self.visitSummary?.dateOfVisit.string(from: Styles.DATE_FORMAT_LONG) {
            view.setTitle(title: title)
        }
        
        updateForNewLocation()
    }
    
    //MARK: - Helpers
    func updateForNewLocation() {
        
        if let station = visitSummary?.traplines[trapIndex.traplineIndex].stations[trapIndex.stationIndex]
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
extension VisitPresenter: StationSelectDelegate {
    
    func didSelectStation(station: Station) {
        
        // Set the trapIndex to the selected Station
        
        if let traplineIndex = self.visitSummary?.traplines.index(of: station.trapline!) {
            if let stationIndex = self.visitSummary?.traplines[traplineIndex].stations.index(of: station) {
        
                trapIndex = TrapIndexPath(traplineIndex: traplineIndex, stationIndex: stationIndex, trapIndex: 0)
            }
        } else {
            // this is a station on a trapline that isn't currently part of the visitSummary, so let's add it
            self.visitSummary?.traplines.append(station.trapline!)
            trapIndex = TrapIndexPath(traplineIndex: self.visitSummary!.traplines.count - 1, stationIndex: 0, trapIndex: 0)
        }
        
        updateForNewLocation()
    }
}

// MARK: - VisitPresenter API
extension VisitPresenter: VisitPresenterApi {
    
    func didSelectPreviousStation() {
        if trapIndex.stationIndex == 0 {
            if trapIndex.traplineIndex != 0 {
                trapIndex.traplineIndex -= 1
            } else {
                trapIndex.traplineIndex = visitSummary!.traplines.count - 1
            }
            trapIndex.stationIndex = visitSummary!.traplines[trapIndex.traplineIndex].stations.count - 1
        } else {
            trapIndex.stationIndex -= 1
        }
        
        // always reset to the first trap
        trapIndex.trapIndex = 0
        
        updateForNewLocation()
    }
    
    func didSelectNextStation() {
        if trapIndex.stationIndex == visitSummary!.traplines[trapIndex.traplineIndex].stations.count - 1 {
            if trapIndex.traplineIndex != visitSummary!.traplines.count - 1 {
                trapIndex.traplineIndex += 1
            } else {
                trapIndex.traplineIndex = 0
            }
            trapIndex.stationIndex = 0
        } else {
            trapIndex.stationIndex += 1
        }
        
        // always reset to the first trap
        trapIndex.trapIndex = 0
        
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
        if let station = visitSummary?.traplines[trapIndex.traplineIndex].stations[trapIndex.stationIndex] {
        
            let stationSelectSetupData = StationSelectSetupData(visitSummary: visitSummary!, currentStation: station, delegate: self)
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
