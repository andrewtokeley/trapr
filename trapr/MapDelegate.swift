//
//  MapDelegate.swift
//  trapr
//
//  Created by Andrew Tokeley on 2/01/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import MapKit

protocol MapDelegate {
    
    // all optional
    
    func map(_ map: MapViewApi, annotationViewClassAt zoomLevel: ZoomLevel) -> AnyClass?
    func mapHighlightedStations(_ map: MapViewApi) -> [Station]?
    func map(_ map: MapViewApi, didHighlight station: Station)
    func map(_ map: MapViewApi, didUnhighlight station: Station)
}

//MARK: - Default implementations for optional methods
extension MapDelegate {
    
    func map(_ map: MapViewApi, didHighlight station: Station) {
        // do nothing
    }
    
    func map(_ map: MapViewApi, didUnhighlight station: Station) {
        // do nothing
    }
    
    func map(_ map: MapViewApi, annotationViewClassAt zoomLevel: ZoomLevel) -> AnyClass? {
        return StationCircleAnnotationView.self
    }
    
    func mapHighlightedStations(_ map: MapViewApi) -> [Station]? {
        return nil
    }
}
