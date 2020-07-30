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
    func showListPicker(setupData: ListPickerSetupData) 
}

//MARK: - TrapStatisticsView API
protocol TrapStatisticsViewApi: UserInterfaceProtocol {
    func displayStatistics(statistics: TrapStatistics, trapTypeStatistics: TrapTypeStatistics, showCatchStats: Bool)
}

//MARK: - TrapStatisticsPresenter API
protocol TrapStatisticsPresenterApi: PresenterProtocol {
    func didSelectToViewCatchDetails()
}

//MARK: - TrapStatisticsInteractor API
protocol TrapStatisticsInteractorApi: InteractorProtocol {
    func fetchTrapStatistics(routeId: String, stationId: String, trapTypeId: String, completion: ((TrapStatistics?, Error?) -> Void)?)
}
