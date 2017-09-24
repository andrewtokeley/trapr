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
    
    var dateOfVisit: Date?
    var visits: [Visit]?
    var currentVisitIndex: Int = 0
    
    //MARK: - VisitInteractorOutput
    
    func didFetchVisits(visits: [Visit]?) {
        self.visits = visits
        currentVisitIndex = 0
        
        updateViewWithVisit(visitIndex: currentVisitIndex)
    }

    func didSelectPreviousStation() {
        if (currentVisitIndex != 0) {
            currentVisitIndex -= 1
            updateViewWithVisit(visitIndex: currentVisitIndex)
        }
    }
    
    func didSelectNextStation() {
        if (currentVisitIndex != (visits?.count)! - 1) {
            currentVisitIndex += 1
            updateViewWithVisit(visitIndex: currentVisitIndex)
        }
    }
    
    func didSetDateOfVisit(date: Date) {
        self.dateOfVisit = date
    }
    
    //MARK: - Helpers
    
    func updateViewWithVisit(visitIndex: Int) {

        if let visit = visits?[visitIndex] {
            if let stationCode = visit.trap?.station?.code {
                view?.setStationText(text: stationCode)
            }
            
            let enablePrevious = visitIndex != 0
            let enableNext = visitIndex != (visits?.count)! - 1
            view?.enableNavigation(previous: enablePrevious, next: enableNext)
        }
    }
    
    //MARK: - VisitModuleInterface
    
    func viewWillAppear() {
        
        // the date must have been set by this time
        guard dateOfVisit != nil else {
            return
        }
        
        // Title should be set to the date of the visits
        if let title = self.dateOfVisit?.string(from: Styles.DATE_FORMAT_LONG) {
            view?.setTitle(title: title)
        }
        
        interactor?.initialiseVisitModule(dateOfVisit: self.dateOfVisit!)
        
    }
}
