//
//  HomeInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift

class VisitInteractor: VisitInteractorInput {
    
    var presenter: VisitInteractorOutput?
    
    var visits: Results<Visit>!
    
    //MARK: - HomeInteractorInput
    
    func retrieveVisit(trap: Trap, date: Date) {
    
        visits = ServiceFactory.sharedInstance.visitService.getVisits(recordedOn: date)
        
        // Find the visit for the given trap
        // NOTE: not supporting multiple visits to the same trap on the same day
        let visit = visits.filter({ (visit) in return visit.trap === trap })
        presenter?.didFetchVisit(visit: visit.first)
    }
    
    func addVisit(visit: Visit) {
        ServiceFactory.sharedInstance.visitService.add(visit: visit)
    }
}
