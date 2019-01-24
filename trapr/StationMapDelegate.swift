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
    func stationMap(_ stationMap: StationMapViewController, annotationViewIndexForStation index: LocatableEntity) -> Int
    
    func stationMap(_ stationMap: StationMapViewController, annotationViewClassAt zoomLevel: ZoomLevel) -> AnyClass?
    
    func stationMap(_ stationMap: StationMapViewController, didChangeZoomLevel zoomLevel: Double)
    func stationMapStations(_ stationMap: StationMapViewController) -> [LocatableEntity]
    func stationMap(_ stationMap: StationMapViewController, isHighlighted station: LocatableEntity) -> Bool
    
    func stationMap(_ stationMap: StationMapViewController, radiusForStation station: LocatableEntity) -> Int
    func stationMap(_ stationMap: StationMapViewController, didSelect annotationView: StationAnnotationView)
    func stationMap(_ stationMap: StationMapViewController, didHighlight annotationView: StationAnnotationView)
    func stationMap(_ stationMap: StationMapViewController, didUnhighlight annotationView: StationAnnotationView)
    func stationMap(_ stationMap: StationMapViewController, textForStation station: LocatableEntity) -> String?
    func stationMap(_ stationMap: StationMapViewController, innerTextForStation station: LocatableEntity) -> String?
    func stationMap(_ stationMap: StationMapViewController, showCalloutForStation station: LocatableEntity) -> Bool
}

//MARK: - Default implementations for optional methods
extension StationMapDelegate {
    
    func stationMapNumberOfAnnotationViews(_ stationMap: StationMapViewController) -> Int {
        return 1
    }
    
    func stationMap(_ stationMap: StationMapViewController, annotationViewClassAt index: Int) -> AnyClass? {
        return CircleAnnotationView.self
    }

    func stationMap(_ stationMap: StationMapViewController, annotationViewIndexForStation index: LocatableEntity) -> Int {
        return 0
    }
    
    func stationMap(_ stationMap: StationMapViewController, showCalloutForStation station: LocatableEntity) -> Bool {
        return false
    }
    
    func stationMap(_ stationMap: StationMapViewController, radiusForStation station: LocatableEntity) -> Int {
        return 10
    }
    
    func stationMap(_ stationMap: StationMapViewController, didSelect annotationView: StationAnnotationView) {
        //do nothing
    }
    
    func stationMap(_ stationMap: StationMapViewController, textForStation station: LocatableEntity) -> String? {
        return nil
    }
    
    func stationMap(_ stationMap: StationMapViewController, innerTextForStation station: LocatableEntity) -> String? {
        return nil
    }
    
    func stationMap(_ stationMap: StationMapViewController, didChangeZoomLevel zoomLevel: Double) {
        //do nothing
    }
    
    func stationMap(_ stationMap: StationMapViewController, isHighlighted station: LocatableEntity) -> Bool {
        return false
    }
    
    func stationMapStations(_ stationMap: StationMapViewController) -> [LocatableEntity] {
        return [_Station]()
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

