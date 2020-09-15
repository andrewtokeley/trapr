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

enum AnnotationState {
    case normal
    case highlighted
}

struct MapOptionButton {
    var title: String
    var width: CGFloat = 60
    var isPrimary: Bool = false
    var id: Any?
    var optionType: Any?
}

class StationMapView: UIView {
    
    /// Delegate that controls what Stations the StationMapView should display and how.
    public var delegate: StationMapViewDelegate?
    
    fileprivate var stationMapAnnotations = [StationMapAnnotation]()
    
    fileprivate var lastSelectedMapOptionsButton: RoundedButton?
    
    fileprivate var locationManager = CLLocationManager()
    
    fileprivate func reuseIdentifier(annotationViewIndex: Int) -> String {
        return "view\(annotationViewIndex)"
    }
    
    public var showFilter: Bool = false
    
    fileprivate var showHeatMap: Bool {
        return delegate?.stationMapShowLegend(self) ?? false
    }
    
    //MARK: - UIView
    convenience init(showFilter: Bool, delegate: StationMapViewDelegate) {
        self.init(frame: CGRect.zero)
        self.delegate = delegate
        self.showFilter = showFilter
        loadView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Subviews
    
    private lazy var map: MKMapView = {
        let mapView = MKMapView()
        mapView.mapType = .satellite
        mapView.backgroundColor = UIColor.clear
        
        // only bother trying to register annotationviews if the delegate's been set up
        if let _ = self.delegate {
            
            if let numberOfAnnotations = delegate?.stationMapNumberOfAnnotationViews(self) {
                if numberOfAnnotations > 0 {
                    for i in 0...numberOfAnnotations - 1 {
                        mapView.register(self.delegate?.stationMap(self, annotationViewClassAt: i), forAnnotationViewWithReuseIdentifier: self.reuseIdentifier(annotationViewIndex: i))
                    }
                }
            }
        }
        
        mapView.delegate = self
        
        return mapView
    }()
    
    lazy var mapOptionsStrip: UIToolbar = {
        let view = UIToolbar()
        view.backgroundColor = .white
        return view
    }()
        
//        let all = RoundedButton(title: "All", target: self, action: #selector(mapOptionsButtonClick(sender:)))
//        all.isSelected(true)
//        all.tag = MapOption.trapTypeFilterAll.rawValue
//        lastSelectedMapOptionsButton = all
//        let allButton = UIBarButtonItem(customView: all)
//        allButton.customView?.autoSetDimension(.width, toSize: 60)
//        allButton.customView?.autoSetDimension(.height, toSize: HEIGHT)
//
//        let possumMaster = RoundedButton(title: "POSSUM MASTER", target: self, action: #selector(mapOptionsButtonClick(sender:)))
//        possumMaster.isSelected(false)
//        possumMaster.tag = MapOption.trapTypeFilterPossumMaster.rawValue
//        let possumMasterButton = UIBarButtonItem(customView: possumMaster)
//        possumMasterButton.customView?.autoSetDimension(.width, toSize: 120)
//        possumMasterButton.customView?.autoSetDimension(.height, toSize: HEIGHT)
//
//        let timms = RoundedButton(title: "Timms", target: self, action: #selector(mapOptionsButtonClick(sender:)))
//        timms.isSelected(false)
//        timms.tag = MapOption.trapTypeFilterTimms.rawValue
//        let timmsButton = UIBarButtonItem(customView: timms)
//        timmsButton.customView?.autoSetDimension(.width, toSize: 70)
//        timmsButton.customView?.autoSetDimension(.height, toSize: HEIGHT)
//
//        let doc200 = RoundedButton(title: "Doc200", target: self, action: #selector(mapOptionsButtonClick(sender:)))
//        doc200.isSelected(false)
//        doc200.tag = MapOption.trapTypeFilterDOC200.rawValue
//
//        let doc200Button = UIBarButtonItem(customView: doc200)
//        doc200Button.customView?.autoSetDimension(.width, toSize: 70)
//        doc200Button.customView?.autoSetDimension(.height, toSize: HEIGHT)
//
//        if #available(iOS 14.0, *) {
//            let flexSpace = UIBarButtonItem(systemItem: .flexibleSpace)
//            let fixed = UIBarButtonItem(systemItem: .fixedSpace)
//            fixed.width = 5
//            view.setItems([allButton,
//                           flexSpace,
//                           possumMasterButton,
//                           fixed,
//                           doc200Button,
//                           fixed,
//                           timmsButton], animated: true)
//        } else {
//            view.setItems([allButton, possumMasterButton, doc200Button, timmsButton], animated: true)
//        }
//        return view
//    }()
    
    lazy var heatMapLegend: HeatMapKey = {
        let view = HeatMapKey()
        return view
    }()
    
    //MARK: - Events
    
    @objc private func mapOptionsButtonClick(sender: RoundedButton) {
        
        lastSelectedMapOptionsButton?.isSelected(false)
        sender.isSelected(true)
        lastSelectedMapOptionsButton = sender
        
        delegate?.stationMap(self, optionButtonSelectedAt: sender.tag)
    }
    
    //MARK: - UIView
    private func loadView() {
        
        self.addSubview(map)
        
        if showHeatMap {
            self.addSubview(heatMapLegend)
        }
        
        if showFilter {
            self.addSubview(mapOptionsStrip)
        }
        
        setConstraints()
    }
    
    private func setConstraints() {
        
        let FILTER_HEIGHT: CGFloat = 50
        
        map.autoPinEdge(toSuperviewEdge: .top, withInset: 0)
        map.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        map.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        map.autoPinEdge(toSuperviewEdge: .bottom, withInset: self.showFilter ? FILTER_HEIGHT : 0)
        
        if showHeatMap {
            heatMapLegend.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.spacingMargin)
            heatMapLegend.autoPinEdge(toSuperviewEdge: .top, withInset: LayoutDimensions.spacingMargin)
            heatMapLegend.autoSetDimension(.width, toSize: 80)
            heatMapLegend.autoSetDimension(.height, toSize: 110)
        }
        
        if showFilter {
            mapOptionsStrip.autoPinEdge(toSuperviewEdge: .left)
            mapOptionsStrip.autoPinEdge(toSuperviewEdge: .right)
            mapOptionsStrip.autoPinEdge(.top, to: .bottom, of: map, withOffset: 0)
            mapOptionsStrip.autoPinEdge(toSuperviewEdge: .bottom)
        }
        
    }

