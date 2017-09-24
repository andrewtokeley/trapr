//
//  HomeInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

class VisitInteractor: VisitInteractorInput {
    
    var presenter: VisitInteractorOutput?
    
    //MARK: - HomeInteractorInput
    
    func initialiseVisitModule(dateOfVisit: Date) {
        
        // Get all the visits for this date
        let visits = ServiceFactory.sharedInstance.visitService.getVisits(recordedOn: dateOfVisit)
        
        presenter?.didFetchVisits(visits: Array(visits))
    }
}
