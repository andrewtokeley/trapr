//
//  HomeWireframe.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class HomeWireframe: HomeWireframeInput {
    
    var view: HomeViewController!
    var presenter: HomePresenter!
    //var visitRouter: VisitWireframe!
    
    //MARK: - Initialisation
    
    init() {
        self.view = self.assembleModule() as! HomeViewController
    }
    
    private func assembleModule() -> HomeViewInterface {
        
        view = HomeViewController()
        view.presenter = HomePresenter()
        view.presenter?.view = view
        view.presenter?.menuWireframe = MenuWireframe()
        
        //visitWireframe = VisitWireframe()
        
        return view
    }
    
    /**
     Present the home view in the apps window
     */
    func presentView(in window: UIWindow) {
    
        if let _ = view {
            
            let nav = UINavigationController(rootViewController: view)
            window.rootViewController = nav
            window.makeKeyAndVisible()
        }
    }

}
