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
    
    /// Must implemet at least this method
    func stationMapStations(_ stationMap: StationMapView) -> [LocatableEntity]
    
    /// Returns whether to show the legend and what scale to use
    func stationMapShowHeatMap(_ stationMap: StationMapView) -> Bool
    
    /// Lets delegates know a filter option has been selected. It is the responsibility of the delegates to decide how to update the map display for this any filter actions.
    func stationMap(_ stationMap: StationMapView, didSelectFilter: MapOption)
    
    /// If showing a legend, this method is called to determine the segments
    func stationMapHeatMapSegments(_ stationMap: StationMapView) -> [Segment]
    
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
    
    func stationMapShowHeatMap(_ stationMap: StationMapView) -> Bool {
        return false
    }
    
    func stationMap(_ stationMap: StationMapView, didSelectFilter: MapOption) {
        // do nothing
    }
    
    /// If showing a legend, this method is called to determine the segments
    func stationMapHeatMapSegments(_ stationMap: StationMapView) -> [Segment] {
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


//protocol StationMapDelegate {
//    
//    // All optional...
//   
//    /// Returns whether to show the legend and what scale to use
//    func stationMapShowHeatMap(_ stationMap: StationMapViewController) -> Bool
//    
//    /// If showing a legend, this method is called to determine the segments
//    func stationMapHeatMapSegments(_ stationMap: StationMapViewController) -> [Segment]
//    
//    /// The colour to use for the annotation
//    func stationMap(_ stationMap: StationMapViewController, colourForStation station: LocatableEntity, state: AnnotationState) -> UIColor
//    
//    func stationMapNumberOfAnnotationViews(_ stationMap: StationMapViewController) -> Int
//    func stationMap(_ stationMap: StationMapViewController, annotationViewClassAt index: Int) -> AnyClass?
//    func stationMap(_ stationMap: StationMapViewController, annotationViewIndexForStation index: LocatableEntity) -> Int
//    
//    func stationMap(_ stationMap: StationMapViewController, annotationViewClassAt zoomLevel: ZoomLevel) -> AnyClass?
//    
//    func stationMap(_ stationMap: StationMapViewController, didChangeZoomLevel zoomLevel: Double)
//    func stationMapStations(_ stationMap: StationMapViewController) -> [LocatableEntity]
//    func stationMap(_ stationMap: StationMapViewController, isHighlighted station: LocatableEntity) -> Bool
//    
//    func stationMap(_ stationMap: StationMapViewController, isHidden station: LocatableEntity) -> Bool
//    
//    
//    func stationMap(_ stationMap: StationMapViewController, radiusForStation station: LocatableEntity) -> Int
//    func stationMap(_ stationMap: StationMapViewController, didSelect annotationView: StationAnnotationView)
//    func stationMap(_ stationMap: StationMapViewController, didHighlight annotationView: StationAnnotationView)
//    func stationMap(_ stationMap: StationMapViewController, didUnhighlight annotationView: StationAnnotationView)
//    func stationMap(_ stationMap: StationMapViewController, textForStation station: LocatableEntity) -> String?
//    func stationMap(_ stationMap: StationMapViewController, innerTextForStation station: LocatableEntity) -> String?
//    func stationMap(_ stationMap: StationMapViewController, showCalloutForStation station: LocatableEntity) -> Bool
//}
//
////MARK: - Default implementations for optional methods
//extension StationMapDelegate {
//    
//    func stationMapShowHeatMap(_ stationMap: StationMapViewController) -> Bool
//    {
//        return false
//    }
//    
//    /// If showing a legend, this method is called to determine the segments
//    func stationMapHeatMapSegments(_ stationMap: StationMapViewController) -> [Segment] {
//        return [Segment]()
//    }
//
//    func stationMap(_ stationMap: StationMapViewController, isHidden station: LocatableEntity) -> Bool {
//        return false
//    }
//    
//    func stationMap(_ stationMap: StationMapViewController, colourForStation station: LocatableEntity, state: AnnotationState) -> UIColor {
//        return .trpMapHighlightedStation
//    }
//    
//    func stationMapNumberOfAnnotationViews(_ stationMap: StationMapViewController) -> Int {
//        return 1
//    }
//    
//    func stationMap(_ stationMap: StationMapViewController, annotationViewClassAt index: Int) -> AnyClass? {
//        return CircleAnnotationView.self
//    }
//
//    func stationMap(_ stationMap: StationMapViewController, annotationViewIndexForStation index: LocatableEntity) -> Int {
//        return 0
//    }
//    
//    func stationMap(_ stationMap: StationMapViewController, showCalloutForStation station: LocatableEntity) -> Bool {
//        return false
//    }
//    
//    func stationMap(_ stationMap: StationMapViewController, radiusForStation station: LocatableEntity) -> Int {
//        return 10
//    }
//    
//    func stationMap(_ stationMap: StationMapViewController, didSelect annotationView: StationAnnotationView) {
//        //do nothing
//    }
//    
//    func stationMap(_ stationMap: StationMapViewController, textForStation station: LocatableEntity) -> String? {
//        return nil
//    }
//    
//    func stationMap(_ stationMap: StationMapViewController, innerTextForStation station: LocatableEntity) -> String? {
//        return nil
//    }
//    
//    func stationMap(_ stationMap: StationMapViewController, didChangeZoomLevel zoomLevel: Double) {
//        //do nothing
//    }
//    
//    func stationMap(_ stationMap: StationMapViewController, isHighlighted station: LocatableEntity) -> Bool {
//        return false
//    }
//    
//    func stationMapStations(_ stationMap: StationMapViewController) -> [LocatableEntity] {
//        return [Station]()
//    }
//    
//    func stationMap(_ stationMap: StationMapViewController, didHighlight annotationView: StationAnnotationView) {
//        //do nothing
//    }
//    
//    func stationMap(_ stationMap: StationMapViewController, didUnhighlight annotationView: StationAnnotationView) {
//        //do nothing
//    }
//    
//    func stationMap(_ stationMap: StationMapViewController, annotationViewClassAt zoomLevel: ZoomLevel) -> AnyClass? {
//        return CircleAnnotationView.self
//    }
//    
//}

