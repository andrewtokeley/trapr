//
//  SelectStationDelegate.swift
//  trapr
//
//  Created by Andrew Tokeley  on 4/10/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol SelectStationDelegate {
    
    func didSelectStation(station: Station)
    
}

class SelectStationSetUpData {
    
    var currentStation: Station?
    var delegate: SelectStationDelegate?
    
    init() {
    }
    
    convenience init(currentStation: Station, delegate: SelectStationDelegate) {
        self.init()
        self.currentStation = currentStation
        self.delegate = delegate
    }
    
}
