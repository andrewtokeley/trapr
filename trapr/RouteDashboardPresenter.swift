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
import Photos

// MARK: - RouteDashboardPresenter Class
final class RouteDashboardPresenter: Presenter {
    
    let TEXT_NEVER_VISITED = "Never visited"
    
    let MAP_CIRCLES = 0
    let MAP_MARKERS = 1
    
    let MENU_EDIT_STATIONS = "Add/Remove Stations"
    let MENU_CHANGE_ORDER = "Change Visit Order"
    //let MENU_HIDE = "Hide from Dashboard"
    let MENU_DELETE = "Delete"
    //let MENU_UPDATE_DASHBOARD_IMAGE = "Update Dashboard Image"
    
    var hasMapViewBeenAdded: Bool = false
    
    var newRouteFromStartModule: Bool = false
    var order: Int = 1
    //var proposedStationOrder = ObjectOrder<Station>()
    var proposedStationOrder = ObjectOrder<String>()
    var proposedStationIds = [String]()
    var previouslySelectedStationId: String?
    
    var zoomLevel: Double?
    var currentResizeButtonState: ResizeState = .collapse
    
    var isNewRoute: Bool = false
    var isEditingStations: Bool = false
    var isEditingOrder: Bool = false
    var clearInnerText: Bool = false
    
    var routeInformation: RouteInformation!
    var visitInformation: VisitInformation!
    var user: User?
    
    var isMapExpanded: Bool {
        // if we're showing the collapse button we assume we're expanded
        return currentResizeButtonState == .collapse
    }
    
    var isEditing: Bool {
        return isEditingOrder || isEditingStations
    }
    
    //var route: _Route!
    //var allStations: [LocatableEntity]?
    var allStations: [Station]?
    
