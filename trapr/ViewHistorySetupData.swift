//
//  ViewHistorySetup.swift
//  trapr
//
//  Created by Andrew Tokeley on 1/02/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation

class VisitHistorySetupData {
    //var route: Route?
    var visitSummaries: [VisitSummary]?
    var delegate: VisitHistoryDelegate?
}

protocol VisitHistoryDelegate {
    /// Called by the VisitHistory module to let the calling module (RouteDashboard) know whether any visits have been deleted. This will allow the calling module to refresh itself.
    func visitHistoryIsAboutToClose(deletedVisits: Bool)
}
