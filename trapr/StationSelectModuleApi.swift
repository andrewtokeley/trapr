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
    
    // Presenter To View
    func initialiseView(groupedData:GroupedTableViewDatasource<Station>, traplines:[Trapline], stations: [Station], selectedStations: [Station]?, allowMultiselect: Bool)
    func setTitle(title: String)
    func showCloseButton()
    func setDoneButtonAttributes(visible: Bool, enabled: Bool)
    func enableSorting(enabled: Bool)
    func setMultiselectToggle(section: Int, state: MultiselectOptions)
    func updateSelectedStations(section: Int, selectedStations: [Station])
    func updateGroupedData(section: Int, groupedData: GroupedTableViewDatasource<Station>)
    func updateGroupedData(groupedData: GroupedTableViewDatasource<Station>)

}

//MARK: - StationSelectPresenter API
protocol StationSelectPresenterApi: PresenterProtocol {
    
    // View to Presenter
    func didSelectRow(section: Int, row: Int)
    func didMoveRow(from: IndexPath, to:IndexPath)
    //func didDeselectStation(section: Int, station: Station)
    func didSelectCloseButton()
    func didSelectMultiselectToggle(section: Int)
    func didSelectDone()
    func didSelectEdit()
    
    
    // For the View (maybe not so good, but hey)
    func getToggleState(section: Int) -> MultiselectOptions
}

//MARK: - StationSelectInteractor API
protocol StationSelectInteractorApi: InteractorProtocol {
    func getDefaultStation() -> Station
    
}
