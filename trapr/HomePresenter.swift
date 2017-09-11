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
    
    //MARK: - HomeModuleInterface
    
    func didSelectMenu() {
        if let _ = view {
            menuWireframe?.presentView(over: view as! UIViewController)
        }
    }
    
    func didSelectNewVisit() {
        router?.presentVisitView(with: nil)
    }
    
    func didSelectVisit() {
        let visit = Visit()
        visit.date = Date()
        router?.presentVisitView(with: visit)
    }
    
    func viewWillAppear() {
        view?.setTitle(title: "Home")
        
        interactor?.initialiseHomeModule()
    }
}
