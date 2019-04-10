//
//  RouteDashboardInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley on 2/01/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit
import Photos

struct VisitInformation {
    var lastVisitedText: String?
    var lastVisitSummary: VisitSummary?
    var visitSummaries = [VisitSummary]()
    var timeDescription: String = ""
    var numberOfVisits: Int = 0
    var killCounts: StackCount?
    var poisonCounts: StackCount?
}

struct RouteInformation {
    var route: Route?
//    var routeId: String?
//    var routeName: String = "New Route"
    var stations = [Station]()
    var stationDescriptionsWithoutCodes: String = "-"
    var stationDescriptionsWithCodes: String = "-"
}

// MARK: - RouteDashboardInteractor Class
final class RouteDashboardInteractor: Interactor {
    let stationService = ServiceFactory.sharedInstance.stationFirestoreService
    let routeService = ServiceFactory.sharedInstance.routeFirestoreService
    let visitSummaryService = ServiceFactory.sharedInstance.visitSummaryFirestoreService
    let visitService = ServiceFactory.sharedInstance.visitFirestoreService
    let speciesService = ServiceFactory.sharedInstance.speciesFirestoreService
    let userService = ServiceFactory.sharedInstance.userService
}

// MARK: - RouteDashboardInteractor API
extension RouteDashboardInteractor: RouteDashboardInteractorApi {
    
    func currentUser() -> User? {
        return userService.currentUser
    }
    
    func saveRoute(route: Route) -> String {
        return routeService.add(route: route, completion: nil)
    }
    
    func retrieveVisitInformation(route: Route) {
        
        var information = VisitInformation()
        
        // Get all the visitSummaries for the Route
        self.visitSummaryService.get(recordedBetween: Date().add(0, 0, -100), endDate: Date(), routeId: route.id!) { (visitSummaries, error) in
            
            information.visitSummaries = visitSummaries
            
            // Assumes the latest result is the one at the end of the visitSummaries array
            information.lastVisitSummary = visitSummaries.first
            if let date = information.lastVisitSummary?.dateOfVisit {
                information.lastVisitedText = date.toString(format: "dd MMM yyyy, h:mm a")
            }
            
            information.numberOfVisits = visitSummaries.count
            
            // Aggregate stats across all the VisitSummaries, from the current month back 11 more months
            let thisYearsVisitSummaries = visitSummaries.filter({
                if let dateOfVisit = $0.dateOfVisit {
                    print("from: \(Date.dateFromComponents(1, Date().month, Date().year)!.add(0,-11,0))")
                    return dateOfVisit > Date.dateFromComponents(1, Date().month, Date().year)!.add(0,-11,0) && dateOfVisit < Date()
                } else {
                    return false
                }
            })
            
            information.killCounts = self.killCounts(visitSummaries: thisYearsVisitSummaries)
            information.poisonCounts = self.poisonCounts(visitSummaries: thisYearsVisitSummaries)
            
            self.presenter.didFetchVisitInformation(information: information)
        }
    }
    
    func retrieveRouteInformation(route: Route) {
        
        var information = RouteInformation()
        information.route = route
//        information.routeName = route.name
//        information.routeId = route.id
        
        // Get the route stations
        self.stationService.get(routeId: route.id!) { (stations) in
            
            // Station info
            information.stations = stations
            information.stationDescriptionsWithCodes = self.getStationsDescription(stations: stations, includeStationCodes: true)
            information.stationDescriptionsWithoutCodes = self.getStationsDescription(stations: stations, includeStationCodes: false)
            
            self.presenter.didFetchRouteInformation(information: information)
        }
    }
    
    // TODO: this is retrieving ALL stations - should name to this effect
    func retrieveStations(completion: (([Station]) -> Void)?) {
        stationService.get { (stations) in
            completion?(stations)
        }
    }
    
    func getStationsDescription(stations: [Station], includeStationCodes: Bool) -> String {
        return self.stationService.description(stations: stations, includeStationCodes: true)
    
    }
    
