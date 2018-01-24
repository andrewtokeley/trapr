//
//  RouteDashboardPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley on 2/01/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit
import MapKit

// MARK: - RouteDashboardPresenter Class
final class RouteDashboardPresenter: Presenter {
    
    let MAP_CIRCLES = 0
    let MAP_MARKERS = 1
    
    var newRouteFromStartModule: Bool = false
    var order: Int = 1
    var proposedStationOrder = ObjectOrder<Station>()
    var proposedStations = [Station]()
    var zoomLevel: Double?
    var currentResizeButtonState: ResizeState = .collapse
    
    var isNewRoute: Bool = false
    var isEditingStations: Bool = false
    var isEditingOrder: Bool = false
    var clearInnerText: Bool = false
    
    var isMapExpanded: Bool {
        // if we're showing the collapse button we assume we're expanded
        return currentResizeButtonState == .collapse
    }
    
    var isEditing: Bool {
        return isEditingOrder || isEditingStations
    }
    
    var route: Route!
    var allStations: [Station]!
    var highlightedStations: [Station]?
    
    override func setupView(data: Any) {
        
        if let setupData = data as? RouteDashboardSetup {
            
            // load all the stations even if we don't display them all
            self.allStations = ServiceFactory.sharedInstance.stationService.getAll()
            
            // EDITING EXISTING ROUTE
            if let route = setupData.route {
                
                isNewRoute = false
                self.route = Route(value: route)
                view.displayTitle(self.route.name ?? route.longDescription)
                view.showEditNavigation(false)
                
                
            // NEW ROUTE
            } else if let routeName = setupData.newRouteName {
                
                isNewRoute = true
                self.route = Route()
                self.route.name = routeName
                view.displayTitle(routeName)
                
                // start by showing the select station view
                isEditingStations = true
                view.showEditNavigation(true)
                
            }
            
            self.displayMap()
            
            if let catchSummary = interactor.killCounts(frequency: .month, period: .year, route: self.route) {
                if !catchSummary.isZero {
                    view.showKillChart(true)
                    view.configureKillChart(catchSummary: catchSummary)
                } else {
                    view.showKillChart(false)
                }
            } else {
                view.showKillChart(false)
            }
            
            if let poisonSummary = interactor.poisonCounts(frequency: .month, period: .year, route: self.route) {
                if !poisonSummary.isZero {
                    view.showPoisonChart(true)
                    view.configurePoisonChart(poisonSummary: poisonSummary)
                } else {
                    view.showPoisonChart(false)
                }
            } else {
                view.showPoisonChart(false)
            }
            
        }
    }
    
    override func viewIsAboutToAppear() {
        if isNewRoute {
            self.didSelectEditStations()
        }
    }
    
    //MARK: - Helpers
    
    fileprivate func displayMap() {
        router.addMapAsChildView(containerView: view.getMapContainerView())
        if isNewRoute {
            view.setVisibleRegionToCentreOfStations(distance: 1000)
        } else {
            view.setVisibleRegionToHighlightedStations()
        }
        self.currentResizeButtonState = .expand
        view.setMapResizeIconState(state: .expand)
    }
    
    fileprivate func saveRoute() {
        if let route = self.route {
            ServiceFactory.sharedInstance.routeService.save(route: route)
        }
    }

}


//MARK: - StationMapDelegate
extension RouteDashboardPresenter: StationMapDelegate {
    
    func stationMap(_ stationMap: StationMapViewController, showCalloutForStation station: Station) -> Bool {
        return !isEditing
    }
    
