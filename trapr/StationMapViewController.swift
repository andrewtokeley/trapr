//
//  StationMapViewController.swift
//  trapr
//
//  Created by Andrew Tokeley on 3/01/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit
import MapKit

enum StationMapZoomLevel: Double {
    case close = 0.01
    case far = 0.05
    case distant = 1
}

class StationMapViewController: UIViewController {
    
    var delegate: StationMapDelegate?
    
    fileprivate var stationMapAnnotations = [StationMapAnnotation]()
    fileprivate var highlightedMapAnnotations = [StationMapAnnotation]()
    fileprivate var showingHighlightedOnly: Bool = false
    
    fileprivate var toggleHighlightModeEnabled: Bool = false
    fileprivate var locationManager = CLLocationManager()
    
    fileprivate var previousZoomLevel: StationMapZoomLevel?
    
    fileprivate var currentZoomLevel: StationMapZoomLevel? {
        
        let zoom = map.region.span.latitudeDelta
        
        if zoom < StationMapZoomLevel.close.rawValue { return StationMapZoomLevel.close }
            
        else if zoom < StationMapZoomLevel.far.rawValue { return StationMapZoomLevel.far }
            
        else if zoom <= StationMapZoomLevel.distant.rawValue {
            return StationMapZoomLevel.distant
        } else {
            return StationMapZoomLevel.distant
        }
    }
    
    //MARK: - Subviews
    
    lazy var map: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = .satellite
        
        // only bother trying to register annotationviews if the delegate's been set up
        if let _ = self.delegate {
            mapView.register(self.delegate?.stationMap(self, annotationViewClassAt: .close), forAnnotationViewWithReuseIdentifier: String(describing: ZoomLevel.close))
            
            mapView.register(self.delegate?.stationMap(self, annotationViewClassAt: .far), forAnnotationViewWithReuseIdentifier: String(describing: ZoomLevel.far))
            
            mapView.register(self.delegate?.stationMap(self, annotationViewClassAt: .distant), forAnnotationViewWithReuseIdentifier: String(describing: ZoomLevel.distant))
        }
        
        mapView.delegate = self
        
        return mapView
    }()
    
    //MARK: - UIViewController
    override func loadView() {
        
        super.loadView()
        
        self.view.addSubview(map)
        setConstraints()

        // populate the map
        self.addStationsToMap()
        self.reload()
    }
    
    private func setConstraints() {
        map.autoPinEdgesToSuperviewEdges()
    }

    // MARK: - User Functions

    /**
    Redraw the map and all its annotations
    */
    func reload() {
        if showingHighlightedOnly {
            self.map.removeAnnotations(stationMapAnnotations)
            self.map.addAnnotations(highlightedMapAnnotations)
        } else {
            self.map.removeAnnotations(stationMapAnnotations)
            self.map.addAnnotations(stationMapAnnotations)
        }
    }
    
    func showUserLocation(_ show: Bool) {
        self.locationManager.requestWhenInUseAuthorization()
        self.map.showsUserLocation = show
    }
    
    func setVisibleRegionToHighlightedStations() {
        guard delegate != nil else { return }
        map.showAnnotations(self.highlightedMapAnnotations, animated: true)
    }
    
    func setVisibleRegionToAllStations() {
        guard delegate != nil else { return }
        map.showAnnotations(self.stationMapAnnotations, animated: true)
    }
    
    func showOnlyHighlighted() {
        showingHighlightedOnly = true
        reload()
    }
    
    func showAll() {
        showingHighlightedOnly = false
        reload()
    }
    
    func enableToggleHighlightMode(_ enable: Bool) {
        self.toggleHighlightModeEnabled = enable
    }
    
    //MARK: - Private functions
    
    private func addStationsToMap() {
        
        guard delegate != nil else { return }
        
        stationMapAnnotations.removeAll()
        highlightedMapAnnotations.removeAll()
        
        // get the stations from the delegate
        let stations = delegate!.stationMapStations(self)
        
        for station in stations {
            let highlight = delegate!.stationMap(self, isHighlighted: station)
            let annotation = StationMapAnnotation(station: station, highlighted: highlight)
            
            stationMapAnnotations.append(annotation)
            if (highlight) {
                highlightedMapAnnotations.append(annotation)
            }
        }
    }
}

//MARK: - MKMapViewDelegate
extension StationMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if self.toggleHighlightModeEnabled {
            if let annotationView = view as? StationAnnotationView {
                
                annotationView.toggleState()
                if annotationView.state == .highlighted {
                    delegate?.stationMap(self, didHighlight: annotationView.station)
                } else if annotationView.state == .unhighlighted {
                    delegate?.stationMap(self, didUnhighlight: annotationView.station)
                }
                
                mapView.deselectAnnotation(view.annotation!, animated: false)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        if currentZoomLevel != previousZoomLevel {
            previousZoomLevel = currentZoomLevel
            reload()
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? StationMapAnnotation else { return nil }
        
        guard delegate != nil else { return nil}
        
        // dequeue the annotation view for this zoom level
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: String(describing: currentZoomLevel!), for: annotation)
        
        view.annotation = annotation
        
        // only show the callout if we're not in highlight toggle mode
        view.canShowCallout = !toggleHighlightModeEnabled
        
        return view
    }
}
