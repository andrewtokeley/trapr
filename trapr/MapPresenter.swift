//
//  MapPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley on 28/12/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit
import MapKit

enum AnnotationStyle {
    case dots
    case markers
}

enum MapMenuItems: String {
    case showAll = "Show all stations"
    case showHighlighted = "Show route stations only"
    case listMissing = "List Missing"
}

// MARK: - MapPresenter Class
final class MapPresenter: Presenter {
    
    fileprivate var annotationStyle = AnnotationStyle.markers
    fileprivate var stations = [LocatableEntity]()
    fileprivate var highlightedStations: [LocatableEntity]?
    fileprivate var showingHighlightedOnly: Bool = false
     
    //MARK: - Helpers
    fileprivate func annotationStyleForZoomLevel(zoom: Double) -> AnnotationStyle {
        return zoom < 0.01 ? .markers : .dots
    }
    
    //MARK: - Presenter
    
    
    
    override func setupView(data: Any) {
        
        _view.setTitle(title: "Map")
        
        if let setup = data as? MapSetupData {
            
            self.stations = setup.stations
            self.highlightedStations = setup.highlightedStations
            self.showingHighlightedOnly = setup.showHighlightedOnly
        
            router.addMapAsChildView(containerView: view.getMapContainerView())
            
            view.setVisibleRegionToAllStations()
            view.showUserLocation(true)
        }
    }
}

// MARK: - MapPresenter API
extension MapPresenter: MapPresenterApi {
    
    func didSelectStationOnMap(stationId: String) {
        interactor.retrieveStationsToHighlight(selectedStationId: stationId)
    }
    
    func didSelectClose() {
        view.viewController.dismiss(animated: true, completion: nil)
    }
    
    func didChangeZoomLevel(zoom: Double) {
//
//        let styleForZoom = self.annotationStyleForZoomLevel(zoom: zoom)
//
//        if self.annotationStyle != styleForZoom {
//            self.annotationStyle =  styleForZoom
//            print("change style \(styleForZoom)")
//            view.setAnnotationStyle(annotationStyle: self.annotationStyle)
//        }
        
    }
    
    func didSelectToViewHighlightedOnly() {
        showingHighlightedOnly = true
        view.showOnlyHighlighted()
    }
    
    func didSelectToViewAll() {
        showingHighlightedOnly = false
        view.showAll()
    }
    
    func didSelectMenuButton() {
        
        var options: [OptionItem]
        
        if self.showingHighlightedOnly {
            options = [OptionItem(title: MapMenuItems.showAll.rawValue, isEnabled: true)]
        } else {
            options = [OptionItem(title: MapMenuItems.showHighlighted.rawValue, isEnabled: true)]
        }
        
        options.append(OptionItem(title: MapMenuItems.listMissing.rawValue, isEnabled: true))
        
        view.displayMenuOptions(options: options)
    }
    
    func didSelectMenuItem(title: String) {
        if title == MapMenuItems.showAll.rawValue {
            view.showAll()
            showingHighlightedOnly = false
        }
        if title == MapMenuItems.showHighlighted.rawValue {
            view.showOnlyHighlighted()
            showingHighlightedOnly = true
        }
        
//        if title == MapMenuItems.listMissing.rawValue {
//            let missing = ServiceFactory.sharedInstance.stationService.getMissingStations()
//            print(missing)
//        }
    }
    
    func didFetchStationsToHighlight(stations: [LocatableEntity]) {
        self.highlightedStations = stations
        view.reapplyStylingToAnnotationViews()
    }
}

extension MapPresenter: StationMapDelegate {
//    func stationMap(_ stationMap: StationMapViewController, showCalloutForStation station: LocatableEntity) -> Bool {
//        <#code#>
//    }
//
//    func stationMap(_ stationMap: StationMapViewController, innerTextForStation station: LocatableEntity) -> String? {
//        return nil
//    }
    
    
    func stationMap(_ stationMap: StationMapViewController, didSelect annotationView: StationAnnotationView) {
        
        // Highlight all the stations on the same trapline
        let annotation = (annotationView as? MKAnnotationView)?.annotation as? StationMapAnnotation
        if let stationId = annotation?.station.locationId {
            
            self.didSelectStationOnMap(stationId: stationId)

        }
    }
    
    func stationMap(_ stationMap: StationMapViewController, textForStation station: LocatableEntity) -> String? {
        if (self.highlightedStations?.contains(where: {$0.locationId == station.locationId } ) ?? false) {
            return station.subTitle
        }
        return nil
    }
    
    func stationMap(_ stationMap: StationMapViewController, radiusForStation station: LocatableEntity) -> Int {
        return 5
    }
    
    func stationMap(_ stationMap: StationMapViewController, annotationViewClassAt zoomLevel: ZoomLevel) -> AnyClass? {
        return CircleAnnotationView.self
    }
    
    func stationMapStations(_ stationMap: StationMapViewController) -> [LocatableEntity] {
        return self.stations
    }
    
    func stationMap(_ stationMap: StationMapViewController, isHighlighted station: LocatableEntity) -> Bool {
        return self.highlightedStations?.contains(where: {$0.locationId == station.locationId } ) ?? false
    }
    
//    func stationMap(_ stationMap: StationMapViewController, textForStation station: Station) -> String? {
//        return station.longCode
//
//    }
    
    
}

// MARK: - Map Viper Components
private extension MapPresenter {
    var view: MapViewApi {
        return _view as! MapViewApi
    }
    var interactor: MapInteractorApi {
        return _interactor as! MapInteractorApi
    }
    var router: MapRouterApi {
        return _router as! MapRouterApi
    }
}
