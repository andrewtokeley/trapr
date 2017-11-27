//
//  StartInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley  on 30/09/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - StartInteractor Class
final class StartInteractor: Interactor {
}

// MARK: - StartInteractor API
extension StartInteractor: StartInteractorApi {
    func initialiseHomeModule() {
        // Get all the visits in the last 3 months
        let visitSummaries = ServiceFactory.sharedInstance.visitService.getVisitSummaries(recordedBetween: Date().add(0, -3, 0), endDate: Date())
        presenter.setRecentVisits(visits: visitSummaries)
        
        let routes = ServiceFactory.sharedInstance.routeService.getAll()
        presenter.setRoutes(routes: routes)
    }
    
    func deleteRoute(route: Route) {
        ServiceFactory.sharedInstance.routeService.delete(route: route)
    }
}

// MARK: - Interactor Viper Components Api
private extension StartInteractor {
    var presenter: StartPresenterApi {
        return _presenter as! StartPresenterApi
    }
}
