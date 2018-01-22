//
//  StationMapDelegate.swift
//  trapr
//
//  Created by Andrew Tokeley on 3/01/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol StationMapDelegate {
    
    // Optional...
   
    func stationMapNumberOfAnnotationViews(_ stationMap: StationMapViewController) -> Int
    func stationMap(_ stationMap: StationMapViewController, annotationViewClassAt index: Int) -> AnyClass?
    func stationMap(_ stationMap: StationMapViewController, annotationViewIndexForStation index: Station) -> Int
    
    func stationMap(_ stationMap: StationMapViewController, annotationViewClassAt zoomLevel: ZoomLevel) -> AnyClass?
    
    func stationMap(_ stationMap: StationMapViewController, didChangeZoomLevel zoomLevel: Double)
    func stationMapStations(_ stationMap: StationMapViewController) -> [Station]
    func stationMap(_ stationMap: StationMapViewController, isHighlighted station: Station) -> Bool
    
    func stationMap(_ stationMap: StationMapViewController, radiusForStation station: Station) -> Int
    func stationMap(_ stationMap: StationMapViewController, didSelect annotationView: StationAnnotationView)
    func stationMap(_ stationMap: StationMapViewController, didHighlight annotationView: StationAnnotationView)
    func stationMap(_ stationMap: StationMapViewController, didUnhighlight annotationView: StationAnnotationView)
    func stationMap(_ stationMap: StationMapViewController, textForStation station: Station) -> String?
    func stationMap(_ stationMap: StationMapViewController, innerTextForStation station: Station) -> String?
    func stationMap(_ stationMap: StationMapViewController, showCalloutForStation station: Station) -> Bool
}

//MARK: - Default implementations for optional methods
extension StationMapDelegate {
    
    func stationMapNumberOfAnnotationViews(_ stationMap: StationMapViewController) -> Int {
        return 1
    }
    
    func stationMap(_ stationMap: StationMapViewController, annotationViewClassAt index: Int) -> AnyClass? {
        return CircleAnnotationView.self
    }
    
    func stationMap(_ stationMap: StationMapViewController, annotationViewIndexForStation index: Station) -> Int {
        return 0
    }
    
    func stationMap(_ stationMap: StationMapViewController, showCalloutForStation station: Station) -> Bool {
        return false
    }
    
    func stationMap(_ stationMap: StationMapViewController, radiusForStation station: Station) -> Int {
        return 10
    }
    
    func stationMap(_ stationMap: StationMapViewController, didSelect annotationView: StationAnnotationView) {
        //do nothing
    }
    
    func stationMap(_ stationMap: StationMapViewController, textForStation station: Station) -> String? {
        return nil
    }
    
    func stationMap(_ stationMap: StationMapViewController, innerTextForStation station: Station) -> String? {
        return nil
    }
    
    func stationMap(_ stationMap: StationMapViewController, didChangeZoomLevel zoomLevel: Double) {
        //do nothing
    }
    
    func stationMap(_ stationMap: StationMapViewController, isHighlighted station: Station) -> Bool {
        return false
    }
    
    func stationMapStations(_ stationMap: StationMapViewController) -> [Station] {
        return [Station]()
    }
    
    func stationMap(_ stationMap: StationMapViewController, didHighlight annotationView: StationAnnotationView) {
        //do nothing
    }
    
    func stationMap(_ stationMap: StationMapViewController, didUnhighlight annotationView: StationAnnotationView) {
        //do nothing
    }
    
    func stationMap(_ stationMap: StationMapViewController, annotationViewClassAt zoomLevel: ZoomLevel) -> AnyClass? {
        return CircleAnnotationView.self
    }
}

