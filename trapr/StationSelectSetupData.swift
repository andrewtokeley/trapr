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
    var selectedStations: [Station]?
    var showAllStations: Bool = false
    var allowMultiselect: Bool = true
    
    var newVisitDelegate: NewVisitDelegate?
    var stationSelectDelegate: StationSelectDelegate?
    
    init(traplines: [Trapline]) {
        self.traplines = traplines
    }
    
    convenience init(traplines: [Trapline], selectedStations: [Station]) {
        self.init(traplines: traplines)
        self.selectedStations = selectedStations
    }
}
