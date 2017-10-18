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
    func initialiseView(traplines:[Trapline], stations: [Station], selectedStations: [Station]?, allowMultiselect: Bool)
    func setTitle(title: String)
    func showCloseButton()
    func setDoneButtonAttributes(visible: Bool, enabled: Bool)
    func setMultiselectToggle(section: Int, state: MultiselectToggle)
    func updateSelectedStations(section: Int, selectedStations: [Station])
}

//MARK: - StationSelectPresenter API
protocol StationSelectPresenterApi: PresenterProtocol {
    //func didRequestToSelectTrapline()
    func didSelectStation(station: Station)
    func didDeselectStation(station: Station)
    func didSelectCloseButton()
    func didSelectMultiselectToggle(section: Int)
    func didSelectDone()
    
    func getToggleState(section: Int) -> MultiselectToggle
}

//MARK: - StationSelectInteractor API
protocol StationSelectInteractorApi: InteractorProtocol {
    func getDefaultStation() -> Station
    
}
