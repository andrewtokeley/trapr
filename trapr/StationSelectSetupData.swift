//
//  SelectStationDelegate.swift
//  trapr
//
//  Created by Andrew Tokeley  on 4/10/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

/**
Delegates of the StationSelectModule can implement this protocol to know when new stations are selected
*/
protocol StationSelectDelegate {
    
    /*
     Tells the delegate that new stations have been selected
    */
    func newStationsSelected(stations: [Station])
}

class StationSelectSetupData {
    
    var traplines: [Trapline]
    
    var traplineStations: [Station] {
        //TODO: WTF
        return [Station]()
    }
    /**
     Used for displaying a subset of trapline stations (i.e. when quick navigating to a station for a Route)
    */
    var stations: [Station]
    var selectedStationIds: [String]?
    var allowMultiselect: Bool = true
    
    //var newVisitDelegate: NewVisitDelegate?
    var stationSelectDelegate: StationSelectDelegate?
    
    init(traplines: [Trapline], stations: [Station], selectedStationIds: [String]) {
        self.traplines = traplines
        self.stations = stations
        self.selectedStationIds = selectedStationIds
    }
    
//    convenience init(traplines: [Trapline]) {
//        
//        // by default include all stations from the lines
//        var stations = [Station]()
//        for trapline in traplines {
//            stations.append(contentsOf: trapline.stationIds)
//        }
//        
//        self.init(traplines: traplines, stations: stations, selectedStations: [Station]())
//    }
    
    
}
