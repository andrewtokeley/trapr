//
//  TrapStatisticsModuleApi.swift
//  trapr
//
//  Created by Andrew Tokeley on 14/07/20.
//Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Viperit

//MARK: - TrapStatisticsRouter API
protocol TrapStatisticsRouterApi: RouterProtocol {
}

//MARK: - TrapStatisticsView API
protocol TrapStatisticsViewApi: UserInterfaceProtocol {
    func displayStatistics(statistics: TrapStatistics, showCatchStats: Bool)
}

//MARK: - TrapStatisticsPresenter API
protocol TrapStatisticsPresenterApi: PresenterProtocol {
}

//MARK: - TrapStatisticsInteractor API
protocol TrapStatisticsInteractorApi: InteractorProtocol {
    func fetchTrapStatistics(routeId: String, stationId: String, trapTypeId: String, completion: ((TrapStatistics?, Error?) -> Void)?)
}
