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
    func showVisitModule(visitSummary: _VisitSummary)
}

//MARK: - VisitHistoryView API
protocol VisitHistoryViewApi: UserInterfaceProtocol {
    func displayVisitSummaries(visitSummaries: [_VisitSummary], fullReload: Bool)
    
}

//MARK: - VisitHistoryPresenter API
protocol VisitHistoryPresenterApi: PresenterProtocol {
    func didSelectVisitSummary(visitSummary: _VisitSummary)
    func didSelectDeleteVisitSummary(visitSummary: _VisitSummary)
}

//MARK: - VisitHistoryInteractor API
protocol VisitHistoryInteractorApi: InteractorProtocol {
    func getVisitSummariesForRoute(routeId: String, completion: (([_VisitSummary], Error?) -> Void)?)
    func deleteVisitSummary(visitSummary: _VisitSummary)
}
