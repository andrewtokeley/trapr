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

enum MapOptionId: Int {
    case trapTypeFilterAll = 0
    case trapTypeFilterPossumMaster = 1
    case trapTypeFilterDOC200 = 2
    case trapTypeFilterTimms = 3
}

/**
 Represents which type of data is displayed on the Station Map.
 */
enum MapType: Int {
    /// Map displays the number of kills of specific species
    case catches = 0
    
    /// Map displays the amount of bait or poison added at each station
    case bait = 1
}

// MARK: - RouteDashboardPresenter Class
final class RouteDashboardPresenter: Presenter {
    
    let MENU_CHANGE_ORDER = "Change Visit Order"
    let MENU_DELETE = "Delete"
   
    var routeInformation: RouteInformation!
    var visitInformation: VisitInformation!
    
//    var stationKillCounts = [String: Int]()
//    var stationMapCounts = [String: Int]()
    
    // need this to check what species are catchable for each station
    var trapTypes = [TrapType]()
    
    var selectedSpeciesId: String?
    //var selectedTrapType: String?
    var selectedLureCode: String?
    
    var user: User?
    var allStations: [Station]?
    var currentMapType: MapType = .catches
    
    var trapCounts: [ (trapName: String, count: Int  )]?
    
    //MARK: - Setup
    
