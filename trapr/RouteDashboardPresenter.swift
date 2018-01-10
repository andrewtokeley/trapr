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
    
    var order: Int = 1
    var proposedStationOrder = ObjectOrder<Station>()
    var proposedStations = [Station]()
    var zoomLevel: Double?
    
    var isNewRoute: Bool = false
    var isEditingStations: Bool = false
    var isEditingOrder: Bool = false
    var clearInnerText: Bool = false
    
    
    var route: Route!
    var allStations: [Station]!
    var highlightedStations: [Station]?
    
    override func setupView(data: Any) {
        
        view.displayTitle("Route")
        
        if let setupData = data as? RouteDashboardSetup {
            
            // load all the stations even if we don't display them all
            self.allStations = ServiceFactory.sharedInstance.stationService.getAll()
            
            view.displayRouteName(setupData.route?.name)

            // we take a copy of the route instance to allow properties to be updated before saving, otherwise everything has to be wrapped in realm.write {}
            if let route = setupData.route {
                self.route = Route(value: route)
            } else {
                self.route = Route()
            }
            
            if let _ = setupData.route?.stations {
                isNewRoute = false
                isEditingStations = false
                view.showEditNavigation(false)
            } else {
                isNewRoute = true
                isEditingStations = true
                route = Route()
                view.showEditNavigation(true)
            }

            router.addMapAsChildView(containerView: view.getMapContainerView())
            
            if isNewRoute {
                view.setVisibleRegionToCentreOfStations(distance: 1000)
            } else {
                view.setVisibleRegionToHighlightedStations()
            }
        }
    }
    
    override func viewIsAboutToAppear() {
        if isNewRoute {
            self.didSelectEditStations()
        }
    }
    
    //MARK: - Helpers
    
    fileprivate func saveRoute() {
        if let route = self.route {
            ServiceFactory.sharedInstance.routeService.save(route: route)
        }
    }

}


//MARK: - StationMapDelegate
extension RouteDashboardPresenter: StationMapDelegate {
    
    func stationMap(_ stationMap: StationMapViewController, didSelect annotationView: StationAnnotationView) {
        
        if let view = annotationView as? CircleAnnotationView {
            
            if let annotation = view.annotation as? StationMapAnnotation {
                
                if isEditingOrder {
                    
                    if view.innerText?.isEmpty ?? true {

                        // mark this station as having the appropriate order
                        let order = proposedStationOrder.add(annotation.station)
                        view.innerText = String(order + 1)
                        
                    } else {
                        
                        // if a user clickesd on a station that's already got an order number
                        
                        // remove this order from the station
                        self.proposedStationOrder.remove(annotation.station)
                        
                        // clear it out
                        view.innerText = nil
                        
                    }
                }
                
                if isEditingStations {
                    
                    // If unselecting a station...
                    if view.circleTintColor == UIColor.trpMapHighlightedStation {
                        
                        if let index = self.proposedStations.index(of: annotation.station) {
                            self.proposedStations.remove(at: index)
                        }
                        
                        //self.route = interactor.removeStationFromRoute(route: self.route, station: annotation.station)
                        
                    }
                    
                    // if selecting a station
                    if view.circleTintColor == UIColor.trpMapDefaultStation {
                    
                        // insert it in right right place
                        self.proposedStations.append(annotation.station)
                        //self.route = interactor.addStationToRoute(route: self.route, station: annotation.station)
                    }
                    
                    // change the color
                    view.circleTintColor = view.circleTintColor == UIColor.trpMapDefaultStation ? UIColor.trpMapHighlightedStation : UIColor.trpMapDefaultStation
                }
            }
        }
    }
    
    func stationMap(_ stationMap: StationMapViewController, radiusForStation station: Station) -> Int {
        if isEditingOrder || isEditingStations {
            // make it a little bigger target
            return 15
        }
        return 5
    }
    
    func stationMapStations(_ stationMap: StationMapViewController) -> [Station] {
        
        // edit mode
        if isEditingStations {
            // all stations "near" route stations?
            return self.allStations
        }
        
        if let routeStations = self.route?.stations {
            // not editing, just show the route stations
            return Array(routeStations)
        }
        
        
        // If the current route has not stations, we won't display anything - that's fine
        return [Station]()
    }
    
    func stationMap(_ stationMap: StationMapViewController, isHighlighted station: Station) -> Bool {
        return self.route.stations.contains(station)
    }

    func stationMap(_ stationMap: StationMapViewController, textForStation station: Station) -> String? {
        
        let editing = isEditingStations || isEditingOrder
        
        // Viewing an existing route without being in edit mode
        if !isNewRoute && !editing {
            
            // consider displaying the line name on one of the stations
            return nil
        }
        
//        // Viewing a new Route for the first time, but not yet editing
//        else if isNewRoute && !isEditingStations {
//            return nil
//        }
        
        // Editing the stations
        else if isEditingStations {
            return station.longCode
        }
        
        return nil
    }
    
