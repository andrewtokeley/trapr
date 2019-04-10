//
//  TraplineSelectRouter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 2/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - TraplineSelectRouter class
final class TraplineSelectRouter: Router {
    
    func showStationSelect(traplines: [Trapline], stations: [Station], selectedStationIds: [String]?) {
        let module = AppModules.stationSelect.build()
        
        let setupData = StationSelectSetupData(traplines: traplines, stations: stations, selectedStationIds: selectedStationIds ?? [String()])
        setupData.stationSelectDelegate = presenter as? StationSelectDelegate
        
        // whenever presenting the SelectStation module from the TraplineSelect module, we're editing a route so should allow multiselect.
        setupData.allowMultiselect = true
        
        setupData.selectedStationIds = selectedStationIds
        setupData.stations = stations
        
        module.router.show(from: viewController, embedInNavController: false, setupData: setupData)
    }
    
    /**
     Show the StationSelect module for given traplines, show all stations and pre-select all stations.
    */
    func showStationSelect(traplines: [Trapline]) {
//        let stations = stationIdsForTraplines(traplines: traplines)
//        showStationSelect(traplines: traplines, stations: stations, selectedStationIds: stations)
    }
    
    /**
     Show the StationSelect module for specific traplines, show all stations and select the specified ones
     */
    func showStationSelect(traplines: [Trapline], selectedStations: [Station]) {
        
//        let stationIds = stationIdsForTraplines(traplines: traplines)
//        showStationSelect(traplines: traplines, stations: stations, selectedStations: selectedStations)
    }

    /**
     Show the StationSelect module for specific traplines, show only the specified stations. None will be selected.
     */
//    func showStationSelect(traplines: [Trapline], stations: [Station]) {
//        
//        showStationSelect(traplines: traplines, stations: stations, selectedStations: nil)
//    }
    
    private func stationIdsForTraplines(traplines: [Trapline]) -> [String] {
//        var stationIds = [String]()
//        
//        // show and select all stations
//        for trapline in traplines {
//            stationIds.append(contentsOf: trapline.stationIds)
//        }
//        return stations
        return [String]()
    }
    
}

// MARK: - TraplineSelectRouter API
extension TraplineSelectRouter: TraplineSelectRouterApi {
    
}

// MARK: - TraplineSelect Viper Components
private extension TraplineSelectRouter {
    var presenter: TraplineSelectPresenterApi {
        return _presenter as! TraplineSelectPresenterApi
    }
}
