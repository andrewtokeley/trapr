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
    func showListPicker(setupData: ListPickerSetupData)
    //func showRouteDashboard(newRouteName: String, station: Station)
    func showRouteDashboard(newRouteName: String, station: _Station)
}

//MARK: - NewRouteView API
protocol NewRouteViewApi: UserInterfaceProtocol {
    func displayRouteName(name: String?)
    func enableNextButton(enabled: Bool)
    func setTraplines(traplines: [_Trapline])
    func displaySelectedRegion(description: String?)
    func displaySelectedTrapline(description: String?)
    func displaySelectedStation(description: String?)
}

//MARK: - NewRoutePresenter API
protocol NewRoutePresenterApi: PresenterProtocol {
    func didUpdateRouteName(name: String?)
    func didSelectTraplineListPicker()
    func didSelectStationListPicker()
    func didSelectRegionListPicker()
    func didSelectCancel()
    func didSelectNext()
//    func didFetchTraplines(traplines: [Trapline])
//    func didFetchRegions(regions: [Region])
//    func didFetchStations(stations: [Station])
    func didFetchTraplines(traplines: [_Trapline])
    func didFetchRegions(regions: [_Region])
    func didFetchStations(stations: [_Station])
    
}

//MARK: - NewRouteInteractor API
protocol NewRouteInteractorApi: InteractorProtocol {
    //func retrieveTraplines(region: Region)
    func retrieveStations(traplineId: String)
    func retrieveTraplines(regionId: String)
    func retrieveRegions()
}
