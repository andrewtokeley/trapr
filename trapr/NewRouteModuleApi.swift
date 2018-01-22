//
//  NewRouteModuleApi.swift
//  trapr
//
//  Created by Andrew Tokeley on 19/01/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Viperit

//MARK: - NewRouteRouter API
protocol NewRouteRouterApi: RouterProtocol {
    func showRouteDashboard(newRouteName: String)
}

//MARK: - NewRouteView API
protocol NewRouteViewApi: UserInterfaceProtocol {
    func displayRouteName(name: String?)
}

//MARK: - NewRoutePresenter API
protocol NewRoutePresenterApi: PresenterProtocol {
    func didUpdateRouteName(name: String?)
    func didSelectCancel()
    func didSelectNext()
}

//MARK: - NewRouteInteractor API
protocol NewRouteInteractorApi: InteractorProtocol {
}
