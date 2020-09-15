//
//  StationMapDelegate.swift
//  trapr
//
//  Created by Andrew Tokeley on 3/01/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

protocol StationMapViewDelegate {
    
    func stationMapNumberOfOptionButtons() -> Int
    func stationMap(_ stationMap: StationMapView, optionButtonAt index: Int) -> MapOptionButton?
    func stationMap(_ stationMap: StationMapView, optionButtonSelectedAt index: Int)
    
    /// Must implemet at least this method
    func stationMapStations(_ stationMap: StationMapView) -> [LocatableEntity]
    
    /// Returns whether to show the legend and what scale to use
    func stationMapShowLegend(_ stationMap: StationMapView) -> Bool
    
    func stationMapLegendTitle(_ stationMap: StationMapView) -> String?
    
    /// If showing a legend, this method is called to determine the segments
    func stationMapLegendSegments(_ stationMap: StationMapView) -> [Segment]
    
    /// Lets delegates know a filter option has been selected. It is the responsibility of the delegates to decide how to update the map display for this any filter actions.
    //func stationMap(_ stationMap: StationMapView, didSelectFilter: MapOption)
    
    /// The colour to use for the annotation
    func stationMap(_ stationMap: StationMapView, colourForStation station: LocatableEntity, state: AnnotationState) -> UIColor
    
    func stationMapNumberOfAnnotationViews(_ stationMap: StationMapView) -> Int
    func stationMap(_ stationMap: StationMapView, annotationViewClassAt index: Int) -> AnyClass?
    func stationMap(_ stationMap: StationMapView, annotationViewIndexForStation index: LocatableEntity) -> Int
    
    func stationMap(_ stationMap: StationMapView, annotationViewClassAt zoomLevel: ZoomLevel) -> AnyClass?
    
    func stationMap(_ stationMap: StationMapView, didChangeZoomLevel zoomLevel: Double)
    func stationMap(_ stationMap: StationMapView, isHighlighted station: LocatableEntity) -> Bool
    
    func stationMap(_ stationMap: StationMapView, isHidden station: LocatableEntity) -> Bool
    
    
    func stationMap(_ stationMap: StationMapView, radiusForStation station: LocatableEntity) -> Int
    func stationMap(_ stationMap: StationMapView, didSelect annotationView: StationAnnotationView)
    func stationMap(_ stationMap: StationMapView, didHighlight annotationView: StationAnnotationView)
    func stationMap(_ stationMap: StationMapView, didUnhighlight annotationView: StationAnnotationView)
    func stationMap(_ stationMap: StationMapView, textForStation station: LocatableEntity) -> String?
    func stationMap(_ stationMap: StationMapView, innerTextForStation station: LocatableEntity) -> String?
    func stationMap(_ stationMap: StationMapView, showCalloutForStation station: LocatableEntity) -> Bool
}

//MARK: - Default implementations for optional methods
extension StationMapViewDelegate {
    
    func stationMapNumberOfOptionButtons() -> Int {
        return 0
    }
    
    func stationMap(_ stationMap: StationMapView, optionButtonAt index: Int) -> MapOptionButton? {
        return nil
    }
    
    func stationMap(_ stationMap: StationMapView, optionButtonSelectedAt index: Int) {
        // do nothing
    }
    
//    func stationMap(_ stationMap: StationMapView, didSelectFilter: MapOption) {
//        // do nothing
//    }
    
    // MARK: - Legend
    
    func stationMapShowLegend(_ stationMap: StationMapView) -> Bool {
        return false
    }
    
    func stationMapLegendTitle(_ stationMap: StationMapView) -> String? {
        return nil
    }
    
    /// If showing a legend, this method is called to determine the segments
    func stationMapLegendSegments(_ stationMap: StationMapView) -> [Segment] {
        return [Segment]()
    }

    func stationMap(_ stationMap: StationMapView, isHidden station: LocatableEntity) -> Bool {
        return false
    }
    
    func stationMap(_ stationMap: StationMapView, colourForStation station: LocatableEntity, state: AnnotationState) -> UIColor {
        return .trpMapHighlightedStation
    }
    
    func stationMapNumberOfAnnotationViews(_ stationMap: StationMapView) -> Int {
        return 1
    }
    
    func stationMap(_ stationMap: StationMapView, annotationViewClassAt index: Int) -> AnyClass? {
        return CircleAnnotationView.self
    }

    func stationMap(_ stationMap: StationMapView, annotationViewIndexForStation index: LocatableEntity) -> Int {
        return 0
    }
    
    func stationMap(_ stationMap: StationMapView, showCalloutForStation station: LocatableEntity) -> Bool {
        return false
    }
    
    func stationMap(_ stationMap: StationMapView, radiusForStation station: LocatableEntity) -> Int {
        return 10
    }
    
    func stationMap(_ stationMap: StationMapView, didSelect annotationView: StationAnnotationView) {
        //do nothing
    }
    
    func stationMap(_ stationMap: StationMapView, textForStation station: LocatableEntity) -> String? {
        return nil
    }
    
    func stationMap(_ stationMap: StationMapView, innerTextForStation station: LocatableEntity) -> String? {
        return nil
    }
    
    func stationMap(_ stationMap: StationMapView, didChangeZoomLevel zoomLevel: Double) {
        //do nothing
    }
    
    func stationMap(_ stationMap: StationMapView, isHighlighted station: LocatableEntity) -> Bool {
        return false
    }
    
    func stationMapStations(_ stationMap: StationMapView) -> [LocatableEntity] {
        return [Station]()
    }
    
    func stationMap(_ stationMap: StationMapView, didHighlight annotationView: StationAnnotationView) {
        //do nothing
    }
    
    func stationMap(_ stationMap: StationMapView, didUnhighlight annotationView: StationAnnotationView) {
        //do nothing
    }
    
    func stationMap(_ stationMap: StationMapView, annotationViewClassAt zoomLevel: ZoomLevel) -> AnyClass? {
        return CircleAnnotationView.self
    }
}
