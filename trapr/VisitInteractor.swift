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
            
            // visit exists for this day
            presenter.didFetchVisit(visit: visits[0])
        } else {
            // no visit exists
            presenter.didFindNoVisit()
            
            // create a new Visit, with time now (but date the same as being requested)
//            if let dateNow = date.setTimeToNow() {
//                let newVisit = Visit(date: dateNow, route: route, trap: trap)
//                presenter.didFetchVisit(visit: newVisit)
//            }
        }
    }
    
    func addVisit(visit: Visit) {
        ServiceFactory.sharedInstance.visitService.add(visit: visit)
        presenter.didFetchVisit(visit: visit)
    }
    
    func deleteVisit(visit: Visit) {
        if let visitToDelete = ServiceFactory.sharedInstance.visitService.getById(id: visit.id) {
            ServiceFactory.sharedInstance.visitService.delete(visit: visitToDelete)
        }
    }
    
    func deleteAllVisits(route: Route, date: Date) {
        let visits = ServiceFactory.sharedInstance.visitService.getVisits(recordedOn: date, route: route)
        for visit in visits {
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

