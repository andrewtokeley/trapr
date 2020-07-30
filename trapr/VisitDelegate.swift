//
//  VisitDelegate.swift
//  trapr
//
//  Created by Andrew Tokeley  on 26/10/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

protocol VisitDelegate {
    //func didChangeVisit(visit: Visit?)
    //func didChangeVisit(visit: VisitEx?)
    
    //func didChangeVisit(routeId: String, stationId: String, trapTypeId: String, hasCatchData: Bool, visit: VisitEx?)
    //func didFetchTrapTypes(trapTypes: [TrapType])
    
    func didNavigateToTrap(stationId: String, trapDescription: String)
    
    /**
     This delegate method is called whenever a user navigates to a new trap and a new visit for the trap is available. Delegates include *VisitLogPresenter* and *TrapStatisticsPresenter*
     */
    func didRetrieveVisit(visit: VisitEx?)
    
    /**
     This delegate method is called whenever a user navigates to a new trap and a new set of statistics about that trap are available. Delegates include *VisitLogPresenter* and *TrapStatisticsPresenter*.
     */
    func didRetrieveTrapStatistics(statistics: TrapStatistics?, trapTypeStatistics: TrapTypeStatistics?, showCatchData: Bool)
}

/**
 To avoid implementors having to implement both methods.
 */
extension VisitDelegate {
    
    func didRetrieveVisit(visit: VisitEx?) {
        // do nothing
    }
    
    func didRetrieveTrapStatistics(statistics: TrapStatistics?, trapTypeStatistics: TrapTypeStatistics?, showCatchData: Bool) {
        // do nothing
    }
    
    func didNavigateToTrap(stationId: String, trapDescription: String) {
        // do nothing
    }
}
