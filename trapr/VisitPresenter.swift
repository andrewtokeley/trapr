//
//  HomePresenter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class VisitPresenter: VisitInteractorOutput, VisitModuleInterface {
    
    //MARK: - Properties
    
    var view: VisitViewInterface?
    var interactor: VisitInteractorInput?
    
    var visitSummary: VisitSummary? {
        willSet {
            if visitSummary !==  newValue {
                // reset if we're on a new visit summary
                self.trapIndex = TrapIndexPath(traplineIndex: 0, stationIndex: 0, trapIndex: 0)
            }
        }
    }
    
    var trapIndex = TrapIndexPath(traplineIndex: 0, stationIndex: 0, trapIndex: 0)
    
    //MARK: - VisitInteractorOutput
    
    func didFetchVisit(visit: Visit?) {
        
    }
    
    //MARK: - Helpers
    func updateForNewLocation() {
        
        if let station = visitSummary?.traplines![trapIndex.traplineIndex].stations[trapIndex.stationIndex]
        {
            // Update the station label
            view?.setStationText(text: station.longCode)
            
            // Get the traps for the station
            view?.setTraps(traps: Array(station.traps))
            
            // Get the visit for this station
            //interactor?.retrieveVisit(trap
        }
    }
    
//    func updateViewWithVisit(visitIndex: Int) {
//
//        if let visit = visits?[visitIndex] {
//            if let stationCode = visit.trap?.station?.code {
//                view?.setStationText(text: stationCode)
//            }
//            
//            let enablePrevious = visitIndex != 0
//            let enableNext = visitIndex != (visits?.count)! - 1
//            view?.enableNavigation(previous: enablePrevious, next: enableNext)
//        }
//    }
    
    //MARK: - VisitModuleInterface
    
    func viewWillAppear() {
        
        // Title should be set to the date of the visits
        if let title = self.visitSummary?.dateOfVisit.string(from: Styles.DATE_FORMAT_LONG) {
            view?.setTitle(title: title)
        }
        
        updateForNewLocation()
    }
    
    func didSelectPreviousStation() {
        if trapIndex.stationIndex == 0 {
            if trapIndex.traplineIndex != 0 {
                trapIndex.traplineIndex -= 1
            } else {
                trapIndex.traplineIndex = visitSummary!.traplines!.count - 1
            }
            trapIndex.stationIndex = visitSummary!.traplines![trapIndex.traplineIndex].stations.count - 1
        } else {
           trapIndex.stationIndex -= 1
        }
        
        // always reset to the first trap
        trapIndex.trapIndex = 0
        
        updateForNewLocation()
    }
    
    func didSelectNextStation() {
        if trapIndex.stationIndex == visitSummary!.traplines![trapIndex.traplineIndex].stations.count - 1 {
            if trapIndex.traplineIndex != visitSummary!.traplines!.count - 1 {
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
}
