//
//  HomeInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import RealmSwift
import Viperit

// MARK: - VisitInteractor Class
final class VisitInteractor: Interactor {

    fileprivate var visits: [Visit]!
}

// MARK: - VisitInteractor API
extension VisitInteractor: VisitInteractorApi {
    
    func retrieveVisit(date: Date, route: Route, trap: Trap) {
        
        let visits = Array(ServiceFactory.sharedInstance.visitService.getVisits(recordedOn: date, route: route, trap: trap))
        
        // Find the visit for the given trap
        // NOTE: not supporting multiple visits to the same trap on the same day
        if visits.count > 0 {
            
            // trap exists for this day
            presenter.didFetchVisit(visit: visits[0], isNew: false)
        } else {
            
            // create a new Visit
            let newVisit = Visit(date: date, route: route, trap: trap)
            presenter.didFetchVisit(visit: newVisit, isNew: true)
        }
    }
    
    func addVisit(visit: Visit) {
        ServiceFactory.sharedInstance.visitService.add(visit: visit)
    }
    
    func deleteVisit(visit: Visit) {
        ServiceFactory.sharedInstance.visitService.delete(visit: visit)
    }
    
    func deleteAllVisits(visitSummary: VisitSummary) {
        for visit in visitSummary.visits {
            deleteVisit(visit: visit)
        }
    }
}

// MARK: - Interactor Viper Components Api
private extension VisitInteractor {
    var presenter: VisitPresenterApi {
        return _presenter as! VisitPresenterApi
    }
}

