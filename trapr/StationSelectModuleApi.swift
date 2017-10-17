//
//  StationSelectModuleApi.swift
//  trapr
//
//  Created by Andrew Tokeley  on 3/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Viperit

//MARK: - StationSelectRouter API
protocol StationSelectRouterApi: RouterProtocol {
    //func showTraplineSelectModule(setupData: TraplineSelectSetupData)
}

//MARK: - StationSelectView API
protocol StationSelectViewApi: UserInterfaceProtocol {
    func setTitle(title: String)
    func showCloseButton()
    func setDoneButtonAttributes(visible: Bool, enabled: Bool)
    func initialiseView(traplines: [Trapline], selectedStations: [Station]?, showAllStations: Bool, allowMultiselect: Bool)
}

//MARK: - StationSelectPresenter API
protocol StationSelectPresenterApi: PresenterProtocol {
    //func didRequestToSelectTrapline()
    func didSelectStation(station: Station)
    func didDeselectStation(station: Station)
    func didSelectCloseButton()
    func didSelectDone()
}

//MARK: - StationSelectInteractor API
protocol StationSelectInteractorApi: InteractorProtocol {
    func getDefaultStation() -> Station
    
}