    func stationMap(_ stationMap: StationMapViewController, innerTextForStation station: Station) -> String? {
        
        if isEditingOrder && !clearInnerText {
            if let order = self.proposedStationOrder.orderOf(station) {
                return String(describing: order + 1)
            }
        }
        
        return nil
    }
    
    func stationMap(_ stationMap: StationMapViewController, annotationViewClassAt zoomLevel: ZoomLevel) -> AnyClass? {
        return CircleAnnotationView.self
    }
    
}

// MARK: - RouteDashboardPresenter API
extension RouteDashboardPresenter: RouteDashboardPresenterApi {
    
    func didSelectResetOrder() {
        if let stations = self.route?.stations {
            self.proposedStationOrder = ObjectOrder(objects: Array(stations))
        }
        view.reapplyStylingToAnnotationViews()
    }
    
    func didSelectClearOrder() {
        
        self.proposedStationOrder.removeAll()
        
        // a little hacky!
        self.clearInnerText = true
        view.reapplyStylingToAnnotationViews()
        self.clearInnerText = false
    }
    
    func didSelectReverseOrder() {
        //self.order = 1
        
        self.proposedStationOrder.reverse()
        view.reapplyStylingToAnnotationViews()
    }
    
    func didSelectResetStations() {
        if let stations = self.route?.stations {
            self.proposedStations = Array(stations)
        }
        view.reapplyStylingToAnnotationViews()
    }
    
    func didUpdateRouteName(name: String?) {
        self.route.name = name
        saveRoute()
    }
    
    func didSelectClose() {
        _view.dismiss(animated: true, completion: nil)
    }
    
    func didSelectEditMenu() {
        let menuOptions = [
            OptionItem(title: "Add/Remove Stations", isEnabled: true, isDestructive: false),
            OptionItem(title: "Change Visit Order", isEnabled: true, isDestructive: false),
            OptionItem(title: "Visit", isEnabled: true, isDestructive: false),
            OptionItem(title: "Delete", isEnabled: true, isDestructive: true)]
        
        (view as? UserInterface)?.displayMenuOptions(options: menuOptions, actionHandler: {
            (title) in
            if title == "Add/Remove Stations" { self.didSelectEditStations() }
            else if title == "Change Visit Order" { self.didSelectEditOrder() }
            else if title == "Visit" { self.didSelectVisit() }
            else if title == "Delete" { self.didSelectDeleteRoute() }
        })
    }
    
    func didSelectDeleteRoute() {
        interactor.deleteRoute(route: route)
        _view.dismiss(animated: true, completion: nil)
    }
    
    func didSelectVisit() {
        router.showVisitModule(route: self.route)
    }
    
    func didSelectEditStations() {
        
        self.proposedStations = Array(self.route.stations)
        
        isEditingStations = true
        isEditingOrder = false
        
        view.showEditNavigation(true)
        view.displayFullScreenMap()
        
        view.showEditDescription(true, description: "Click to (de)select route stations")
        view.showEditStationOptions(true)
        view.reloadMap(forceAnnotationRebuild: true)
    }
    
    func didSelectEditOrder() {

        // reset the order of stations to that of the route
        if let stations = self.route?.stations {
            self.proposedStationOrder = ObjectOrder(objects: Array(stations))
        }
        
        isEditingOrder = true
        isEditingStations = false
        
        view.showEditNavigation(true)
        view.showEditOrderOptions(true)
        view.displayFullScreenMap()
        
        view.reloadMap(forceAnnotationRebuild: true)
    }
    
    func didSelectEditDone() {

        view.showEditDescription(false, description: nil)
        
        // save changes
        if isEditingOrder {
            
            self.route = ServiceFactory.sharedInstance.routeService.replaceStationsOn(route: self.route, withStations: self.proposedStationOrder.orderedObjects)
            view.showEditOrderOptions(false)
        } else if isEditingStations {
           
            self.route = ServiceFactory.sharedInstance.routeService.replaceStationsOn(route: self.route, withStations: self.proposedStations)
            view.showEditStationOptions(false)
        }
        
        saveRoute()
        
        isEditingOrder = false
        isEditingStations = false
        
        view.showEditNavigation(false)
        view.displayCollapsedMap()
        view.reloadMap(forceAnnotationRebuild: true)
    }
    
    func didSelectEditCancel() {
        
        view.showEditDescription(false, description: nil)
        view.showEditStationOptions(false)
        view.showEditOrderOptions(false)
        
        isEditingOrder = false
        isEditingStations = false
        
        view.showEditNavigation(false)
        view.displayCollapsedMap()
        view.reloadMap(forceAnnotationRebuild: true)
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