    // MARK: - Helpers
    
    /**
     Redraws the legend, asking the delegate what segments and title to use
     */
    private func redrawLegend() {
        if let segments = delegate?.stationMapLegendSegments(self) {
            if let title = delegate?.stationMapLegendTitle(self) {
                self.heatMapLegend.title = title
                self.heatMapLegend.setSegments(segments: segments)
            }
        }
    }

    /**
     Redraw all the option buttons
    */
    public func redrawMapOptions(selectedIndex: Int? = nil) {
        var items = [UIBarButtonItem]()
        
        let HEIGHT: CGFloat = 25
        
        if let numberOfButtons = delegate?.stationMapNumberOfOptionButtons() {
            for i in 0...numberOfButtons - 1 {
                if let option = delegate?.stationMap(self, optionButtonAt: i) {
                    let button = RoundedButton(title: option.title, target: self, action: #selector(mapOptionsButtonClick(sender:)))
                    //button.isSelected(option.isPrimary)
                    
                    // record the index in the tag so we can let the delegate know which button was clicked.
                    button.tag = i
                    
                    // when we first build the buttons, select the primary button
                    if lastSelectedMapOptionsButton == nil || selectedIndex != nil {
                        if i == selectedIndex || (selectedIndex == nil && option.isPrimary) {
                            lastSelectedMapOptionsButton = button
                            button.isSelected(true)
                        }
                    }
                    
                    let buttonItem = UIBarButtonItem(customView: button)
                    buttonItem.customView?.autoSetDimension(.width, toSize: option.width)
                    buttonItem.customView?.autoSetDimension(.height, toSize: HEIGHT)
                    
                    items.append(buttonItem)
                    
                    if #available(iOS 14.0, *) {
                        if option.isPrimary {
                            items.append(UIBarButtonItem(systemItem: .flexibleSpace))
                        } else {
                            let fixed = UIBarButtonItem(systemItem: .fixedSpace)
                            fixed.width = 5
                            items.append(fixed)
                        }
                    }
                }
            }
        }
        
        mapOptionsStrip.items?.removeAll()
        mapOptionsStrip.setItems(items, animated: true)
    }

    
    // MARK: - User Functions

    
    /**
    Redraw the map, including the legend - this will cause a flash but it will reset everything. This does not redraw the map options, use redrawMapOptions() to initiate this.
    */
    func reload(forceRebuildOfAnnotations: Bool = false) {
        
        self.map.removeAnnotations(stationMapAnnotations)
        
        if forceRebuildOfAnnotations {
            self.addStationAnnotations()
        }
        
        self.map.addAnnotations(stationMapAnnotations)
        self.reapplyStylingToAnnotationViews()
        self.redrawLegend()
    }

