//
//  StationSearchDelegate.swift
//  trapr
//
//  Created by Andrew Tokeley on 6/06/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol StationSearchDelegate {
    func stationSearch(_ stationSearch: StationSearchView, didSelectStation station: _Station)
}