    override func setupView(data: Any) {
        
        if let setupData = data as? RouteDashboardSetup {
        
            self.user = interactor.currentUser()
            
            self.currentResizeButtonState = .expand
            
            // EDITING EXISTING ROUTE
            if let route = setupData.route {
                
                isNewRoute = false
                
                // take a copy of the route so we can back out?
                //self.route = route.copy() as? _Route
                self.proposedStationIds = route.stationIds

                // get information about the route, when done self.didFetchRouteInformation and self.didVisitRouteInformation will be called and we can set the UI elements
                interactor.retrieveRouteInformation(route: route)
                interactor.retrieveVisitInformation(route: route)
                
            // NEW ROUTE
            } else if let routeName = setupData.newRouteName {
                
                isNewRoute = true
                
                // start by showing the select station view
                isEditingStations = true
                
                //self.route = _Route(id: UUID().uuidString, name: routeName)
                
                // TODO: consider this instead...
                //self.interactor.retrieveRouteInformation(route: nil)
                self.routeInformation = RouteInformation()
                
                self.routeInformation.route = try? Route(name: routeName, stationIds: [String]())
                if self.routeInformation.route != nil {
                    // no visits yet.
                    self.visitInformation = VisitInformation()
                    
                    if let initialStation = setupData.station {
                        self.proposedStationIds = [initialStation.id!]
                        self.previouslySelectedStationId = initialStation.id
                    }
                    self.refreshStationViews()
                    self.refreshVisitViews()
                } else {
                    // means the user is not authenticated - shouldn't happen
                }
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
            if let routeName = self.routeInformation.route?.name {
                view.displayTitle(routeName, editable: true)
            }
        }
    }
    
    /// Tell the view to redraw parts of itself
    fileprivate func refreshVisitViews() {
        
        if let information = self.visitInformation {
        
            if information.numberOfVisits > 0 {
                view.showVisitDetails(show: true)
                view.displayVisitNumber(number: String(information.numberOfVisits), allowSelection: true)
                view.displayTimes(description: information.timeDescription, allowSelection: false)
                view.displayLastVisitedDate(date: information.lastVisitedText ?? "-", allowSelection: information.lastVisitedText != nil)
                view.displayVisitNumber(number: String(information.numberOfVisits), allowSelection: true)
            } else {
                view.showVisitDetails(show: false)
            }
            if let killCounts = visitInformation.killCounts {
                view.configureKillChart(catchSummary: killCounts)
            }
            if let poisonCounts = visitInformation.poisonCounts {
                view.configurePoisonChart(poisonSummary: poisonCounts)
            }
        }
    }
    
    fileprivate func refreshStationViews() {
    
        setTitle()
        updateButtonStates()
        
        view.showEditNavigation(isEditing)
        
        if let information = self.routeInformation {
        
            view.displayStationSummary(summary: information.stationDescriptionsWithCodes, numberOfStations: information.stations.count)
            
            if let name = information.route?.name {
                view.displayTitle(name, editable: true)
            }
        
            if self.proposedStationIds.count > 0 {
                view.setTitleOfSelectAllStations(title: "Select All Stations on \(information.stationDescriptionsWithoutCodes)")
            }
            
            // Add the map view, if it's not there yet
            if !hasMapViewBeenAdded {
                router.addMapAsChildView(containerView: view.getMapContainerView())
                hasMapViewBeenAdded = true
            }
            
            // refresh the map, things might have changed, e.g. new/removed stations
            view.reloadMap(forceAnnotationRebuild: true)
            // rezoom
//            if !isNewRoute && self.routeInformation.stations.count == 0 {
//                view.setVisibleRegionToCentreOfStations(distance: 1000)
//            } else {
//                view.setVisibleRegionToHighlightedStations()
//            }
            view.setVisibleRegionToHighlightedStations()
        }
    }
    
    fileprivate func saveRoute() {
        // TODO: save name only? station edits changed inline
        //interactor.saveRoute(route: self.route)
    }
    
    fileprivate func updateButtonStates() {
        
        if isEditingOrder {
            // don't enable Done until all the stations have been given an order
            view.enableEditDone(self.proposedStationOrder.count == self.routeInformation.stations.count)
        } else if isEditingStations {
            view.enableEditDone(self.proposedStationIds.count > 0)
        }
        view.enableReverseOrder(self.proposedStationOrder.count == self.routeInformation.stations.count)
        
        // make sure the station descriptions are still accurate
        // THIS IS EXPENSIVE - FIND A BETTER WAY!
        //interactor.retrieveRouteInformation(route: self.route)
        
        if self.proposedStationIds.count > 0 {
            view.enableSelectAllStationsButton(true)
        } else {
            view.setTitleOfSelectAllStations(title: "")
            view.enableSelectAllStationsButton(false)
        }
        
    }
    
    private func switchFromEditToViewMode() {
        
        setTitle()
        
        view.displayCollapsedMap()
        view.showEditDescription(false, description: nil)
        view.showEditOrderOptions(false)
        view.showEditStationOptions(false)
        view.showEditNavigation(false)
        
        // rezoom
        if !isNewRoute && self.routeInformation.stations.count == 0 {
            view.setVisibleRegionToCentreOfStations(distance: 1000)
        } else {
            view.setVisibleRegionToHighlightedStations()
        }
    }
  
    func didSelectUpdateDasboardImage() {
        // get permission to access photos
        let status = PHPhotoLibrary.authorizationStatus()

        var authorized = status == PHAuthorizationStatus.authorized

        if !authorized  {
            PHPhotoLibrary.requestAuthorization({status in
                authorized = status == PHAuthorizationStatus.authorized
                self.selectImage()
            })
        }
        self.selectImage()
    }
    
    func selectImage() {
        CameraHandler.shared.showActionSheet(vc: self._view)
        CameraHandler.shared.imagePickedBlock = { (asset) in
            
            // save the url against the route
//            self.interactor.setRouteImage(route: self.route, asset: asset, completion: {
//
//                // may
//
//            })
        }
    }
}


//MARK: - ViewHistoryDelegate
extension RouteDashboardPresenter: VisitHistoryDelegate {
    func visitHistoryIsAboutToClose(deletedVisits: Bool) {
        if deletedVisits {
            if let route = self.routeInformation.route {
                self.interactor.retrieveVisitInformation(route: route)
            }
        }
    }
}

//MARK: - StationMapDelegate
extension RouteDashboardPresenter: StationMapDelegate {
    
    func stationMap(_ stationMap: StationMapViewController, showCalloutForStation station: LocatableEntity) -> Bool {
        return !isEditing
    }
    
