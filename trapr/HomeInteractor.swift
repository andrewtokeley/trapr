//
//  HomeInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

class HomeInteractor: HomeInteractorInput {
    
    var presenter: HomeInteractorOutput?
    
    //MARK: - HomeInteractorInput
    
    func initialiseHomeModule() {
        
        // Get all the visits in the last 3 months
        let visitSummaries = ServiceFactory.sharedInstance.visitService.getVisitSummaries(recordedBetween: Date().add(0, -3, 0), endDate: Date())
        
        presenter?.setRecentVisits(visits: visitSummaries)
    }
}
