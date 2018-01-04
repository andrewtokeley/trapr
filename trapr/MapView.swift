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

enum ZoomLevel: Double {
    case close = 0.01
    case far = 0.07
    case distant = 1
}

final class MapView: UserInterface {
    
    var delegate: StationMapDelegate?
//    
//    fileprivate var stationMapAnnotations = [StationMapAnnotation]()
//    fileprivate var highlightedMapAnnotations = [StationMapAnnotation]()
//    fileprivate var annotationStyle = AnnotationStyle.dots
//    fileprivate var showingHighlightedOnly: Bool = false
//    
//    fileprivate var toggleHighlightModeEnabled: Bool = false
//    fileprivate var locationManager = CLLocationManager()
//    
//    fileprivate var currentZoomLevel: ZoomLevel {
//        let zoom = map.region.span.latitudeDelta
//        
//        if zoom < ZoomLevel.close.rawValue { return ZoomLevel.close }
//        
//        else if zoom < ZoomLevel.far.rawValue { return ZoomLevel.far }
//        
//        else if zoom <= ZoomLevel.distant.rawValue {
//            return ZoomLevel.distant
//        } else {
//            return ZoomLevel.distant
//        }
//    }
    
    //MARK: - Subviews
    lazy var mapViewControllerHost: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mapViewController: StationMapViewController? = {
        return self.childViewControllers.first as? StationMapViewController
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
        
        self.view.addSubview(mapViewControllerHost)
        
        self.navigationItem.leftBarButtonItem = closeButton
        self.navigationItem.rightBarButtonItem = showMenuButton
        
        setConstraints()
    }
    
    private func setConstraints() {
        mapViewControllerHost.autoPinEdgesToSuperviewEdges()
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
    
    func getMapContainerView() -> UIView {
        return mapViewControllerHost
    }
    
    func showUserLocation(_ show: Bool) {
        mapViewController?.showUserLocation(show)
    }
    
    func setVisibleRegionToHighlightedStations() {
        mapViewController?.setVisibleRegionToHighlightedStations()
    }
    
    func setVisibleRegionToAllStations() {
        mapViewController?.setVisibleRegionToAllStations()
    }
    
    func showOnlyHighlighted() {
        mapViewController?.showOnlyHighlighted()
    }
    
    func showAll() {
        mapViewController?.showAll()
    }
    
    func setTitle(title: String) {
        self.title = title
    }
    
    func enableToggleHighlightMode(_ enable: Bool) {
        mapViewController?.enableToggleHighlightMode(enable)
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
//extension MapView: MKMapViewDelegate {
//
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//
//        if self.toggleHighlightModeEnabled {
//            if let annotationView = view as? StationAnnotationView {
//
//                annotationView.toggleState()
//                if annotationView.state == .highlighted {
//                    delegate?.map(self, didHighlight: annotationView.station)
//                } else if annotationView.state == .unhighlighted {
//                    delegate?.map(self, didUnhighlight: annotationView.station)
//                }
//
//                mapView.deselectAnnotation(view.annotation!, animated: false)
//            }
//        }
//    }
//
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        //self.title = String(mapView.region.span.latitudeDelta)
//        presenter.didChangeZoomLevel(zoom: mapView.region.span.latitudeDelta)
//    }
//
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        guard let annotation = annotation as? StationMapAnnotation else { return nil }
//
//        guard let _ = delegate else { return nil}
//
//        // dequeue the annotation view for this zoom level
//        let view = mapView.dequeueReusableAnnotationView(withIdentifier: String(describing: currentZoomLevel), for: annotation)
//
//        view.annotation = annotation
//
//        // only show the callout if we're not in highlight toggle mode
//        view.canShowCallout = !toggleHighlightModeEnabled
//
//        return view
//    }
//
//}

// MARK: - MapView Viper Components API
private extension MapView {
    var presenter: MapPresenterApi {
        return _presenter as! MapPresenterApi
    }
    var displayData: MapDisplayData {
        return _displayData as! MapDisplayData
    }
}
