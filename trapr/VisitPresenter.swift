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
    
    var view: VisitViewInterface?
    var interactor: VisitInteractorInput?
    
    // var dateOfVisit: Date?
    var visitSummary: VisitSummary?
    
    var visits: [Visit]?
    var currentVisitIndex: Int = 0
    var stationIndex = TrapSectionIndexPath(trapIndex: 0, stationIndex: 0)
    
    //MARK: - VisitInteractorOutput
    
    func didFetchVisits(visits: [Visit]?) {
//        self.visits = visits
//        currentVisitIndex = 0
//        
//        updateViewWithVisit(visitIndex: currentVisitIndex)
    }

    func didFetchTraplines(traplines: [Trapline]?) {
        
    }
    
    //MARK: - Helpers
    func updateStationText() {
        if let longCode = visitSummary?.traplines![stationIndex.trapIndex].stations[stationIndex.stationIndex].longCode {
            view?.setStationText(text: longCode)
        }
        else {
            view?.setStationText(text: "new")
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
        
        updateStationText()
    }
    
    func didSelectPreviousStation() {
        if stationIndex.stationIndex == 0 {
            if stationIndex.trapIndex != 0 {
                stationIndex.trapIndex -= 1
            } else {
                stationIndex.trapIndex = visitSummary!.traplines!.count - 1
            }
            stationIndex.stationIndex = visitSummary!.traplines![stationIndex.trapIndex].stations.count - 1
        } else {
           stationIndex.stationIndex -= 1
        }
        updateStationText()
    }
    
    func didSelectNextStation() {
        if stationIndex.stationIndex == visitSummary!.traplines![stationIndex.trapIndex].stations.count - 1 {
            if stationIndex.trapIndex != visitSummary!.traplines!.count - 1 {
                stationIndex.trapIndex += 1
            } else {
                stationIndex.trapIndex = 0
            }
            stationIndex.stationIndex = 0
        } else {
            stationIndex.stationIndex += 1
        }
        updateStationText()
    }

}
