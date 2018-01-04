//
//  StationMapDelegate.swift
//  trapr
//
//  Created by Andrew Tokeley on 3/01/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol StationMapDelegate {
    // all optional
    
    func stationMapStations(_ stationMap: StationMapViewController) -> [Station]
    func stationMap(_ stationMap: StationMapViewController, isHighlighted station: Station) -> Bool
    func stationMap(_ stationMap: StationMapViewController, annotationViewClassAt zoomLevel: ZoomLevel) -> AnyClass?
    func stationMap(_ stationMap: StationMapViewController, didHighlight station: Station)
    func stationMap(_ stationMap: StationMapViewController, didUnhighlight station: Station)
}

//MARK: - Default implementations for optional methods
extension StationMapDelegate {
    
    func stationMap(_ stationMap: StationMapViewController, isHighlighted station: Station) -> Bool {
        return false
    }
    
    func stationMapStations(_ stationMap: StationMapViewController) -> [Station] {
        return [Station]()
    }
    
    func stationMap(_ stationMap: StationMapViewController, didHighlight station: Station) {
        // do nothing
    }
    
    func stationMap(_ stationMap: StationMapViewController, didUnhighlight station: Station) {
        // do nothing
    }
    
    func stationMap(_ stationMap: StationMapViewController, annotationViewClassAt zoomLevel: ZoomLevel) -> AnyClass? {
        return StationSmallAnnotationView.self
    }
}

