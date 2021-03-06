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
    
    var delegate: StationMapViewDelegate?
    
    //MARK: - Subviews
    
    public lazy var mapView: StationMapView = {
        let view = StationMapView(showFilter: false, delegate: self.presenter as! MapPresenter)
        view.showUserLocation(true)
        return view
    }()
    
//    lazy var mapViewControllerHost: UIView = {
//        let view = UIView()
//        return view
//    }()
//
//    lazy var mapViewController: StationMapViewController? = {
//        return self.children.first as? StationMapViewController
//    }()
    
    lazy var closeButton: UIBarButtonItem = {
        
        var view = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(closeButtonClick(sender:)))
        
        return view
    }()
    
    lazy var showMenuButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named:"show"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(showMoreMenu(sender:)))
        return button
    }()
    
    //MARK: - UIViewController
    override func loadView() {
        
        super.loadView()
        
        self.view.addSubview(mapView)
        
        self.navigationItem.leftBarButtonItem = closeButton
        
        setConstraints()
    }
    
    private func setConstraints() {
        mapView.autoPinEdgesToSuperviewEdges()
    }
    
    //MARK: - Events
    
    @objc func closeButtonClick(sender: UIBarButtonItem) {
        presenter.didSelectClose()
    }
    
    @objc func showMoreMenu(sender: UIBarButtonItem) {
        presenter.didSelectMenuButton()
    }
}

//MARK: - MapView API
extension MapView: MapViewApi {
    
//    func getMapContainerView() -> UIView {
//        return mapViewControllerHost
//    }
//
//    func showUserLocation(_ show: Bool) {
//        mapViewController?.showUserLocation(show)
//    }
    
    func loadMap() {
        mapView.reload(forceRebuildOfAnnotations: true)
    }
    
    func setVisibleRegionToHighlightedStations() {
        mapView.setVisibleRegionToHighlightedStations()
    }
    
    func setVisibleRegionToAllStations() {
        mapView.setVisibleRegionToAllStations()
    }
    
//    func setVisibleRegionToStation(station: Station, distance: CLLocationDistance) {
//        mapViewController?.setVisibleRegionToStation(station: station, distance: distance)
//    }
    
    func showOnlyHighlighted() {
        //mapViewController?.showOnlyHighlighted()
    }

    func showAll() {
        //mapViewController?.showAll()
    }
    
    func reapplyStylingToAnnotationViews() {
        mapView.reapplyStylingToAnnotationViews()
    }
    
    func enableToggleHighlightMode(_ enable: Bool) {
        //mapViewController?.enableToggleHighlightMode(enable)
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


// MARK: - MapView Viper Components API
private extension MapView {
    var presenter: MapPresenterApi {
        return _presenter as! MapPresenterApi
    }
    var displayData: MapDisplayData {
        return _displayData as! MapDisplayData
    }
}