    func stationMap(_ stationMap: StationMapViewController, didSelect annotationView: StationAnnotationView) {
      
            if let annotation = (annotationView as? MKAnnotationView)?.annotation as? StationMapAnnotation {
                
                if isEditingOrder {
                    
                    if annotationView.innerText?.isEmpty ?? true {

                        // mark this station as having the appropriate order
                        let order = proposedStationOrder.add(annotation.station)
                        annotationView.innerText = String(order + 1)
                        
                    } else {
                        
                        // if a user clickesd on a station that's already got an order number
                        
                        // remove this order from the station
                        self.proposedStationOrder.remove(annotation.station)
                        
                        // clear it out
                        annotationView.innerText = nil
                        
                    }
                    
                    // don't enable Done until all the stations have been enabled
                    view.editDoneEnabled = self.proposedStationOrder.count == self.route.stations.count
                }
                
                if isEditingStations {
                    
                    // If unselecting a station...
                    if annotationView.color == UIColor.trpMapHighlightedStation {
                        
                        if let index = self.proposedStations.index(of: annotation.station) {
                            self.proposedStations.remove(at: index)
                        }
                        
                        //self.route = interactor.removeStationFromRoute(route: self.route, station: annotation.station)
                        
                    }
                    
                    // if selecting a station
                    if annotationView.color == UIColor.trpMapDefaultStation {
                    
                        // insert it in right right place
                        self.proposedStations.append(annotation.station)
                        //self.route = interactor.addStationToRoute(route: self.route, station: annotation.station)
                    }
                    
                    // change the color
                    annotationView.color = annotationView.color == UIColor.trpMapDefaultStation ? UIColor.trpMapHighlightedStation : UIColor.trpMapDefaultStation
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
        if isEditingOrder {
            return station.longCode
        }
        return nil
    }
    
    func stationMap(_ stationMap: StationMapViewController, innerTextForStation station: Station) -> String? {
        
        // if we're editing the order the make sure the position is shown, unless we've chosen to clear all the order positions
        if isEditingOrder {
            if !clearInnerText {
                if let order = self.proposedStationOrder.orderOf(station) {
                    return String(describing: order + 1)
                }
            } else {
                return nil
            }
        }
        
        // viewing the dashboard, show more details if we're in an expanded view
        if !isEditing {
            if isMapExpanded {
                return station.longCode
            } else {
                return nil
            }
        }
        
        if isEditingStations {
            return station.longCode
        }
        
        return nil
    }
    
//    func stationMap(_ stationMap: StationMapViewController, annotationViewClassAt zoomLevel: ZoomLevel) -> AnyClass? {
//        //return StationMarkerAnnotationView.self
//        return CircleAnnotationView.self
//    }

    func stationMapNumberOfAnnotationViews(_ stationMap: StationMapViewController) -> Int {
        return 2
    }
    
    func stationMap(_ stationMap: StationMapViewController, annotationViewClassAt index: Int) -> AnyClass? {
        if index == MAP_CIRCLES {
            return CircleAnnotationView.self
        }
        return StationMarkerAnnotationView.self
    }
    
    func stationMap(_ stationMap: StationMapViewController, annotationViewIndexForStation index: Station) -> Int {
        // ignore station but if we're not editing only show circles
        if !isEditing {
            if !isMapExpanded {
                return MAP_CIRCLES
            }
        }
        return MAP_MARKERS
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
            OptionItem(title: "Hide", isEnabled: true, isDestructive: false),
            OptionItem(title: "Delete", isEnabled: true, isDestructive: true)]
        
        (view as? UserInterface)?.displayMenuOptions(options: menuOptions, actionHandler: {
            (title) in
            if title == "Add/Remove Stations" { self.didSelectEditStations() }
            else if title == "Change Visit Order" { self.didSelectEditOrder() }
            else if title == "Visit" { self.didSelectVisit() }
            else if title == "Hide" { self.didSelectHideRoute() }
            else if title == "Delete" { self.didSelectDeleteRoute() }
        })
    }
    
    func didSelectDeleteRoute() {
        if interactor.visitsExistForRoute(route: self.route) {
            _view.presentConfirmation(title: "Delete Route", message: "Deleting this Route will permanently remove all Visits. Do you want to continue?", response: {
                (response) in
                if response {
                    self.deleteAndCloseRoute()
                }
            })
        } else {
            deleteAndCloseRoute()
        }
    
    }
    
    private func deleteAndCloseRoute() {
        interactor.deleteRoute(route: self.route)
        _view.dismiss(animated: true, completion: nil)
    }
    
    func didSelectVisit() {
        // because self.route may be an unmanaged copy, we need to get the right one from the datastore
        if let route = ServiceFactory.sharedInstance.routeService.getById(id: self.route.id) {
            router.showVisitModule(route: route)
        }
    }
    
    func didSelectEditStations() {
        
        self.proposedStations = Array(self.route.stations)
        
        isEditingStations = true
        isEditingOrder = false
        
        view.showEditNavigation(true)
        view.displayFullScreenMap()
        
        if isNewRoute {
            view.showEditDescription(true, description: "Select stations in the order you expect to visit them (this can be changed later)")
        } else {
            view.showEditDescription(true, description: "Select stations to remove/add them to the route")
        }
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
        view.setMapResizeIconState(state: .expand)
        view.setVisibleRegionToCentreOfStations(distance: 500)
    }
    
    func didSelectResize() {
        
        if isMapExpanded {
            view.displayCollapsedMap()
        } else {
            view.displayFullScreenMap()
        }
        
        // toggle state
        self.currentResizeButtonState = self.currentResizeButtonState == .collapse ? .expand : .collapse
        view.setMapResizeIconState(state: self.currentResizeButtonState)
        
        view.reloadMap(forceAnnotationRebuild: false)
        view.setVisibleRegionToHighlightedStations()
    }
    
    func didSelectEditCancel() {
        
        if isNewRoute {
            _view.dismiss(animated: true, completion: nil)
        } else {
            view.showEditDescription(false, description: nil)
            view.showEditStationOptions(false)
            view.showEditOrderOptions(false)
            
            isEditingOrder = false
            isEditingStations = false
            
            view.showEditNavigation(false)
            view.displayCollapsedMap()
            view.reloadMap(forceAnnotationRebuild: true)
            view.setMapResizeIconState(state: .expand)
            
            // this should be close enough to see all stations
            view.setVisibleRegionToCentreOfStations(distance: 500)
        }
    }
    
    func didSelectHideRoute() {
        _view.presentConfirmation(title: "Hide Route", message: "Hiding a route removes it from the dashboard. You can unhide routes from settings. Continue?", response: {
            (response) in
            if response {
                self.route.isHidden = true
                self.saveRoute()
                self._view.dismiss(animated: true, completion: nil)
            }
        })
        
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
