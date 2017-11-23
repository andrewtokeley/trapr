//
//  StartPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 30/09/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - StartPresenter Class
final class StartPresenter: Presenter {
    
    open override func viewIsAboutToAppear() {
        view.setTitle(title: "Trapr", routesSectionTitle: "ROUTES", routeSectionActionText: "NEW", recentVisitsSectionTitle: "RECENT", recentVisitsSectionActionText: "ALL")
        
        interactor.initialiseHomeModule()
    }

}

// MARK: - NewVisitDelegate
//extension StartPresenter: NewVisitDelegate {
//    func didSelectRoute(route: Route) {
//
//        let visitSummary = VisitSummary(dateOfVisit: Date(), route: route)
//        router.showVisitModule(visitSummary: visitSummary)
//
//    }
//}

// MARK: - StartPresenter API
extension StartPresenter: StartPresenterApi {
    
    func didSelectMenu() {
        let module = AppModules.sideMenu.build()
        module.router.showAsModalOverlay(from: _view)
    }
    
    func didSelectNewVisit() {
        //router.showNewVisitModule(delegate: self)
    }
    
    func didSelectNewRoute() {
        router.showRouteModule(route: nil)
    }
    
    func didSelectVisitSummary(visitSummary: VisitSummary) {
        router.showVisitModule(visitSummary: visitSummary)
    }
    
    func didSelectRoute(route: Route) {        
        let visitSummary = VisitSummary(dateOfVisit: Date(), route: route)
        router.showVisitModule(visitSummary: visitSummary)
    }
    
    func setRecentVisits(visits: [VisitSummary]?) {
        view.displayRecentVisits(visits: visits)
    }

    func setRoutes(routes: [Route]?) {
        view.displayRoutes(routes: routes)
    }
    
}

// MARK: - Start Viper Components
private extension StartPresenter {
    var view: StartViewApi {
        return _view as! StartViewApi
    }
    var interactor: StartInteractorApi {
        return _interactor as! StartInteractorApi
    }
    var router: StartRouterApi {
        return _router as! StartRouterApi
    }
}
