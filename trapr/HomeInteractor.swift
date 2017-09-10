//
//  HomeInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

class HomeInteractor: HomeInteractorInput {
    
    var presenter: HomeInteractorOutput?
    
    //MARK: - HomeInteractorInput
    
    func initialiseHomeModule() {
        
        // call into the model to get last 5 visits
        
        // convert the result into the VisitSummary array
        var dateComponent = DateComponents()
        dateComponent.month = 1
        
        var visitSummaries = [VisitSummary]()
        visitSummaries.append(VisitSummary(trapLinesDescription: "LW", dateOfVisit: Date()))
        
        visitSummaries.append(VisitSummary(trapLinesDescription: "LW", dateOfVisit: Calendar.current.date(byAdding: dateComponent, to: Date())!))
        
        visitSummaries.append(VisitSummary(trapLinesDescription: "GC, E, U", dateOfVisit: Calendar.current.date(byAdding: dateComponent, to: Date())!))
        
        presenter?.setRecentVisits(visits: visitSummaries)
    }
}
