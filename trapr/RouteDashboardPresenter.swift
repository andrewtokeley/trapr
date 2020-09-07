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
    
    let MENU_CHANGE_ORDER = "Change Visit Order"
    let MENU_DELETE = "Delete"
   
    var routeInformation: RouteInformation!
    var visitInformation: VisitInformation!
    var stationKillCounts = [String: Int]()
    var selectedTypeType: String?
    var user: User?
    var allStations: [Station]?
    
    var trapCounts: [ (trapName: String, count: Int  )]?
    
    //MARK: - Setup
    
    override func setupView(data: Any) {
        
        if let setupData = data as? RouteDashboardSetup {
        
            self.user = interactor.currentUser()
            
            if let route = setupData.route {
                
                // Show spinner while loading
                self.view.showSpinner()
                
                self.interactor.retrieveRouteInformation(route: route) { (information, error) in
                    
                    self.routeInformation = information
                    
                    self.interactor.retrieveVisitInformation(route: route) { (information, error) in
                        self.visitInformation = information
                        self.refreshVisitViews()
                        
                        self.interactor.retrieveStationKillCounts(route: route, trapTypeId: nil) { (counts, error) in

                            self.stationKillCounts = counts
                            
                            self.view.displayStationSummary(summary: self.routeInformation.stationDescriptionsWithCodes, numberOfStations: self.routeInformation.stations.count)
                            
                            self.view.displayTrapsDescription(description: String(self.routeInformation.stations.reduce(0, { $0 + $1.trapTypes.filter({ $0.active }).count } )))
                            
                            if let name = self.routeInformation.route?.name {
                                self.view.displayTitle(name, editable: true)
                            }
                            
                            // display all traptypes initially
                            self.displayStations(route: route, trapTypeId: nil) {
                                self.view.stopSpinner()
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Helpers
    
    /**
     Updates the map to show the all the route's stations that have the given trap type
     
     If the trap type is nil then all stations will be displayed
    */
    fileprivate func displayStations(route: Route, trapTypeId: String?, completion: (() -> Void)? = nil) {
        
        self.interactor.retrieveStationKillCounts(route: route, trapTypeId: trapTypeId) { (counts, error) in
            
            // update the kill counts so that the correct station colours are shown on the map
            self.stationKillCounts = counts
            
            if let maxKillCount =  self.stationKillCounts.values.max() {
                let segmentLength = (maxKillCount < 7 ? 7 : maxKillCount) / 7
                let collection = SegmentCollection(start: 0, segmentLength: segmentLength)
                
                // redisplay the heatmap, as it's segments are relative to the number of kills
                self.view.displayHeatmap(title: "CATCHES", segments: collection.segments)
                
                // redisplay the stations - they'll get the right colours based on kill counts
                self.view.displayStations(stations: self.routeInformation.stations)
                self.view.setVisibleRegionToAllStations()
                completion?()
            } else {
                completion?()
            }
            
            
        }
    }
    
    /// Tell the view to redraw stuff that's dependent on having visits
    fileprivate func refreshVisitViews() {
        
        if let information = self.visitInformation {
            
            if information.numberOfVisits > 0 {
                view.showVisitDetails(show: true)
                view.displayVisitNumber(number: String(information.numberOfVisits), allowSelection: true)
                view.displayLastVisitedDate(date: information.lastVisitedText ?? "-", allowSelection: information.lastVisitedText != nil)
                view.displayVisitNumber(number: String(information.numberOfVisits), allowSelection: true)
            } else {
                view.showVisitDetails(show: false)
            }
            
            view.configureKillChart(
                counts: self.visitInformation.killCounts,
                title: self.visitInformation.killCountsDescription,
                lastPeriodCounts: self.visitInformation.killCountsLastPeriod,
                lastPeriodTitle: self.visitInformation.killCountsLastPeriodDescription
            )
            
            view.configurePoisonChart(counts: self.visitInformation.poisonCounts, title: self.visitInformation.poisonCountsDescription, lastPeriodCounts: self.visitInformation.poisonCountsLastPeriod, lastPeriodTitle: self.visitInformation.poisonCountsLastPeriodDescription)
            
            // get a description for the average lure
            var usageText: String = ""
            for usage in information.averageLureUsage {
                usageText.append("\(usage.key) - \(usage.value) ")
            }
            view.displayAverageLureSummary(summary: usageText)
        }
    }
    
    /**
     returns an array of trap desciptions along with their counts
     */
    fileprivate func getTrapDescriptions() -> [(trapName: String, count: Int)] {
        
        var result = [(trapName: String, count: Int)]()
        
        if let information = self.routeInformation {
        
            let uniqueTrapTypesById = Array(Set(information.stations.flatMap { $0.trapTypes.compactMap { $0.active ? $0.trapTpyeId : nil } }))
            var counts = uniqueTrapTypesById.map({ (trapTypeId) in
                // return the number of stations containing this trapType
                return information.stations.filter({ $0.trapTypes.filter( { $0.trapTpyeId == trapTypeId}).count > 0  }).count
            })
            
            var names = uniqueTrapTypesById.compactMap { TrapTypeCode(rawValue: $0)?.name }
            
            // order descending by count
            let combined = zip(names, counts).sorted(by: { $0.1 > $1.1 } )
            names = combined.map {$0.0}
            counts = combined.map {$0.1}
            
            for i in 0...names.count - 1 {
                result.append(( trapName: names[i], count: counts[i] ))
            }
        }
        return result
    }
    
    fileprivate func saveRoute() {
        // TODO: save name only? station edits changed inline
        //interactor.saveRoute(route: self.route)
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
        CameraHandler.shared.showActionSheet(vc: view.viewController)
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
        
        // If any historic visits were deleted make sure they're not included in the dashboard
        if deletedVisits {
            if let route = self.routeInformation.route {
                self.interactor.retrieveVisitInformation(route: route) { (information, error) in
                    if let information = information {
                        self.visitInformation = information
                        self.refreshVisitViews()
                    }
                }
            }
        }
    }
}

// MARK: - RouteDashboardPresenter API
extension RouteDashboardPresenter: RouteDashboardPresenterApi {
    
    func didselectMapFilterOption(option: MapOption) {
        switch option {
            case .trapTypeFilterAll: self.didSelectMapOptionAllTrapTypes()
            case .trapTypeFilterTimms: self.didSelectMapOptionTimms()
            case .trapTypeFilterDOC200: self.didSelectMapOptionDoc200()
            case .trapTypeFilterPossumMaster: self.didSelectMapOptionPossumMaster()
        }
    }
    
    func getIsHidden(station: LocatableEntity) -> Bool {
        if let station = routeInformation?.stations.first(where: { $0.id == station.locationId }) {
            return !station.trapTypes.contains { $0.trapTpyeId == selectedTypeType } && selectedTypeType != nil
        }
        return false
    }
    
    func getColorForMapStation(station: LocatableEntity, state: AnnotationState) -> UIColor {
        if state == .normal {
            if let stationCount = stationKillCounts[station.locationId] {
                if let maxKillCount = stationKillCounts.values.max() {
                    return UIColor.trpHeatColour(value:stationCount, maximumValue: maxKillCount)
                }
            } else {
                return .trpMapDefaultStation
            }
        }
        return .trpMapHighlightedStation
    }
    
    func didSelectMapOptionAllTrapTypes() {
        if let route = self.routeInformation.route {
            self.selectedTypeType = nil
            self.displayStations(route: route, trapTypeId: nil)
        }
    }
    
    func didSelectMapOptionPossumMaster() {
        if let route = self.routeInformation.route {
            self.selectedTypeType = TrapTypeCode.possumMaster.rawValue
            self.displayStations(route: route, trapTypeId: TrapTypeCode.possumMaster.rawValue)
        }
    }
    
    func didSelectMapOptionTimms() {
        if let route = self.routeInformation.route {
            self.selectedTypeType = TrapTypeCode.timms.rawValue
            self.displayStations(route: route, trapTypeId: TrapTypeCode.timms.rawValue)
        }
    }
    
    func didSelectMapOptionDoc200() {
        if let route = self.routeInformation.route {
            self.selectedTypeType = TrapTypeCode.doc200.rawValue
            self.displayStations(route: route, trapTypeId: TrapTypeCode.doc200.rawValue)
        }
    }
    
    func didDeleteRoute() {
        view.viewController.dismiss(animated: true, completion: nil)
    }
    
    func didUpdateRouteName(name: String?) {
        
        self.routeInformation.route?.name = name ?? ""
        
        self.saveRoute()
    }
    
    func didSelectClose() {
        view.viewController.dismiss(animated: true, completion: nil)
    }
    
    func didSelectEditMenu() {
        
        let hasStations = self.routeInformation.stations.count > 0
        var menuOptions = [
            OptionItem(title: MENU_CHANGE_ORDER, isEnabled: hasStations, isDestructive: false)
        ]
        
        if user?.isInRole(role: .admin) ?? false {
            menuOptions.append(OptionItem(title: MENU_DELETE, isEnabled: true, isDestructive: true))
        }
        
        (view as? UserInterface)?.displayMenuOptions(options: menuOptions, actionHandler: {
            (title) in
            if title == self.MENU_CHANGE_ORDER { self.didSelectEditOrder() }
            else if title == self.MENU_DELETE { self.didSelectDeleteRoute() }
        })
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
    
    func didSelectTraps() {
        
        if let _ = self.trapCounts {
            let setupData = ListPickerSetupData()
            setupData.delegate = self
            setupData.embedInNavController = false
            setupData.includeSelectNone = false
            router.showListPicker(setupData: setupData)
        } else {
            self.trapCounts = getTrapDescriptions()
            didSelectTraps()
        }
    }
    
    func didSelectVisitHistory() {
        let visitSummaries = visitInformation.visitSummaries
        router.showVisitHistoryModule(visitSummaries: visitSummaries)
    }
    
    func didSelectEditOrder() {
        if let routeId = self.routeInformation.route?.id {
            router.showOrderStationsModule(routeId: routeId, stations: routeInformation.stations)
        }
    }
    
}

// MARK: - ListPickerDelegate

extension RouteDashboardPresenter: ListPickerDelegate {
    func listPicker(_ listPicker: ListPickerView, itemTextAt index: Int) -> String {
        return trapCounts?[index].trapName ?? ""
    }
    
    func listPickerCellStyle(_ listPicker: ListPickerView) -> UITableViewCell.CellStyle {
        return .value1
    }
    
    func listPicker(_ listPicker: ListPickerView, itemDetailAt index: Int) -> String? {
        if let count = trapCounts?[index].count {
            return String(count)
        }
        return ""
    }
    
    func listPickerTitle(_ listPicker: ListPickerView) -> String {
        return "Traps"
    }
    
    func listPickerHeaderText(_ listPicker: ListPickerView) -> String {
        return ""
    }
    
    func listPickerNumberOfRows(_ listPicker: ListPickerView) -> Int {
        return trapCounts?.count ?? 0
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
