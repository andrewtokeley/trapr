//
//  HomePresenter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class HomePresenter: HomeInteractorOutput, HomeModuleInterface {
    
    var view: HomeViewInterface?
    var interactor: HomeInteractorInput?
    var router: HomeWireframe?
    var menuWireframe: MenuWireframeInput?
    
    //MARK: - HomeInteractorOutput
    
    func setRecentVisits(visits: [VisitSummary]?) {
        view?.displayRecentVisits(visits: visits)
    }
    
    func askForNewVisitDate(completion: () -> Date) {
        
    }
    
    //MARK: - HomeModuleInterface
    
    func didSelectMenu() {
        if let _ = view {
            menuWireframe?.presentView(over: view as! UIViewController)
        }
    }
    
    func didSelectNewVisit() {
        let visitSummary = VisitSummary(dateOfVisit: Date())
        router?.presentVisitModule(visitSummary: visitSummary)
    }
    
    func didSelectVisitSummary(visitSummary: VisitSummary) {
        router?.presentVisitModule(visitSummary: visitSummary)
    }
    
    func viewWillAppear() {
        view?.setTitle(title: "Home")
        
        interactor?.initialiseHomeModule()
    }
}
