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
    func showStationSelect(traplines: [Trapline])
    func showStationSelect(traplines: [Trapline], selectedStations: [Station])
}

//MARK: - TraplineSelectView API
protocol TraplineSelectViewApi: UserInterfaceProtocol {
    
    func setTitle(title: String)
    func setRouteName(name: String?)
    func setRouteNamePlaceholderText(text: String)
    func setSelectedTraplinesDescription(description: String)
    func updateDisplay(traplines: [Trapline], selected: [Trapline]?)
    func setNextButtonState(enabled: Bool)
    func showCloseButton(show: Bool)
    
}

//MARK: - TraplineSelectPresenter API
protocol TraplineSelectPresenterApi: PresenterProtocol {
    func didChangeRouteName(name: String?)
    func didSelectTrapline(trapline: Trapline)
    func didDeselectTrapline(trapline: Trapline)
    func didSelectNext()
    func didSelectClose()

}

//MARK: - TraplineSelectInteractor API
protocol TraplineSelectInteractorApi: InteractorProtocol {
    func getAllTraplines() -> [Trapline]?
    func updateStations(route: Route, stations: [Station])
    func addRoute(route: Route)
}
