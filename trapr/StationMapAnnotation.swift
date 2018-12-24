//
//  StationMapAnnotation.swift
//  trapr
//
//  Created by Andrew Tokeley on 29/12/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import MapKit

class StationMapAnnotation: NSObject, MKAnnotation {
    
    /**
    Title of the annotation - typically appears underneath the annotation view
    */
    let title: String?
    
    /**
    Inner text of the annotation, if supported, appears inside the annotation view
    */
    let innerText: String?
    
    /**
    Coordinates of the annotation that control where on the map it's view appear
    */
    let coordinate: CLLocationCoordinate2D
    
    /**
    Subtitle of the annotation, typically only used on the callout
    */
    var subtitle: String?
    
    /**
    The Station that the annotation view represents. This property can not be nil.
    */
    //var station: Station!
    var station: LocatableEntity
    
    /**
    Initialise the annotation with content to display
    */
    init(station: LocatableEntity, titleText: String? = nil, innerText: String? = nil) {
        self.station = station
        self.innerText = innerText
        self.title = titleText
        self.coordinate = CLLocationCoordinate2D(latitude: station.latitude ?? 0, longitude: station.longitude ?? 0)
        print("\(station.latitude ?? 0),\(station.longitude ?? 0)")
        // not used at the moment
        self.subtitle = nil
        
        super.init()
    }
    
    
}
