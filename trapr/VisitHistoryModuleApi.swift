//
//  VisitHistoryModuleApi.swift
//  trapr
//
//  Created by Andrew Tokeley on 1/02/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Viperit

//MARK: - VisitHistoryRouter API
protocol VisitHistoryRouterApi: RouterProtocol {
    func showVisitModule(visitSummary: VisitSummary)
}

//MARK: - VisitHistoryView API
protocol VisitHistoryViewApi: UserInterfaceProtocol {
    func displayVisitSummaries(visitSummaries: [VisitSummary])
    
}

//MARK: - VisitHistoryPresenter API
protocol VisitHistoryPresenterApi: PresenterProtocol {
    func didSelectVisitSummary(visitSummary: VisitSummary)
}

//MARK: - VisitHistoryInteractor API
protocol VisitHistoryInteractorApi: InteractorProtocol {
    func getVisitSummariesForRoute(route: Route) -> [VisitSummary]
}
