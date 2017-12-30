//
//  StationMapAnnotation.swift
//  trapr
//
//  Created by Andrew Tokeley on 29/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import MapKit

class StationMapAnnotation: NSObject, MKAnnotation {
    
    let title: String?
    let coordinate: CLLocationCoordinate2D
    var subtitle: String?
    var highlighted: Bool
    
    init(station: Station, highlighted: Bool) {
        self.highlighted = highlighted
        self.title = station.longCode
        self.coordinate = CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)
        if station.traps.count > 0 {
            self.subtitle = "\(station.traps.count) traps"
        } else {
            self.subtitle = "No traps"
        }
        super.init()
    }
    
    
}
