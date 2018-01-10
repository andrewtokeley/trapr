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
    case close = 0.008
    case far = 0.02
    case distant = 0.08
}

class StationMapViewController: UIViewController {
    
    var delegate: StationMapDelegate?
    
    fileprivate var stationMapAnnotations = [StationMapAnnotation]()
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
        mapView.backgroundColor = UIColor.clear
        
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
        self.addStationAnnotations()
        self.reload()
    }
    
    private func setConstraints() {
        map.autoPinEdgesToSuperviewEdges()
    }

    // MARK: - User Functions

    /**
    Redraw the map and all its annotations - this will cause a flash but it will reset everything
    */
    func reload(forceRebuildOfAnnotations: Bool = false) {
        
        self.map.removeAnnotations(stationMapAnnotations)
        
        if forceRebuildOfAnnotations {
            self.addStationAnnotations()
        }
        
        self.map.addAnnotations(stationMapAnnotations)
    }

    /**
    Call this if you've changed the underlying Annotations but don't want to do a full reload. Note this won't allow you to add/remove annotations but will make sure each view has the right annotation content and color applied
    */
    func reapplyStylingToAnnotationViews() {
        for annotation in self.stationMapAnnotations {
            
            if let annotationView = map.view(for: annotation) as? CircleAnnotationView {
                
                // Make sure the right highlight colors are applied
                if delegate?.stationMap(self, isHighlighted: annotation.station) ?? false {
                    annotationView.circleTintColor = UIColor.trpMapHighlightedStation
                } else {
                    annotationView.circleTintColor = UIColor.trpMapDefaultStation
                }
            
                // Apply content to annotationView properties
                annotationView.title = delegate?.stationMap(self, textForStation: annotation.station)
                annotationView.innerText = delegate?.stationMap(self, innerTextForStation: annotation.station)
                if let radius = delegate?.stationMap(self, radiusForStation: annotation.station) {
                    if radius != annotationView.radius {
                        annotationView.radius = radius
                    }
                }
            }
        }
    }
  
    func showUserLocation(_ show: Bool) {
        self.locationManager.requestWhenInUseAuthorization()
        self.map.showsUserLocation = show
    }
    
    private var highlightedMapAnnotations: [StationMapAnnotation] {
        
        // find the highlighted annotations
        var annotations = [StationMapAnnotation]()
        if let stations = delegate?.stationMapStations(self) {
            for station in stations {
                if let annotation = self.stationMapAnnotations.first(where: { $0.station.code == station.code }) {
                    annotations.append(annotation)
                }
            }
        }
        return annotations
    }
    
    func setVisibleRegionToHighlightedStations() {
        guard delegate != nil else { return }
        
        map.showAnnotations(self.highlightedMapAnnotations, animated: true)
    }
    
    func setVisibleRegionToAllStations() {
        guard delegate != nil else { return }
        map.showAnnotations(self.stationMapAnnotations, animated: true)
    }
    
    func setVisibleRegionToCentreOfStations(distance: Double) {
        
        // ahem, the "centre"
        let centre = self.stationMapAnnotations[Int(self.stationMapAnnotations.count/2)].coordinate
        let region = MKCoordinateRegionMakeWithDistance(centre, distance, distance)
        map.setRegion(region, animated: false)
    }
    
    //MARK: - Private functions
    
    /**
     Ensure that the
    */
    fileprivate func thinAnnotations() {
        
        let visibleAnnotations = map.annotations(in: map.visibleMapRect)
        var take: Int = 0
        var every: Int = 1
        
        if currentZoomLevel == .distant {
            take = 3
            every = 4
        } else if currentZoomLevel == .far {
            take = 1
            every = 3
        } else if currentZoomLevel == .close {
            take = 0
            every = 1
        }
        
        var i = 0
        for annotation in visibleAnnotations {
            if let stationMapAnnotation = annotation as? StationMapAnnotation {
                let position = i % every
                let view = map.view(for: stationMapAnnotation)
                view?.alpha = position <= take ? 0 : 1
            }
            i += 1
        }
        
    }
    
    /**
    Ask the delegate for the details for each station that will appear on the map (or be hidden)
    */
    private func addStationAnnotations() {
        
        guard delegate != nil else { return }
        
        self.stationMapAnnotations.removeAll()
        
        // get the stations from the delegate
        let stations = delegate!.stationMapStations(self)
        
        for station in stations {
            
            let innerText = delegate!.stationMap(self, innerTextForStation: station)
            let titleText = delegate!.stationMap(self, textForStation: station)
            let annotation = StationMapAnnotation(station: station, titleText: titleText, innerText: innerText)
            
            self.stationMapAnnotations.append(annotation)
        }
    }
}

//MARK: - MKMapViewDelegate
extension StationMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let zoom = map.region.span.latitudeDelta
        delegate?.stationMap(self, didChangeZoomLevel: zoom)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
            if let annotationView = view as? StationAnnotationView {
                
                delegate?.stationMap(self, didSelect: annotationView)
                
                // deselect so that the annotationview is selectable again
                mapView.deselectAnnotation(view.annotation, animated: false)
            }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? StationMapAnnotation else { return nil }
        
        guard delegate != nil else { return nil}
        
        // dequeue the annotation view for this zoom level
        if let view = mapView.dequeueReusableAnnotationView(withIdentifier: String(describing: currentZoomLevel!), for: annotation) as? CircleAnnotationView {
            
            // setting the annotation adds title and inner text to the annotationView, if they're defined on the annotation
            view.annotation = annotation
            
            view.title = delegate?.stationMap(self, textForStation: annotation.station)
            view.innerText = delegate?.stationMap(self, innerTextForStation: annotation.station)
            
            // set the appropriate color based on whether it's selected
            if delegate?.stationMap(self, isHighlighted: annotation.station) ?? false {
                view.circleTintColor = UIColor.trpMapHighlightedStation
            } else {
                view.circleTintColor = UIColor.trpMapDefaultStation
            }

            // ask the delegate for the size of the circle
            if let radius = delegate?.stationMap(self, radiusForStation: annotation.station) {
                if view.radius != radius {
                    view.radius = radius
                }
            }

            return view
        }
        return nil
    }
}
