//
//  RouteDashboardPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley on 2/01/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - RouteDashboardPresenter Class
final class RouteDashboardPresenter: Presenter {
    
    var stations: [Station]!
    var highlightedStations: [Station]?
    
    override func setupView(data: Any) {
        
        view.displayTitle("Route")
        
        if let setupData = data as? RouteDashboardSetup {
            
            view.displayRouteName(setupData.route?.name)
            
            self.stations = ServiceFactory.sharedInstance.stationService.getAll()
            if let _ = setupData.route?.stations {
                self.highlightedStations = Array(setupData.route!.stations)
            }
        }
    }

    override func viewHasLoaded() {
        router.addMapAsChildView(containerView: view.getMapContainerView())
    }
    
    override func viewIsAboutToAppear() {
        view.displayStationsOnMap(stations: self.stations, highlightedStations: self.highlightedStations)
    }
}

extension RouteDashboardPresenter: StationMapDelegate {
    
    func stationMapStations(_ stationMap: StationMapViewController) -> [Station] {
        return self.stations
    }
    
    func stationMap(_ stationMap: StationMapViewController, isHighlighted station: Station) -> Bool {
        return self.highlightedStations?.contains(station) ?? false
    }

    func stationMap(_ stationMap: StationMapViewController, annotationViewClassAt zoomLevel: ZoomLevel) -> AnyClass? {
        if zoomLevel == .close {
            return StationLargeAnnotationView.self
        } else {
            return StationSmallAnnotationView.self
        }
    }
    
    func stationMap(_ stationMap: StationMapViewController, didHighlight station: Station) {
        // add to highlighted stations
        self.highlightedStations?.append(station)
        if let _ = highlightedStations {
            view.displayRouteName(ServiceFactory.sharedInstance.stationService.getDescription(stations: self.highlightedStations!, includeStationCodes: true))
        }
    }
    
    func stationMap(_ stationMap: StationMapViewController, didUnhighlight station: Station) {
        if let index = self.highlightedStations?.index(of: station) {
            self.highlightedStations?.remove(at: index)
            if let _ = highlightedStations {
                view.displayRouteName(ServiceFactory.sharedInstance.stationService.getDescription(stations: self.highlightedStations!, includeStationCodes: true))
            }
        }
    }

}

// MARK: - RouteDashboardPresenter API
extension RouteDashboardPresenter: RouteDashboardPresenterApi {
    func didSelectClose() {
        _view.dismiss(animated: true, completion: nil)
    }
}

// MARK: - RouteDashboard Viper Components
private extension RouteDashboardPresenter {
    var view: RouteDashboardViewApi {
        return _view as! RouteDashboardViewApi
    }
    var interactor: RouteDashboardInteractorApi {
        return _interactor as! RouteDashboardInteractorApi
    }
    var router: RouteDashboardRouterApi {
        return _router as! RouteDashboardRouterApi
    }
}
