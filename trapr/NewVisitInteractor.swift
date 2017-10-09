//
//  NewVisitInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley  on 7/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - NewVisitInteractor Class
final class NewVisitInteractor: Interactor {
}

// MARK: - NewVisitInteractor API
extension NewVisitInteractor: NewVisitInteractorApi {
    func fetchRecentVisits() {
        let visitSummaries =
            ServiceFactory.sharedInstance.visitService.getVisitSummaries(recordedBetween: Date().add(0, -3, 0), endDate: Date(), mostRecentOnly: true)
        presenter.didFetchRecentVisits(visitSummaries: visitSummaries)
    }
}

// MARK: - Interactor Viper Components Api
private extension NewVisitInteractor {
    var presenter: NewVisitPresenterApi {
        return _presenter as! NewVisitPresenterApi
    }
}
