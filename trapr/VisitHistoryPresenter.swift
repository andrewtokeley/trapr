//
//  VisitHistoryPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley on 1/02/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - VisitHistoryPresenter Class
final class VisitHistoryPresenter: Presenter {
    
    override func setupView(data: Any) {
        _view.setTitle(title: "Visit History")
        
        if let setupData = data as? VisitHistorySetupData, let route = setupData.route {
            let visitSummaries = interactor.getVisitSummariesForRoute(route: route)
            view.displayVisitSummaries(visitSummaries: visitSummaries)
        }
    }
}

// MARK: - VisitHistoryPresenter API
extension VisitHistoryPresenter: VisitHistoryPresenterApi {
    
    func didSelectVisitSummary(visitSummary: VisitSummary) {
        router.showVisitModule(visitSummary: visitSummary)
    }
    
}

// MARK: - VisitHistory Viper Components
private extension VisitHistoryPresenter {
    var view: VisitHistoryViewApi {
        return _view as! VisitHistoryViewApi
    }
    var interactor: VisitHistoryInteractorApi {
        return _interactor as! VisitHistoryInteractorApi
    }
    var router: VisitHistoryRouterApi {
        return _router as! VisitHistoryRouterApi
    }
}
