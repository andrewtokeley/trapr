//
//  OrderStationsModuleApi.swift
//  trapr
//
//  Created by Andrew Tokeley on 31/01/19.
//Copyright © 2019 Andrew Tokeley . All rights reserved.
//

import Viperit

//MARK: - OrderStationsRouter API
protocol OrderStationsRouterApi: RouterProtocol {
}

//MARK: - OrderStationsView API
protocol OrderStationsViewApi: UserInterfaceProtocol {
    func updateViewModel(viewModel: StationViewModel)
}

//MARK: - OrderStationsPresenter API
protocol OrderStationsPresenterApi: PresenterProtocol {
    func didMoveStation(sourceIndex: Int, destinationIndex: Int)
    func didSelectDone()
}

//MARK: - OrderStationsInteractor API
protocol OrderStationsInteractorApi: InteractorProtocol {
    func moveStation(routeId: String, sourceIndex: Int, destinationIndex: Int, completion: (([String]) -> Void)?)
}