    /**
    Call this if you've changed the underlying Annotations but don't want to do a full reload. Note this won't allow you to add/remove annotations but will make sure each view has the right annotation content and color applied.
     
    Also rebuilds the legend.
    */
    func reapplyStylingToAnnotationViews() {
        for annotation in self.stationMapAnnotations {
            
            if let annotationView = map.view(for: annotation) as? StationAnnotationView {
                
                let hidden = delegate?.stationMap(self, isHidden: annotation.station) ?? false
                
                if hidden {
                    annotationView.color = .clear
                    annotationView.borderColor = .clear
                    
                } else {
                    
                    annotationView.borderColor = .white
                    
                    // Make sure the right highlight colors are applied
                    if delegate?.stationMap(self, isHighlighted: annotation.station) ?? false {
                        
                        annotationView.color = delegate?.stationMap(self, colourForStation: annotation.station, state: .highlighted) ?? UIColor.trpMapHighlightedStation
                    } else {
                        
                        annotationView.color = delegate?.stationMap(self, colourForStation: annotation.station, state: .normal) ?? UIColor.trpMapDefaultStation
                    }
                }
                
                // Apply content to annotationView properties
                annotationView.subText = delegate?.stationMap(self, textForStation: annotation.station)
                annotationView.innerText = delegate?.stationMap(self, innerTextForStation: annotation.station)
                if let radius = delegate?.stationMap(self, radiusForStation: annotation.station) {
                    if radius != annotationView.radius {
                        annotationView.radius = radius
                    }
                }
            }
        }
        self.redrawLegend()
    }
  
    func showUserLocation(_ show: Bool) {
        self.locationManager.requestWhenInUseAuthorization()
        self.map.showsUserLocation = show
    }
    
    private var highlightedMapAnnotations: [StationMapAnnotation] {
        var stations = [StationMapAnnotation]()
        
        for annotation in self.stationMapAnnotations {
            if delegate!.stationMap(self, isHighlighted: annotation.station) {
                stations.append(annotation)
            }
        }
        return stations
    }
    
    func setVisibleRegionToHighlightedStations() {
        guard delegate != nil else { return }
                        
        map.showAnnotations(self.highlightedMapAnnotations, animated: false)
    }
    
    func setVisibleRegionToAllStations() {
        guard delegate != nil else { return }
        map.showAnnotations(self.stationMapAnnotations, animated: false)
    }
    
    func setVisibleRegionToCentreOfStations(distance: Double) {

        // ahem, the "centre"
        if self.stationMapAnnotations.count > 0 {
            let centre = self.stationMapAnnotations[Int(self.stationMapAnnotations.count/2)]
            setVisibleRegionToStation(station: centre.station, distance: distance)
        }
    }
    
    func setVisibleRegionToStation(station: LocatableEntity, distance: Double) {
        
        // get annotation for this station
        if let annotation = self.stationMapAnnotations.filter({ $0.station.locationId == station.locationId }).first {
            print("zoom to \(annotation.station.locationId)")
            let region = MKCoordinateRegion.init(center: annotation.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
            map.setRegion(region, animated: false)
        }
    }
    
    //MARK: - Private functions
    
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

extension StationMapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        let zoom = map.region.span.latitudeDelta
        delegate?.stationMap(self, didChangeZoomLevel: zoom)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if let annotationView = view as? StationAnnotationView, let annotation = view.annotation as? StationMapAnnotation {
            
            delegate?.stationMap(self, didSelect: annotationView)
            
            // deselect so that the annotationview is selectable again
            mapView.deselectAnnotation(annotation, animated: false)
            
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? StationMapAnnotation else { return nil }
        
        guard delegate != nil else { return nil}
        
        // dequeue the annotation right view
       if let viewIndex = delegate?.stationMap(self, annotationViewIndexForStation: annotation.station) {
        
            if let view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier(annotationViewIndex: viewIndex), for: annotation) as? StationAnnotationView {
                
                // setting the annotation adds title and inner text to the annotationView, if they're defined on the annotation
                (view as? MKAnnotationView)?.annotation = annotation

                // only show a callout if the delegate says so
                (view as? MKAnnotationView)?.canShowCallout = delegate?.stationMap(self, showCalloutForStation: annotation.station) ?? false
                
                view.subText = delegate?.stationMap(self, textForStation: annotation.station)
                view.innerText = delegate?.stationMap(self, innerTextForStation: annotation.station)
                
                // set the appropriate color based on whether it's selected, unselected or hidden
                if delegate?.stationMap(self, isHidden: annotation.station) ?? false {
                    
                    view.color = .clear
                    view.borderColor = .clear
                    
                } else {
                    
                    if delegate?.stationMap(self, isHighlighted: annotation.station) ?? false {
                        view.color = delegate?.stationMap(self, colourForStation: annotation.station, state: .highlighted) ?? UIColor.trpMapHighlightedStation
                    } else {
                        view.color = delegate?.stationMap(self, colourForStation: annotation.station, state: .normal) ?? UIColor.trpMapDefaultStation
                    }
                    view.borderColor = .white
                    
                    // ask the delegate for the size of the circle
                    if let radius = delegate?.stationMap(self, radiusForStation: annotation.station) {
                        if view.radius != radius {
                            view.radius = radius
                        }
                    }
                }
                
                return (view as? MKAnnotationView)
            }
        }
        return nil
    }
}
