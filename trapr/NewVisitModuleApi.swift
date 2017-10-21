//
//  NewVisitModuleApi.swift
//  trapr
//
//  Created by Andrew Tokeley  on 7/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Viperit

//MARK: - NewVisitRouter API
protocol NewVisitRouterApi: RouterProtocol {
    func showTrapLineSelectModule(delegate: TraplineSelectDelegate?)
}

//MARK: - NewVisitView API
protocol NewVisitViewApi: UserInterfaceProtocol {
    func setTitle(title: String)
    func displayRecentRoutes(routes: [Route]?)
}

//MARK: - NewVisitPresenter API
protocol NewVisitPresenterApi: PresenterProtocol {
    func didSelectOther()
    func didSelectCloseButton()
    func didSelectRecentRoute(route: Route)
    func didSelectDeleteRoute(route: Route)
    func didFetchRecentRoutes(routes: [Route]?)
}

//MARK: - NewVisitInteractor API
protocol NewVisitInteractorApi: InteractorProtocol {
    //func fetchRecentVisits()
    func fetchRecentRoutes()
}
