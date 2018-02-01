//
//  VisitHistoryInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley on 1/02/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - VisitHistoryInteractor Class
final class VisitHistoryInteractor: Interactor {
}

// MARK: - VisitHistoryInteractor API
extension VisitHistoryInteractor: VisitHistoryInteractorApi {
    
    func getVisitSummariesForRoute(route: Route) -> [VisitSummary] {
        let service = ServiceFactory.sharedInstance.visitService
        
        // Get all the summaries from year dot, order with the most recent first
        let visitSummaries = service.getVisitSummaries(recordedBetween: Date().add(0, 0, -100), endDate: Date(), route: route).sorted(by: {
            (v1, v2) in
            v1.dateOfVisit > v2.dateOfVisit
        })
        
        return visitSummaries
    }
    
}

// MARK: - Interactor Viper Components Api
private extension VisitHistoryInteractor {
    var presenter: VisitHistoryPresenterApi {
        return _presenter as! VisitHistoryPresenterApi
    }
}
