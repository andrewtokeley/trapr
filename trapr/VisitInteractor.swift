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
    
    func retrieveVisit(trap: Trap, date: Date) {
        
        let visits = Array(ServiceFactory.sharedInstance.visitService.getVisits(recordedOn: date))
        
        // Find the visit for the given trap
        // NOTE: not supporting multiple visits to the same trap on the same day
        if let visit = visits.filter({ (visit) in return visit.trap?.id == trap.id}).first {
            
            // trap exists for this day
            presenter.didFetchVisit(visit: visit, isNew: false)
        } else {
            
            // create a new Visit
            let newVisit = Visit(trap: trap, date: date)
            presenter.didFetchVisit(visit: newVisit, isNew: true)
        }
    }
    
    func addVisit(visit: Visit) {
        ServiceFactory.sharedInstance.visitService.add(visit: visit)
    }
    
    func deleteVisit(visit: Visit) {
        ServiceFactory.sharedInstance.visitService.delete(visit: visit)
    }
}

// MARK: - Interactor Viper Components Api
private extension VisitInteractor {
    var presenter: VisitPresenterApi {
        return _presenter as! VisitPresenterApi
    }
}

