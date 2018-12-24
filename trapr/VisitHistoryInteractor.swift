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
    let visitService = ServiceFactory.sharedInstance.visitFirestoreService
    let visitSummaryService = ServiceFactory.sharedInstance.visitSummaryFirestoreService
}

// MARK: - VisitHistoryInteractor API
extension VisitHistoryInteractor: VisitHistoryInteractorApi {
    
    func deleteVisitSummary(visitSummary: _VisitSummary) {
        visitService.delete(visitSummary: visitSummary, completion: nil)
    }
    
    func getVisitSummariesForRoute(routeId: String, completion: (([_VisitSummary], Error?) -> Void)?) {
        // Get all the summaries from year dot, order with the most recent first
        visitSummaryService.get(recordedBetween: Date().add(0,0,-100), endDate: Date(), routeId: routeId) { (visitSummaries, error) in
            completion?(visitSummaries, error)
        }
    }
    
}

// MARK: - Interactor Viper Components Api
private extension VisitHistoryInteractor {
    var presenter: VisitHistoryPresenterApi {
        return _presenter as! VisitHistoryPresenterApi
    }
}