    override func setupView(data: Any) {
        
        if let setupData = data as? RouteDashboardSetup {
        
            self.user = interactor.currentUser()
            
            if let route = setupData.route {
                
                // Show spinner while loading
                self.view.showSpinner()
                
                self.interactor.retrieveTrapTypes() { (trapTypes) in
                    
                    self.trapTypes = trapTypes
                    
                    self.interactor.retrieveRouteInformation(route: route) { (information, error) in
                        
                        self.routeInformation = information
                        
                        self.interactor.retrieveVisitInformation(route: route) { (information, error) in
                            self.visitInformation = information
                            
                            // refresh view dependent info, including charts
                            self.refreshVisitViews()
                            
                            self.interactor.retrieveStationKillCounts(route: route, speciesId: nil) { (counts, error) in
                                
                                //self.stationKillCounts = counts
                                
                                self.view.displayStationSummary(summary: self.routeInformation.stationDescriptionsWithCodes, numberOfStations: self.routeInformation.stations.count)
                                
                                self.view.displayTrapsDescription(description: String(self.routeInformation.stations.reduce(0, { $0 + $1.trapTypes.filter({ $0.active }).count } )))
                                
                                if let name = self.routeInformation.route?.name {
                                    self.view.displayTitle(name, editable: true)
                                }
                                
                                let mapOptionButtons = self.mapOptionButtons(for: self.currentMapType)
                                let index = mapOptionButtons.firstIndex(where: { $0.isPrimary })
                                self.view.displayMapOptionButtons(buttons: mapOptionButtons, selectedIndex: index)
                                                            
                                self.displayStationsForCatches(route: route, speciesId: nil) {
                                    self.view.stopSpinner()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Helpers
    
    fileprivate func mapOptionButtons(for mapType: MapType) -> [MapOptionButton] {
        
        var options = [MapOptionButton]()
        
        if mapType == .catches {
            options.append(MapOptionButton(title: "ALL",
                                           width: 60,
                                           isPrimary: true,
                                           id: nil,
                                           optionType: MapType.catches))
            options.append(MapOptionButton(title: "POSSUM",
                                           width: 120,
                                           isPrimary: false,
                                           id: SpeciesCode.possum,
                                           optionType: MapType.catches))
            options.append(MapOptionButton(title: "RAT",
                                           width: 70,
                                           isPrimary: false,
                                           id: SpeciesCode.rat,
                                           optionType: MapType.catches))
            options.append(MapOptionButton(title: "STOAT",
                                           width: 70,
                                           isPrimary: false,
                                           id: SpeciesCode.stoat,
                                           optionType: MapType.catches))
            options.append(MapOptionButton(title: "HEDGEHOG",
                                           width: 70,
                                           isPrimary: false,
                                           id: SpeciesCode.hedgehog,
                                           optionType: MapType.catches))
        } else {
            options.append(MapOptionButton(title: "CONTRAC BLOX",
                                           width: 120,
                                           isPrimary: true,
                                           id: LureCode.contracBloxPoison,
                                           optionType: MapType.bait))
            options.append(MapOptionButton(title: "CEREAL",
                                           width: 70,
                                           isPrimary: false,
                                           id: LureCode.cereal,
                                           optionType: MapType.bait))
            options.append(MapOptionButton(title: "RABBIT",
                                           width: 70,
                                           isPrimary: false,
                                           id: LureCode.driedRabbit,
                                           optionType: MapType.bait))
        }
        
        return options
        
    }
    /**
     Updates the map to show the all the route's stations that have the given trap type
     
     If the trap type is nil then all stations will be displayed
    */
    fileprivate func displayStationsForCatches(route: Route, speciesId: String?, completion: (() -> Void)? = nil) {
        
        self.interactor.retrieveStationKillCounts(route: route, speciesId: speciesId) { (counts, error) in
            
            // update the kill counts so that the correct station colours are shown on the map
            //self.stationKillCounts = counts
            
            if let maxKillCount =  counts.values.max() {
                if let collection = try? SegmentCollection(start: 1, numberOfSegments: 6, maxExpectedValue: maxKillCount, openEnded: false, includeZeroSegment: true) {
                
                    // redisplay the stations - they'll get the right colours based on kill counts and the legend will be scaled accordingly
                    self.view.displayStations(stations: self.routeInformation.stations, stationCounts: counts, legendSegments: collection.segments, legendTitle: "COUNT")
                    
                    self.view.setVisibleRegionToAllStations()
                    completion?()
                } else {
                    completion?()
                }
            } else {
                completion?()
            }
        }
    }

    fileprivate func displayStationsForBaitAdded(route: Route, lureId: String, completion: (() -> Void)? = nil) {
        
        self.interactor.retrieveStationBaitAddedCounts(route: route, lureId: lureId) { (counts, error) in
            
            // update the kill counts so that the correct station colours are shown on the map
            //self.stationMapCounts = counts
            
            if let maxCount =  counts.values.max() {
                if let collection = try? SegmentCollection(start: 1, numberOfSegments: 6, maxExpectedValue: maxCount, openEnded: false, includeZeroSegment: true) {
                    
                    // redisplay the stations - they'll get the right colours based on kill counts and the legend will be scaled accordingly
                    self.view.displayStations(stations: self.routeInformation.stations, stationCounts: counts, legendSegments: collection.segments, legendTitle: "COUNT")
                    
                    self.view.setVisibleRegionToAllStations()
                    completion?()
                } else {
                    completion?()
                }
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
            
            if let killCounts = self.visitInformation.killCounts {
                var counts = [killCounts]
                var titles = [self.visitInformation.killCountsDescription]
                if let prior = self.visitInformation.killCountsLastPeriod {
                    counts.insert(prior, at: 0)
                    titles.insert(self.visitInformation.killCountsLastPeriodDescription, at: 0)
                }
                view.setChartData(
                    type: .catches,
                    counts: counts,
                    titles: titles
                )
            }
            
            if let poisonCounts = self.visitInformation.poisonCounts {
                var counts = [poisonCounts]
                var titles = [self.visitInformation.poisonCountsDescription]
                if let prior = self.visitInformation.poisonCountsLastPeriod {
                    counts.insert(prior, at: 0)
                    titles.insert(self.visitInformation.poisonCountsLastPeriodDescription, at: 0)
                }
                view.setChartData(
                    type: .bait,
                    counts: counts,
                    titles: titles
                )
            }
            
//            view.configureKillChart(
//                counts: self.visitInformation.killCounts,
//                title: self.visitInformation.killCountsDescription,
//                lastPeriodCounts: self.visitInformation.killCountsLastPeriod,
//                lastPeriodTitle: self.visitInformation.killCountsLastPeriodDescription
//            )
//
//            view.configurePoisonChart(counts: self.visitInformation.poisonCounts, title: self.visitInformation.poisonCountsDescription, lastPeriodCounts: self.visitInformation.poisonCountsLastPeriod, lastPeriodTitle: self.visitInformation.poisonCountsLastPeriodDescription)

            
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
            
            // get a list of all the active trap types used on the route.
            let uniqueTrapTypeIds = Array(Set(information.stations.flatMap { $0.trapTypes.compactMap { $0.active ? $0.trapTpyeId : nil } }))
            
            var counts = uniqueTrapTypeIds.map({ (trapTypeId) in
                // return the number of stations containing this trapType
                return information.stations.filter({ $0.trapTypes.filter( { $0.trapTpyeId == trapTypeId}).count > 0  }).count
            })
            
            var names = uniqueTrapTypeIds.map( { (id) in
                return self.trapTypes.first(where: { $0.id == id })?.walkTheLineName ?? "Unknown"
            })
            
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
    
    func didChangeBaitChartPerion(dataSetIndex: Int) {
        view.displayChart(type: .bait, index: dataSetIndex)
    }
    
    func didChangeKillChartPerion(dataSetIndex: Int) {
        view.displayChart(type: .catches, index: dataSetIndex)
    }
    
    func didSelectMapType(mapType: MapType) {
        self.currentMapType = mapType
        let mapOptionButtons = self.mapOptionButtons(for: self.currentMapType)
        
        // select the primary button if it exists or the first button
        var selectedOptionButtonIndex = mapOptionButtons.firstIndex(where: { $0.isPrimary} )
        if let _ = selectedOptionButtonIndex {
            self.didselectMapOptionButton(optionButton: mapOptionButtons[selectedOptionButtonIndex!])
        } else if let first = mapOptionButtons.first {
            selectedOptionButtonIndex = 0
            self.didselectMapOptionButton(optionButton: first)
        }
        
        self.view.displayMapOptionButtons(buttons: mapOptionButtons, selectedIndex: selectedOptionButtonIndex)
    }
    
    func didselectMapOptionButton(optionButton: MapOptionButton) {
        
        guard self.routeInformation?.route != nil else {
            return
        }
        
        if let type = optionButton.optionType as? MapType {
            if type == .catches {
                self.selectedSpeciesId = nil
                if let speciesCode = optionButton.id as? SpeciesCode {
                    self.selectedSpeciesId = speciesCode.rawValue
                }
                self.displayStationsForCatches(route: self.routeInformation!.route!, speciesId: self.selectedSpeciesId)
            } else if type == .bait {
                if let lureCode = optionButton.id as? LureCode {
                    self.selectedLureCode = lureCode.rawValue
                    self.displayStationsForBaitAdded(route: self.routeInformation!.route!, lureId: lureCode.rawValue)
                }
                
            }
        }
    }
    
    // TODO: can this be done from the view?
    func getIsHidden(station: LocatableEntity) -> Bool {
        
        if let station = routeInformation?.stations.first(where: { $0.id == station.locationId }) {
            
            if self.currentMapType == .catches {

                // work out whether the station contains a trap that can catch this species
                if let selectedSpeciesId = self.selectedSpeciesId {
                    let trapExistsThatCatchesSpecies = station.trapTypes.contains(where: { (trapTypeStatus) in
                        // return true if trapType is active and contains a catchable species equal to the selectedSpeciesId
                        if (trapTypeStatus.active) {
                            let trapType = self.trapTypes.first(where: { $0.id == trapTypeStatus.trapTpyeId && $0.catchableSpecies?.contains(selectedSpeciesId) ?? false })
                            return trapType != nil
                        }
                        return false
                    })
                    // don't hide if trap exists
                    return !trapExistsThatCatchesSpecies
                }
                return false
            } else if self.currentMapType == .bait {
                // TODO - need to return whether the station contains a trap that uses the lure. Mmmm?
                if let selectedLureId = self.selectedLureCode {
                    let trapExistsThatHasLure = station.trapTypes.contains(where: {
                        (trapTypeStatus) in
                        
                        // return true if there is a trap at the station that uses the selected lure
                        if trapTypeStatus.active {
                            let trapType = self.trapTypes.first(where: { $0.id == trapTypeStatus.trapTpyeId && $0.availableLures?.contains(selectedLureId) ?? false })
                            return trapType != nil
                        }
                        return false
                    })
                    // don't hide if a trap exists for the selected lure
                    return !trapExistsThatHasLure
                }
                return false
            }
        }
        return false
    }
    
//    func getColorForMapStation(station: LocatableEntity, state: AnnotationState) -> UIColor {
//        if state == .normal {
//            if self.currentMapType == .catches {
//                if let stationCount = stationKillCounts[station.locationId] {
//                    if let maxKillCount = stationKillCounts.values.max() {
//                        return UIColor.trpHeatColour(value:stationCount, maximumValue: maxKillCount)
//                    }
//                } else {
//                    return .clear
//                }
//            } else if currentMapType == .bait {
//                if let count = stationMapCounts[station.locationId] {
//                    if let maxCount = stationMapCounts.values.max() {
//                        return UIColor.trpHeatColour(value:count, maximumValue: maxCount)
//                    }
//                } else {
//                    return .clear
//                }
//            }
//        }
//        return .trpMapHighlightedStation
 //   }
    
//    func didSelectMapOptionAllTrapTypes() {
//        if let route = self.routeInformation.route {
//            self.selectedTrapType = nil
//            self.displayStationsForCatches(route: route, trapTypeId: nil)
//        }
//    }
//
//    func didSelectMapOptionPossumMaster() {
//        if let route = self.routeInformation.route {
//            self.selectedTrapType = TrapTypeCode.possumMaster.rawValue
//            self.displayStationsForCatches(route: route, trapTypeId: TrapTypeCode.possumMaster.rawValue)
//        }
//    }
//
//    func didSelectMapOptionTimms() {
//        if let route = self.routeInformation.route {
//            self.selectedTrapType = TrapTypeCode.timms.rawValue
//            self.displayStationsForCatches(route: route, trapTypeId: TrapTypeCode.timms.rawValue)
//        }
//    }
//
//    func didSelectMapOptionDoc200() {
//        if let route = self.routeInformation.route {
//            self.selectedTrapType = TrapTypeCode.doc200.rawValue
//            self.displayStationsForCatches(route: route, trapTypeId: TrapTypeCode.doc200.rawValue)
//        }
//    }
    
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
