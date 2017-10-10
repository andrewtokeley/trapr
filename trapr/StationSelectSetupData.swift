//
//  SelectStationDelegate.swift
//  trapr
//
//  Created by Andrew Tokeley  on 4/10/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol StationSelectDelegate {
    
    func didSelectStation(station: Station)
    
}

class StationSelectSetupData {
    
    var visitSummary: VisitSummary?
    var currentStation: Station?
    var delegate: StationSelectDelegate?
    
    init() {
    }
    
    convenience init(visitSummary: VisitSummary, currentStation: Station, delegate: StationSelectDelegate) {
        self.init()
        self.visitSummary = visitSummary
        self.currentStation = currentStation
        self.delegate = delegate
    }
    
}
