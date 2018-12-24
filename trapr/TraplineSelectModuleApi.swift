//
//  TraplineSelectModuleApi.swift
//  trapr
//
//  Created by Andrew Tokeley  on 2/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Viperit

//MARK: - TraplineSelectRouter API
protocol TraplineSelectRouterApi: RouterProtocol {
    func showStationSelect(traplines: [_Trapline])
    func showStationSelect(traplines: [_Trapline], selectedStations: [_Station])
}

//MARK: - TraplineSelectView API
protocol TraplineSelectViewApi: UserInterfaceProtocol {
    
    //func setTitle(title: String)
    func setRouteName(name: String?)
    func setRouteNamePlaceholderText(text: String)
    func setSelectedTraplinesDescription(description: String)
    func updateDisplay(traplines: [_Trapline], selected: [_Trapline]?)
    func setNextButtonState(enabled: Bool)
    func showCloseButton(show: Bool)
    
}

//MARK: - TraplineSelectPresenter API
protocol TraplineSelectPresenterApi: PresenterProtocol {
    func didChangeRouteName(name: String?)
    func didSelectTrapline(trapline: _Trapline)
    func didDeselectTrapline(trapline: _Trapline)
    func didSelectNext()
    func didSelectClose()

}

//MARK: - TraplineSelectInteractor API
protocol TraplineSelectInteractorApi: InteractorProtocol {
    func getAllTraplines(completion: (([_Trapline]) -> Void)?)
    func updateStations(routeId: String, stationIds: [String])
    func addRoute(route: _Route)
}
