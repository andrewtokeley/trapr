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
    var killCountsDescription: String?
    var killCountsLastPeriod: StackCount?
    var killCountsLastPeriodDescription: String?
    
    var poisonCounts: StackCount?
    var poisonCountsDescription: String?
    var poisonCountsLastPeriod: StackCount?
    var poisonCountsLastPeriodDescription: String?
    
    var averageLureUsage = [String: Int]()
}

struct RouteInformation {
    var route: Route?
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
    let trapStatisticsService = ServiceFactory.sharedInstance.trapStatisticsService
    
}

// MARK: - RouteDashboardInteractor API
extension RouteDashboardInteractor: RouteDashboardInteractorApi {
    
    func currentUser() -> User? {
        return userService.currentUser
    }
    
    func saveRoute(route: Route) -> String {
        return routeService.add(route: route, completion: nil)
    }
    
    func retrieveStationKillCounts(route: Route, trapTypeId: String?, completion: (([String: Int], Error?) -> Void)?) {

        if let id = route.id {
            
            trapStatisticsService.getTrapStatistics(routeId: id, trapTypeId: trapTypeId) { (statisticsByStation, error) in
                
                // result will be a dictionary where the key is the Station code (e.g. LW01) and the value is the count of kills
                var result = [String: Int]()
                
                for stationCode in statisticsByStation.keys {
                    result[stationCode] = statisticsByStation[stationCode]!.totalCatches
                }
                
                completion?(result, error)
            }
        }
    }
    