    func stationMap(_ stationMap: StationMapViewController, didSelect annotationView: StationAnnotationView) {
      
        if let annotation = (annotationView as? MKAnnotationView)?.annotation as? StationMapAnnotation {
            
            if isEditingOrder {
                
                // Order not set yet
                if annotationView.innerText?.isEmpty ?? true {
                    
                    // mark this station as having the appropriate order. The add method is smart about where it positions the station, essentially filling in the gaps
                    let _ = proposedStationOrder.add(annotation.station.locationId)
                    
                } else {
                    
                    // Order has an ordering
                    
                    // remove this order from the station
                    self.proposedStationOrder.remove(annotation.station.locationId)
                }
            }
            
            if isEditingStations {
                
                // If unselecting a station...
                if annotationView.color == UIColor.trpMapHighlightedStation {
                    
                    if let index = self.proposedStationIds.index(of: annotation.station.locationId) {
                        self.proposedStationIds.remove(at: index)
                    }
                }
                
                // if selecting a station
                if annotationView.color == UIColor.trpMapDefaultStation {
                    
                    //var addedSequence = false
                    
                    if self.previouslySelectedStationId != nil {
                        // find out if there are stations in between that can be filled in
                        interactor.getStationSequence(fromStationId: self.previouslySelectedStationId!, toStationId: annotation.station.locationId) { (sequence, error) in
                            
                            for station in sequence {
                                // don't add the first as it has already been added
                                if station != sequence.first {
                                    if let id = station.id {
                                        self.proposedStationIds.append(id)
                                        //addedSequence = true
                                    }
                                } 
                            }
                            
                            // redraw annotation colours and inner text
                            self.view.reapplyStylingToAnnotationViews()
                        }
                    } else {
                        self.proposedStationIds.append(annotation.station.locationId)
                        view.reapplyStylingToAnnotationViews()
                    }
                    
                    // if we didn't add a sequence of stations just add the one that was selected
//                    if !addedSequence {
//                        self.proposedStationIds.append(annotation.station.locationId)
//                    }
                }
            }
            
            // update button states
            self.updateButtonStates()
            
            // remember what this station was for the next time
            self.previouslySelectedStationId = annotation.station.locationId
        }
    }
    
    func stationMap(_ stationMap: StationMapViewController, radiusForStation station: LocatableEntity) -> Int {
        if !isEditing {
            return 5
        }
        
        // if we're editing radius isn't used
        return 0
    }
    
    func stationMapStations(_ stationMap: StationMapViewController) -> [LocatableEntity] {
        
        // edit mode
        if isEditingStations {
            // all stations "near" route stations?
            return self.allStations ?? [Station]()
        }
        // if viewing an existing Route, just show the route stations
        return self.routeInformation.stations
    }
    
    func stationMap(_ stationMap: StationMapViewController, isHighlighted station: LocatableEntity) -> Bool {
        //return self.route.stations.contains(station) || self.proposedStations.contains(station)
        return self.proposedStationIds.contains(station.locationId)
    }

    func stationMap(_ stationMap: StationMapViewController, textForStation station: LocatableEntity) -> String? {
        if isEditingOrder {
            return station.subTitle

        }
        return nil
    }
    
    func stationMap(_ stationMap: StationMapViewController, innerTextForStation station: LocatableEntity) -> String? {
        
        // if we're editing the order the make sure the position is shown, unless we've chosen to clear all the order positions
        if isEditingOrder {
            if !clearInnerText {
                if let order = self.proposedStationOrder.orderOf(station.locationId) {
                    return String(describing: order + 1)
                }
            } else {
                return ""
            }
        }
        
        // viewing the dashboard, show more details if we're in an expanded view
        if !isEditing {
            if isMapExpanded {
                return station.title
            } else {
                return ""
            }
        }
        
        if isEditingStations {
            return station.subTitle
        }
        
        return ""
    }
    
    func stationMapNumberOfAnnotationViews(_ stationMap: StationMapViewController) -> Int {
        return 2
    }
    
    func stationMap(_ stationMap: StationMapViewController, annotationViewClassAt index: Int) -> AnyClass? {
        if index == MAP_CIRCLES {
            return CircleAnnotationView.self
        }
        return StationMarkerAnnotationView.self
    }
    
    func stationMap(_ stationMap: StationMapViewController, annotationViewIndexForStation index: LocatableEntity) -> Int {
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
    
    func didDeleteRoute() {
        _view.dismiss(animated: true, completion: nil)
    }
    
    /// Called by Interactor when we've finished saving station edits or reordering
    func didSaveStationEdits(){
        // make sure the most recent stations are referenced, RouteInformation is used
        self.switchFromEditToViewMode()
    }
    
    func didFetchVisitInformation(information: VisitInformation) {
        self.visitInformation = information
        self.refreshVisitViews()
    }
    
    func didFetchRouteInformation(information: RouteInformation) {
        self.routeInformation = information
        self.refreshStationViews()
    }
    
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
        
        self.routeInformation.route?.name = name ?? ""
        saveRoute()
    }
    
    func didSelectCancel() {
        if isNewRoute {
            // go back to the New Route module
            _view.navigationController?.popViewController(animated: true)
        } else if isEditing {
            self.isEditingOrder = false
            self.isEditingOrder = false
            view.reloadMap(forceAnnotationRebuild: true)
            self.switchFromEditToViewMode()
        }
    }
    
    func didSelectClose() {
        _view.dismiss(animated: true, completion: nil)
    }
    
