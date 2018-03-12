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
    var previouslySelectedStation: Station?
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
    //var highlightedStations: [Station]?
    
    override func setupView(data: Any) {
        
        if let setupData = data as? RouteDashboardSetup {
            
            // load all the stations for the map, even if we don't display them all
            self.allStations = ServiceFactory.sharedInstance.stationService.getAll()
            
            // EDITING EXISTING ROUTE
            if let route = setupData.route {
                
                isNewRoute = false
                self.route = Route(value: route)
                self.proposedStations = Array(route.stations)
                view.displayTitle(self.route.name ?? route.longDescription, editable: true)
                view.showEditNavigation(false)
                
            // NEW ROUTE
            } else if let routeName = setupData.newRouteName {
                
                isNewRoute = true
                self.route = Route()
                self.route.name = routeName
                
                if let initialStation = setupData.station {
                    self.proposedStations = [initialStation]
                    self.previouslySelectedStation = initialStation
                }
                view.displayTitle(routeName, editable: true)
                
                // start by showing the select station view
                isEditingStations = true
                updateButtonStates()
                view.showEditNavigation(true)
                view.displayLastVisitedDate(date: "Not visited")
            }

            view.displayLastVisitedDate(date: interactor.lastVisitedText(route: route))
            self.displayMap()
            
            if let catchSummary = interactor.killCounts(frequency: .month, period: .year, route: self.route) {
                if !catchSummary.isZero {
                    //view.showKillChart(true)
                    view.configureKillChart(catchSummary: catchSummary)
                } else {
                    //view.showKillChart(false)
                }
            } else {
                //view.showKillChart(false)
            }
            
            if let poisonSummary = interactor.poisonCounts(frequency: .month, period: .year, route: self.route) {
                if !poisonSummary.isZero {
                    //view.showPoisonChart(true)
                    view.configurePoisonChart(poisonSummary: poisonSummary)
                } else {
                    //view.showPoisonChart(false)
                }
            } else {
                //view.showPoisonChart(false)
            }
            
        }
    }
    
    override func viewIsAboutToAppear() {
        if isNewRoute {
            self.didSelectEditStations()
        }
    }
    
    //MARK: - Helpers
    
    fileprivate func setTitle() {
        if isEditingOrder {
            view.displayTitle("Order", editable: false)
        } else if isEditingStations {
            view.displayTitle("Stations", editable: false)
        } else {
            view.displayTitle(self.route.name ?? "New Route", editable: true)
        }
    }
    
    /**
    Add the map to the view - only called once
    */
    fileprivate func displayMap() {
        
        router.addMapAsChildView(containerView: view.getMapContainerView())

        if !isNewRoute && self.route.stations.count == 0 {
            view.setVisibleRegionToCentreOfStations(distance: 1000)
//        } else if self.route.stations.count == 1 {
//            view.setVisibleRegionToStation(station: self.route.stations.first!, distance: 150)
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
    
    fileprivate func updateButtonStates() {
        // don't enable Done until all the stations have been enabled
        if isEditingOrder {
            view.enableEditDone(self.proposedStationOrder.count == self.route.stations.count)
        } else if isEditingStations {
            view.enableEditDone(self.proposedStations.count > 0)
        }
        view.enableReverseOrder(self.proposedStationOrder.count == self.route.stations.count)
        
        if self.proposedStations.count > 0 {
            let traplinesDescription = ServiceFactory.sharedInstance.stationService.getDescription(stations: self.proposedStations, includeStationCodes: false)
            let title = "Select All Stations on \(traplinesDescription)"
            view.setTitleOfSelectAllStations(title: title)
            view.enableSelectAllStationsButton(true)
        } else {
            view.setTitleOfSelectAllStations(title: "")
            view.enableSelectAllStationsButton(false)
        }
        
    }
    
    private func switchFromEditToViewMode() {
        
        isEditingOrder = false
        isEditingStations = false
        
        setTitle()
        
        view.showEditDescription(false, description: nil)
        view.showEditOrderOptions(false)
        view.showEditStationOptions(false)
        view.showEditNavigation(false)
        view.displayCollapsedMap()
        view.reloadMap(forceAnnotationRebuild: true)
        view.setMapResizeIconState(state: .expand)
        //view.setVisibleRegionToCentreOfStations(distance: 500)
        view.setVisibleRegionToHighlightedStations()
    }
    
//    func setOrder(annotationView: StationAnnotationView) {
//        
//        if let annotation = (annotationView as? MKAnnotationView)?.annotation as? StationMapAnnotation {
//            
//            // Order not set yet
//            if annotationView.innerText?.isEmpty ?? true {
//                
//                // mark this station as having the appropriate order. The add method is smart about where it positions the station, essentially filling in the gaps
//                proposedStationOrder.add(annotation.station)
//                
//            } else {
//                
//                // Order has an ordering
//                
//                // remove this order from the station
//                self.proposedStationOrder.remove(annotation.station)
//            }
//        }
//        return order
//    }
}


//MARK: - StationMapDelegate
extension RouteDashboardPresenter: StationMapDelegate {
    
    func stationMap(_ stationMap: StationMapViewController, showCalloutForStation station: Station) -> Bool {
        return !isEditing
    }
    
    func stationMap(_ stationMap: StationMapViewController, didSelect annotationView: StationAnnotationView) {
      
        if let annotation = (annotationView as? MKAnnotationView)?.annotation as? StationMapAnnotation {
            
            if isEditingOrder {
                
                // Order not set yet
                if annotationView.innerText?.isEmpty ?? true {
                    
                    // mark this station as having the appropriate order. The add method is smart about where it positions the station, essentially filling in the gaps
                    let _ = proposedStationOrder.add(annotation.station)
                    
                } else {
                    
                    // Order has an ordering
                    
                    // remove this order from the station
                    self.proposedStationOrder.remove(annotation.station)
                }
            }
            
            if isEditingStations {
                
                // If unselecting a station...
                if annotationView.color == UIColor.trpMapHighlightedStation {
                    
                    if let index = self.proposedStations.index(of: annotation.station) {
                        self.proposedStations.remove(at: index)
                    }
                }
                
                // if selecting a station
                if annotationView.color == UIColor.trpMapDefaultStation {
                    
                    var addedSequence = false
                    
                    if self.previouslySelectedStation != nil {
                        // find out if there are stations in between that can be filled in
                        if let sequence = interactor.getStationSequence(self.previouslySelectedStation!, annotation.station) {
                            
                            for station in sequence {
                                // don't add the first as it has already been added
                                if station != sequence.first {
                                    self.proposedStations.append(station)
                                    addedSequence = true
                                } 
                            }
                        }
                    }
                    
                    // if we didn't add a sequence of stations just add the one that was selected
                    if !addedSequence {
                        self.proposedStations.append(annotation.station)
                    }
                }
            }
            
            // redraw annotation colours and inner text
            view.reapplyStylingToAnnotationViews()
            
            // update button states
            self.updateButtonStates()
            
            // remember what this station was for the next time
            self.previouslySelectedStation = annotation.station
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
        //return self.route.stations.contains(station) || self.proposedStations.contains(station)
        return self.proposedStations.contains(station)
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
    
//    func didSelectResetOrder() {
//        if let stations = self.route?.stations {
//            self.proposedStationOrder = ObjectOrder(objects: Array(stations))
//        }
//        view.reapplyStylingToAnnotationViews()
//        updateButtonStates()
//    }
    
    func didSelectClearOrder() {
        
        self.proposedStationOrder.removeAll()
        
        // a little hacky to ensure no number appears in the marker
        self.clearInnerText = true
        view.reapplyStylingToAnnotationViews()
        self.clearInnerText = false
        
        updateButtonStates()
    }
    
    func didSelectReverseOrder() {
        self.proposedStationOrder.reverse()
        view.reapplyStylingToAnnotationViews()
    }
    
//    func didSelectResetStations() {
//        if let stations = self.route?.stations {
//            self.proposedStations = Array(stations)
//        }
//        view.reapplyStylingToAnnotationViews()
//        
//        updateButtonStates()
//    }
    
    func didUpdateRouteName(name: String?) {
        self.route.name = name
        saveRoute()
    }
    
    func didSelectCancel() {
        if isNewRoute {
            // go back to the New Route module
            _view.navigationController?.popViewController(animated: true)
        } else if isEditing {
            self.switchFromEditToViewMode()
        }
    }
    
    func didSelectClose() {
        _view.dismiss(animated: true, completion: nil)
    }
    
    func didSelectEditMenu() {
        let menuOptions = [
            OptionItem(title: "Add/Remove Stations", isEnabled: true, isDestructive: false),
            OptionItem(title: "Change Visit Order", isEnabled: true, isDestructive: false),
            OptionItem(title: "Visits", isEnabled: true, isDestructive: false),
            OptionItem(title: "Hide", isEnabled: true, isDestructive: false),
            OptionItem(title: "Delete", isEnabled: true, isDestructive: true)]
        
        (view as? UserInterface)?.displayMenuOptions(options: menuOptions, actionHandler: {
            (title) in
            if title == "Add/Remove Stations" { self.didSelectEditStations() }
            else if title == "Change Visit Order" { self.didSelectEditOrder() }
            else if title == "Visits" { self.didSelectVisitHistory() }
            else if title == "Hide" { self.didSelectHideRoute() }
            else if title == "Delete" { self.didSelectDeleteRoute() }
        })
    }
    
    func didSelectToSelectAllStations() {
        let service = ServiceFactory.sharedInstance.stationService
        
        for trapline in service.getTraplines(from: self.proposedStations) {
            
            for station in trapline.stations {
                
                // add the station to the route
                if !self.proposedStations.contains(station) {
                    self.proposedStations.append(station)
                }
                
            }
        }
        view.reapplyStylingToAnnotationViews()
        view.setVisibleRegionToHighlightedStations()
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
    
    func didSelectLastVisited() {
        
        if let visitSummary = interactor.lastVisitSummary(route: self.route) {
            router.showVisitModule(visitSummary: visitSummary)
        }
    }
    
    func didSelectVisitHistory() {
        // because self.route may be an unmanaged copy, we need to get the right one from the datastore
        if let route = ServiceFactory.sharedInstance.routeService.getById(id: self.route.id) {
            router.showVisitHistoryModule(route: route)
        }
    }
    
    func didSelectEditStations() {
        
        view.displayTitle("Select Stations", editable: false)
        
        // for new Routes we will have set a proposed first station already
        if !isNewRoute {
            self.proposedStations = Array(self.route.stations)
        }
        
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
        setTitle()
        
        view.showEditNavigation(true)
        view.showEditOrderOptions(true)
        view.displayFullScreenMap()
        
        view.reloadMap(forceAnnotationRebuild: true)
        
    }
    
    func didSelectEditDone() {

        // save changes
        if isEditingOrder {
            
            self.route = ServiceFactory.sharedInstance.routeService.replaceStationsOn(route: self.route, withStations: self.proposedStationOrder.orderedObjects)
        } else if isEditingStations {
           
            self.route = ServiceFactory.sharedInstance.routeService.replaceStationsOn(route: self.route, withStations: self.proposedStations)
        }
        
        saveRoute()
        
        self.switchFromEditToViewMode()
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
            //_view.dismiss(animated: true, completion: nil)
            _view.navigationController?.popViewController(animated: true)
        } else {
            view.showEditDescription(false, description: nil)
            view.showEditStationOptions(false)
            view.showEditOrderOptions(false)
            
            isEditingOrder = false
            isEditingStations = false
            setTitle()
            
            view.showEditNavigation(false)
            view.displayCollapsedMap()
            view.reloadMap(forceAnnotationRebuild: true)
            view.setMapResizeIconState(state: .expand)
            
            // this should be close enough to see all stations
            view.setVisibleRegionToCentreOfStations(distance: 500)
        }
        
        setTitle()
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