    func retrieveVisitInformation(route: Route, completion: ((VisitInformation?, Error?) -> Void)?) {
        
        var information = VisitInformation()
        
        // Get all the visitSummaries for the Route
        self.visitSummaryService.get(recordedBetween: Date().add(0, 0, -100), endDate: Date(), routeId: route.id!) { (visitSummaries, error) in
            
            information.visitSummaries = visitSummaries
            
            // Assumes the latest result is the first item of the visitSummaries array
            information.lastVisitSummary = visitSummaries.first
            if let date = information.lastVisitSummary?.dateOfVisit {
                information.lastVisitedText = date.toString(format: "dd MMM yyyy, h:mm a")
            }
            
            information.numberOfVisits = visitSummaries.count
            
            // Aggregate stats across all the VisitSummaries
            
            // 11 months before the beggining of the current month
            var fromDate = Date.dateFromComponents(1, Date().month, Date().year)!.add(0,-11,0)
            var toDate = Date()
            information.killCountsDescription = fromDate.toString(format: "MMM YYYY") + " - " + toDate.toString(format: "MMM YYYY")
            information.poisonCountsDescription = information.killCountsDescription
            let thisYearsVisitSummaries = visitSummaries.filter({
                if let dateOfVisit = $0.dateOfVisit {
                    return dateOfVisit > fromDate && dateOfVisit < toDate
                } else {
                    return false
                }
            })
            
            // 1 year, 11 months before the begining of the current month
            fromDate = Date.dateFromComponents(1, Date().month, Date().year)!.add(0,-23,0)
            toDate = Date.dateFromComponents(1, Date().month, Date().year)!.add(0,-12,0)
            information.killCountsLastPeriodDescription = fromDate.toString(format: "MMM YYYY") + " - " + toDate.toString(format: "MMM YYYY")
            information.poisonCountsLastPeriodDescription = information.killCountsLastPeriodDescription
            let lastYearsVisitSummaries = visitSummaries.filter({
                if let dateOfVisit = $0.dateOfVisit {
                    return dateOfVisit > fromDate && dateOfVisit < toDate
                } else {
                    return false
                }
            })
            
            // Calculate the average lure usage in the last 3 visits
            
            // this will contain the count of each lure across, at most, the last 3 visits.
            // e.g "Rabbit": [4, 3, 0] means rabbit was used 4, 3, 0 times in the last 3 visits.
            var lureUsage = [String: [Int]]()
            
            // loop through last 5 visits (assumes first summary is the latest and they're ordered)
            for i in 0...4 {
                if i < visitSummaries.count {
                    let summary = visitSummaries[i]
                    
                    // unique lure used for this visit
                    let uniqueLures = Set(summary.visits.map({ $0.lureId }))
                    
                    for lureId in uniqueLures {
                        if let lureId = lureId {
                            if lureUsage[lureId] == nil {
                                lureUsage[lureId] = [Int]()
                            }
                            let totalAdded = summary.visits.filter({ $0.lureId == lureId }).map({ $0.baitAdded }).reduce(0, +)
                            lureUsage[lureId]!.append(totalAdded)
                        }
                    }
                }
            }
            
            let averageLureUsage = lureUsage.mapValues({ $0.reduce(0, + )/$0.count })
            information.averageLureUsage = averageLureUsage
            
            information.killCounts = self.killCounts(visitSummaries: thisYearsVisitSummaries)
            information.killCountsLastPeriod = self.killCounts(visitSummaries: lastYearsVisitSummaries, orderbyCounts: false, orderByLabels: information.killCounts?.labels)
            
            information.poisonCounts = self.poisonCounts(visitSummaries: thisYearsVisitSummaries)
            information.poisonCountsLastPeriod = self.poisonCounts(visitSummaries: lastYearsVisitSummaries)
            
            completion?(information, error)
        }
    }

    
    func retrieveRouteInformation(route: Route, completion: ((RouteInformation?, Error?) -> Void)?) {
        
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
            
            completion?(information, nil)
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
    
    
    func killCounts(visitSummaries: [VisitSummary], orderbyCounts: Bool = true, orderByLabels: [String]? = nil) -> StackCount? {
        
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
        
        if orderbyCounts {
            // Order the species by the number of kills (first element will have the most kills), otherwise we're relying on the order of the dictionary elements and this isn't consistent.
            allSpeciesById.sort(by: {
                let speciesId0 = $0
                let killCount0 = visitSummaries.reduce(0, { $0 + ($1.totalKillsBySpecies[speciesId0] ?? 0)})
                
                let speciesId1 = $1
                let killCount1 = visitSummaries.reduce(0, { $0 + ($1.totalKillsBySpecies[speciesId1] ?? 0 )})
                
                return killCount0 > killCount1
            })
        } else if let orderByLabels = orderByLabels {
            
            // now we want to order the species as close to the ordering we're given
            
            print("orderByLabels: \(orderByLabels)")
            // we're ordering by the name of the species
            let speciesByName = allSpeciesById.map( { SpeciesCode(rawValue: $0)?.name ?? "Unknown"})
            print("speciesByName: \(speciesByName)")
            
            // the names of the species that are in the orderByLabels array - these must go first
            var orderedSpeciesByName = orderByLabels.filter({ speciesByName.contains($0)})
            
            // the names that weren't mentioned in the orderByLabels array - these get tagged on to the end
            orderedSpeciesByName.append(contentsOf: speciesByName.filter({ !orderByLabels.contains($0) }))
            
            // convert the names back into ids
            allSpeciesById = orderedSpeciesByName.map {
                // index of the name in the unordered species names
                let index = speciesByName.firstIndex(of: $0)!
                return allSpeciesById[index]
            }
            
//            // add any species that aren't in the orderedLabels to the end
//            for species
//            // filter the orderByLabels to the ones we have here too
//            var orderedAllSpeciesById = orderByLabels.map {
//                if let index = speciesByName.firstIndex(of: $0) {
//
//                }
//            }
//
//            // add any species that weren't in the orderedByLabels array to the end
//            orderedAllSpeciesById.append(contentsOf: speciesByName.filter({ !orderByLabels.contains($0)}))
//            print("allSpeciesById (before): \(allSpeciesById)")
//            allSpeciesById = orderedAllSpeciesById
//            print("allSpeciesById: \(allSpeciesById)")
//
//            // get the index offset for the new ordering
//            var unmatchedIndex = orderByLabels.count
//            let offsets = speciesByName.map({ (speciesName) -> Int in
//                if let index = orderByLabels.firstIndex(of: speciesName) {
//                    // this is the index our species needs to move to
//                    return index
//                } else {
//                    // if we have a species that's not in the ordering we're given then set the index to the end of the array
//                    unmatchedIndex -= 1
//                    return unmatchedIndex
//                }
//            })
//
            // reorder the species array by the offsets
            
//            let allSpeciesTemp = allSpeciesById
//            allSpeciesById = offsets.map { allSpeciesTemp[$0] }
//            print("speciesByName: \(speciesByName)")
//            print("orderByLabels: \(orderByLabels)")
            
        }
        
        // We now need to convert the killsByMonth array of dictionaries into something the chart can use. Chart needs an array of species and a regular array (species by months) of counts. We have the array of species (allSpeciesById), so just need to create the array, which needs to have allSpeciesById.count rows and 12 columns.
        var counts = [[Int]](repeating: [Int](repeating: 0, count: allSpeciesById.count), count: 12)
        var monthIndex = 0
        for kills in killsByMonth {
            
            // for each month, iterate through the kills for each species
            for kill in kills {
                
                // get the index of the species and put the value in the right position in yValues
                if let speciesIndex = allSpeciesById.firstIndex(where: { $0 == kill.key }) {
                    counts[monthIndex][speciesIndex] = kill.value
                }
            }
            monthIndex += 1
        }

        return StackCount(allSpeciesById.map( { SpeciesCode(rawValue: $0)?.name ?? "Unknown"}),   counts)
    }
    
    func poisonCounts(visitSummaries: [VisitSummary]) -> StackCount? {

        // this array of dictionaries will contain the kill counts by species for each bar (month) of the chart
        var lureCountsByMonthAndLureType = [[String: Int]]()
        var allLureTypesById = [String]()
        
        for barIndex in 0...11 {
            
            // offset from current month
            let monthOffset = -(12 - (barIndex + 1))
            let month = Date().add(0, monthOffset, 0).month
            
            // get the visitSummaries for the month
            let visitSummariesInMonth = visitSummaries.filter({ $0.dateOfVisit.month == month })
            
            // sum up all the lure counts by lureId for the VisitSummaries in this month
            var combinedCountsByLureId = [String: Int]()
            for visitSummary in visitSummariesInMonth {
                combinedCountsByLureId =
                    visitSummary.totalBaitAddedByLure.merging(combinedCountsByLureId, uniquingKeysWith: { $0 + $1 })
            }
            
            // keep a record of each month's kills
            lureCountsByMonthAndLureType.append(combinedCountsByLureId)
            
            // Keep a record of the lure types that were counted, we'll need this for the chart. The technique below uses the fact the Sets will force uniqueness.
            allLureTypesById = Array(Set(allLureTypesById + combinedCountsByLureId.keys))
        }
        
        // Order the species by the number of kills (first element will have the most kills), otherwise we're relying on the order of the dictionary elements and this isn't consistent.
        allLureTypesById.sort(by: {
            let lureId0 = $0
            let baitAddedCount0 = visitSummaries.reduce(0, { $0 + ($1.totalBaitAddedByLure[lureId0] ?? 0)})
            
            let lureId1 = $1
            let baitAddedCount1 = visitSummaries.reduce(0, { $0 + ($1.totalBaitAddedByLure[lureId1] ?? 0 )})
            
            return baitAddedCount0 > baitAddedCount1
        })
        
        // We now need to convert the killsByMonth array of dictionaries into something the chart can use. Chart needs an array of species and a regular array (species by months) of counts. We have the array of species (allSpeciesById), so just need to create the array, which needs to have allSpeciesById.count rows and 12 columns.
        var counts = [[Int]](repeating: [Int](repeating: 0, count: allLureTypesById.count), count: 12)
        var monthIndex = 0
        for baitAddedCounts in lureCountsByMonthAndLureType {
            
            // for each month, iterate through the kills for each species
            for count in baitAddedCounts {
                
                // get the index of the lure and put the value in the right position in yValues
                if let luresIndex = allLureTypesById.firstIndex(where: { $0 == count.key }) {
                    counts[monthIndex][luresIndex] = count.value
                }
            }
            monthIndex += 1
        }

        return StackCount(allLureTypesById.map( { LureCode(rawValue: $0)?.name ?? "Unknown"}),   counts)
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
