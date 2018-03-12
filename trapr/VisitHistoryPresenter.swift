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
    private var route: Route!
    private var visitSummaries = [VisitSummary]()
    override func setupView(data: Any) {
        _view.setTitle(title: "Visits")
        
        if let setupData = data as? VisitHistorySetupData, let route = setupData.route {
            self.route = route
            //self.refreshVisitSummaries(fullReload: true)
        }
    }
    
    private func refreshVisitSummaries(fullReload: Bool) {
        visitSummaries = interactor.getVisitSummariesForRoute(route: self.route)
        view.displayVisitSummaries(visitSummaries: visitSummaries, fullReload: fullReload)
    }
    
    override func viewIsAboutToAppear() {
        let currentSummaryCount = visitSummaries.count
        visitSummaries = interactor.getVisitSummariesForRoute(route: self.route)
        let summaryDeleted = currentSummaryCount != self.visitSummaries.count
        
        // if we're coming back to this module and a summary was deleted (i.e. we drilled into a summary and deleted) then do a full refresh, rather than refreshing the summary that was edited
        self.refreshVisitSummaries(fullReload: summaryDeleted)
    }
}

// MARK: - VisitHistoryPresenter API
extension VisitHistoryPresenter: VisitHistoryPresenterApi {
    
    func didSelectDeleteVisitSummary(visitSummary: VisitSummary) {
        let count = visitSummary.visits.count
        let date = visitSummary.dateOfVisit.toString(from: Styles.DATE_FORMAT_LONG)
        let message = "Are you sure you want to delete all \(count) visit records on \(date)"
        _view.presentConfirmation(title: "Delete", message: message, response: {
            (response) in
            if response {
                self.interactor.deleteVisitSummary(visitSummary: visitSummary)
                self.refreshVisitSummaries(fullReload: true)
            }
        })
    }
    
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