    func didSelectEditMenu() {
        
        let hasStations = self.routeInformation.stations.count > 0
        var menuOptions = [
            OptionItem(title: MENU_CHANGE_ORDER, isEnabled: hasStations, isDestructive: false),
            OptionItem(title: MENU_DELETE, isEnabled: true, isDestructive: true)]
        
        if user?.isInRole(role: .admin) ?? false {
            menuOptions.insert(OptionItem(title: MENU_EDIT_STATIONS, isEnabled: true, isDestructive: false), at: 0)
        }
        
        (view as? UserInterface)?.displayMenuOptions(options: menuOptions, actionHandler: {
            (title) in
            if title == self.MENU_EDIT_STATIONS { self.didSelectEditStations() }
            else if title == self.MENU_CHANGE_ORDER { self.didSelectEditOrder() }
            else if title == self.MENU_DELETE { self.didSelectDeleteRoute() }
        })
    }
    
    func didSelectToSelectAllStations() {
//        let service = ServiceFactory.sharedInstance.traplineService
//
//        for trapline in service.getTraplines(from: self.proposedStations) {
//
//            for station in trapline.stations {
//
//                // add the station to the route
//                if !self.proposedStations.contains(station) {
//                    self.proposedStations.append(station)
//                }
//
//            }
//        }
//        view.reapplyStylingToAnnotationViews()
//        view.setVisibleRegionToHighlightedStations()
    }
    
    func didSelectDeleteRoute() {
        let numberOfVisits = visitInformation.numberOfVisits
        // show warning if the route has visits
        if numberOfVisits > 0 {
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
        if let routeId = self.routeInformation.route?.id {
            interactor.deleteRoute(routeId: routeId)
        }
    }
    
    func didSelectLastVisited() {
        if let summary = visitInformation.lastVisitSummary {
            router.showVisitModule(visitSummary: summary)
        }
    }
    
    func didSelectTimes() {
        
    }
    
    func didSelectVisitHistory() {
        let visitSummaries = visitInformation.visitSummaries
        router.showVisitHistoryModule(visitSummaries: visitSummaries)
    }
    
    func didSelectEditStations() {
        
        if allStations == nil {
            interactor.retrieveStations { (stations) in
                self.allStations = stations
                self.didSelectEditStations()
            }
        } else {
            
            view.displayTitle("Stations", editable: false)
            
            // for new Routes we will have set a proposed first station already
            if !isNewRoute {
                self.proposedStationIds = self.routeInformation.stations.map({ $0.id! })
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
            view.setVisibleRegionToHighlightedStations()
        }
    }
    
    func didSelectEditOrder() {

        if let routeId = self.routeInformation.route?.id {
            router.showOrderStationsModule(routeId: routeId, stations: routeInformation.stations)
        }
        
//        // reset the order of stations to that of the route
//        self.proposedStationOrder = ObjectOrder(objects: self.routeInformation.stations.map( { $0.id! }))
//
//
//        isEditingOrder = true
//        isEditingStations = false
//        setTitle()
//        updateButtonStates()
//        view.showEditNavigation(true)
//        view.showEditOrderOptions(true)
//        view.displayFullScreenMap()
//
//        view.reloadMap(forceAnnotationRebuild: true)
        
    }
    
    func didSelectEditDone() {

    
        var stations: [Station]!
        
        if isEditingOrder {
            stations = self.allStations?.filter({ self.proposedStationOrder.orderedObjects.contains($0.locationId) }) ?? [Station]()
        } else {
            stations = self.allStations?.filter({ self.proposedStationIds.contains($0.locationId) }) ?? [Station]()
        }
        
        // update local data so we don't have to rely on updates below completing to update the View
        self.routeInformation.stations = stations
        self.routeInformation.stationDescriptionsWithCodes = interactor.getStationsDescription(stations: stations, includeStationCodes: true)
        self.routeInformation.stationDescriptionsWithCodes = interactor.getStationsDescription(stations: stations, includeStationCodes: false)
        
        // persist changes
        if isNewRoute {
            // create a new Route
            if let route = self.routeInformation.route {
                route.stationIds = stations.map({$0.id!})
                route.id = interactor.saveRoute(route: route)
            }
        } else {
            // update existing Route
            if let routeId = self.routeInformation.route?.id {
                if isEditingOrder {
                    self.interactor.updateStationsOnRoute(routeId: routeId, stationIds: self.proposedStationOrder.orderedObjects)
                } else if isEditingStations {
                    self.interactor.updateStationsOnRoute(routeId: routeId, stationIds: self.proposedStationIds)
                }
            }
        }
        
        isEditingOrder = false
        isEditingStations = false
        isNewRoute = false
        
        self.switchFromEditToViewMode()
        self.refreshStationViews()

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
        _view.presentConfirmation(title: "Hide Route (TODO! NOT IMPLEMENTED!)", message: "Hiding a route removes it from the dashboard. You can unhide routes from Settings. Continue?", response: {
            (response) in
            if response {
//                self.route.hidden = true
//                self.saveRoute()
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
