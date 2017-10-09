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
        let visit = visits.filter({ (visit) in return visit.trap === trap })
        presenter.didFetchVisit(visit: visit.first)
    
    }
    
    func addVisit(visit: Visit) {
        ServiceFactory.sharedInstance.visitService.add(visit: visit)
    }
}

// MARK: - Interactor Viper Components Api
private extension VisitInteractor {
    var presenter: VisitPresenterApi {
        return _presenter as! VisitPresenterApi
    }
}

