//
//  SelectStationDelegate.swift
//  trapr
//
//  Created by Andrew Tokeley  on 4/10/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol StationSelectDelegate {
    func didSelectStations(stations: [Station])
}

class StationSelectSetupData {
    
    var traplines: [Trapline]
    var stations: [Station]
    var selectedStations: [Station]?
    //var showAllStations: Bool = false
    var allowMultiselect: Bool = true
    
    //var newVisitDelegate: NewVisitDelegate?
    var stationSelectDelegate: StationSelectDelegate?
    
    init(traplines: [Trapline], stations: [Station], selectedStations: [Station]) {
        self.traplines = traplines
        self.stations = stations
        self.selectedStations = selectedStations
    }
    
    convenience init(traplines: [Trapline]) {
        
        // by default include all stations from the lines
        var stations = [Station]()
        for trapline in traplines {
            stations.append(contentsOf: trapline.stations)
        }
        
        self.init(traplines: traplines, stations: stations, selectedStations: [Station]())
    }
    
    
}
