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
        
    }
    
    func viewWillAppear() {
        view?.setTitle(title: "Home")
    }
}
