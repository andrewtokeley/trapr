//
//  RouteInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley on 21/11/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - RouteInteractor Class
final class RouteInteractor: Interactor {
}

// MARK: - RouteInteractor API
extension RouteInteractor: RouteInteractorApi {
    func saveRoute(route: Route) {
        let service = ServiceFactory.sharedInstance.routeService
        service.save(route: route)
    }
}

// MARK: - Interactor Viper Components Api
private extension RouteInteractor {
    var presenter: RoutePresenterApi {
        return _presenter as! RoutePresenterApi
    }
}