    func setRouteImage(route: Route, asset: PHAsset, completion: (() -> Swift.Void)?) {
        // TODO: update saved image service to Firebase too
//        ServiceFactory.sharedInstance.savedImageService.addOrUpdateSavedImage(asset: asset, completion: {
//            (savedImage) in
//            
//            // let presenter know we've got a new image.
//            if let routeId = route.id {
//                self.routeService.updateDashboardImage(routeId: routeId, savedImage: savedImage) { (error) in
//                    completion?()
//                }
//            }
//        })
    }
  
    func getStationSequence(fromStationId: String, toStationId: String, completion: (([Station], Error?) -> Void)?)  {
        
        self.stationService.getStationSequence(fromStationId: fromStationId, toStationId: toStationId) { (stations, error) in
            completion?(stations, nil)
        }
        //return ServiceFactory.sharedInstance.stationService.getStationSequence(from, to)
    }
    
    func killCounts(visitSummaries: [VisitSummary]) -> StackCount? {
        
        // this array of dictionaries will contain the kill counts by species for each bar (month) of the chart
        var killsByMonth = [[String: Int]]()
        var allSpeciesById = [String]()
        
        for barIndex in 0...11 {
            
            // offset from current month
            let monthOffset = -(12 - (barIndex + 1))
            let month = Date().add(0, monthOffset, 0).month
            
            // get the visitSummaries for the month
            let visitSummariesInMonth = visitSummaries.filter({ $0.dateOfVisit.month == month })
            
            // sum up all the kills by species for the VisitSummaries in this month
            var combinedKillsBySpecies = [String: Int]()
            for visitSummary in visitSummariesInMonth {
                combinedKillsBySpecies = visitSummary.totalKillsBySpecies.merging(combinedKillsBySpecies, uniquingKeysWith: { $0 + $1 })
            }
            
            // keep a record of each month's kills
            killsByMonth.append(combinedKillsBySpecies)
            
            // Keep a record of the species that were killed, we'll need this for the chart. The technique below uses the fact the Sets will force uniqueness.
            allSpeciesById = Array(Set(allSpeciesById + combinedKillsBySpecies.keys))
            
        }
        
        // We now need to convert the killsByMonth array of dictionaries into something the chart can use. Chart needs an array of species and a regular array (species by months) of counts. We have the array of species (allSpeciesById), so just need to create the array, which needs to have allSpeciesById.count rows and 12 columns.
        var counts = [[Int]](repeating: [Int](repeating: 0, count: allSpeciesById.count), count: 12)
        var monthIndex = 0
        for kills in killsByMonth {
            for kill in kills {
                
                // get the index of the species and put the value in the right position in yValues
                if let speciesIndex = allSpeciesById.firstIndex(where: { $0 == kill.key }) {
                    counts[monthIndex][speciesIndex] = kill.value
                }
            }
            monthIndex += 1
        }

        return StackCount(allSpeciesById, counts)
    }
    
    func poisonCounts(visitSummaries: [VisitSummary]) -> StackCount? {

        let stackLabels = ["Poison"]
        var counts = [[Int]](repeating: [Int](repeating: 0, count: 1), count: 12)
        
        for barIndex in 0...11 {
            
            // offset from current month
            let monthOffset = -(12 - (barIndex + 1))
            let month = Date().add(0, monthOffset, 0).month
            
            // get the visitSummaries for the month
            let visitSummariesInMonth = visitSummaries.filter({ $0.dateOfVisit.month == month })
            
            // add up the poison
            counts[barIndex][0] = visitSummariesInMonth.reduce(0, { (total, summary) -> Int in
                return total + summary.totalPoisonAdded
            })
        }
        return StackCount(stackLabels, counts)
    }
    
    func deleteRoute(routeId: String)
    {
        routeService.delete(routeId: routeId, completion: nil)
        presenter.didDeleteRoute()
    }
    
    func updateStationsOnRoute(routeId: String, stationIds: [String]) {
        routeService.replaceStationsOn(routeId: routeId, stationIds: stationIds) { (route, error) in
            //self.presenter.didSaveStationEdits()
        }
    }    
}

// MARK: - Interactor Viper Components Api
private extension RouteDashboardInteractor {
    var presenter: RouteDashboardPresenterApi {
        return _presenter as! RouteDashboardPresenterApi
    }
}
