//
//  MapView.swift
//  trapr
//
//  Created by Andrew Tokeley on 28/12/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import UIKit
import Viperit
import MapKit

//MARK: MapView Class
final class MapView: UserInterface {
    
    fileprivate var SMALL_ANNOTATION_VIEW_IDENTIFIER = "marker_small"
    fileprivate var LARGE_ANNOTATION_VIEW_IDENTIFIER = "marker_big"
    fileprivate var stationMapAnnotations = [StationMapAnnotation]()
    fileprivate var highlightedMapAnnotations = [StationMapAnnotation]()
    fileprivate var annotationStyle = AnnotationStyle.dots
    fileprivate var showingHighlightedOnly: Bool = false
    
    fileprivate var locationManager = CLLocationManager()
    
    //MARK: - Subviews
    lazy var map: MKMapView = {
        let view = MKMapView()
        view.mapType = .satellite
        view.register(StationLargeAnnotationView.self, forAnnotationViewWithReuseIdentifier: self.LARGE_ANNOTATION_VIEW_IDENTIFIER)
        view.register(StationSmallAnnotationView.self, forAnnotationViewWithReuseIdentifier: self.SMALL_ANNOTATION_VIEW_IDENTIFIER)
        self.locationManager.requestWhenInUseAuthorization()
        view.showsUserLocation = true
        view.delegate = self
        return view
    }()
    
    lazy var closeButton: UIBarButtonItem = {
        
        var view = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(closeButtonClick(sender:)))
        
        return view
    }()
    
    lazy var showMenuButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named:"show"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(showMoreMenu(sender:)))
        return button
    }()
    
    //MARK: - UIViewController
    override func loadView() {
        
        super.loadView()
        
        self.view.addSubview(map)
        
        self.navigationItem.leftBarButtonItem = closeButton
        self.navigationItem.rightBarButtonItem = showMenuButton
        
        setConstraints()
    }
    
    private func setConstraints() {
        map.autoPinEdgesToSuperviewEdges()
    }
    
    //MARK: - Events
    
    func closeButtonClick(sender: UIBarButtonItem) {
        presenter.didSelectClose()
    }
    
    func showMoreMenu(sender: UIBarButtonItem) {
        presenter.didSelectMenuButton()
    }
}

//MARK: - MapView API
extension MapView: MapViewApi {
    
    func setVisibleRegionToHighlightedStations() {
        map.showAnnotations(self.highlightedMapAnnotations, animated: true)
    }
    
    func setVisibleRegionToAllStations() {
        map.showAnnotations(self.stationMapAnnotations, animated: true)
    }
    
    func addStationsToMap(stations: [Station], highlightedStations: [Station]?, annotationStyle: AnnotationStyle) {
        
        self.annotationStyle = annotationStyle
        
        stationMapAnnotations.removeAll()
        highlightedMapAnnotations.removeAll()
        
        for station in stations {
            let highlight = highlightedStations?.contains(station) ?? false
            let annotation = StationMapAnnotation(station: station, highlighted: highlight)
            stationMapAnnotations.append(annotation)
            if (highlight) {
                highlightedMapAnnotations.append(annotation)
            }
        }
    }
    
    func setAnnotationStyle(annotationStyle: AnnotationStyle) {
        self.annotationStyle = annotationStyle
        
        // force the map to redraw visible annotations
        if showingHighlightedOnly {
            showOnlyHighlighted()
        } else {
            showAll()
        }
    }
    
    func showOnlyHighlighted() {
        showingHighlightedOnly = true
        self.map.removeAnnotations(stationMapAnnotations)
        self.map.addAnnotations(highlightedMapAnnotations)
    }
    
    func showAll() {
        showingHighlightedOnly = false
        self.map.removeAnnotations(stationMapAnnotations)
        self.map.addAnnotations(stationMapAnnotations)
    }
    
    func setTitle(title: String) {
        self.title = title
    }
    
    func displayMenuOptions(options: [OptionItem]) {
        let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for option in options {
            let action = UIAlertAction(title: option.title, style: option.isDestructive ? .destructive : .default, handler: {
                (action) in
                self.presenter.didSelectMenuItem(title: action.title!)
            })
            action.isEnabled = option.isEnabled
            //action.
            menu.addAction(action)
        }
        
        // always add a cancel
        menu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(menu, animated: true, completion: nil)
    }
}

//MARK: - MKMapViewDelegate
extension MapView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //self.title = String(mapView.region.span.latitudeDelta)
        presenter.didChangeZoomLevel(zoom: mapView.region.span.latitudeDelta)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? StationMapAnnotation else { return nil }

        var view: MKAnnotationView?
        
        if self.annotationStyle == .markers {
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: LARGE_ANNOTATION_VIEW_IDENTIFIER)
                as? StationLargeAnnotationView {
                
                dequeuedView.annotation = annotation
                view = dequeuedView
                
            } else {
                // create a new annotation view
                view = StationLargeAnnotationView(annotation: annotation, reuseIdentifier: LARGE_ANNOTATION_VIEW_IDENTIFIER)
                
            }
        } else if self.annotationStyle == .dots {
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: SMALL_ANNOTATION_VIEW_IDENTIFIER)
                as? StationSmallAnnotationView {
                
                dequeuedView.annotation = annotation
                view = dequeuedView
                
            } else {
                // create a new annotation view
                view = StationSmallAnnotationView(annotation: annotation, reuseIdentifier: SMALL_ANNOTATION_VIEW_IDENTIFIER)
            }
        }
        
        return view
    }
    
}

// MARK: - MapView Viper Components API
private extension MapView {
    var presenter: MapPresenterApi {
        return _presenter as! MapPresenterApi
    }
    var displayData: MapDisplayData {
        return _displayData as! MapDisplayData
    }
}
