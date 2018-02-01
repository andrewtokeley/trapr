//
//  RouteDashboardRouter.swift
//  trapr
//
//  Created by Andrew Tokeley on 2/01/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit
import UIKit

// MARK: - RouteDashboardRouter class
final class RouteDashboardRouter: Router {
}

// MARK: - RouteDashboardRouter API
extension RouteDashboardRouter: RouteDashboardRouterApi {
    
    /**
     Add a MapViewController instance as a child of the RouteDashboard view
     */
    func addMapAsChildView(containerView: UIView) {
        
        let mapViewController = StationMapViewController()
        mapViewController.delegate = presenter as? StationMapDelegate
        
        _view.addChildViewController(mapViewController)
        containerView.addSubview(mapViewController.view)
        mapViewController.view.autoPinEdgesToSuperviewEdges()
        mapViewController.didMove(toParentViewController: _view)
    }
    
    func showVisitHistoryModule(route: Route) {
        
        let module = AppModules.visitHistory.build()
        let setupData = VisitHistorySetupData()
        setupData.route = route
        
        // Remove title from back button
        _view.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        module.router.show(from: _view, embedInNavController: false, setupData: setupData)
    }
}

// MARK: - RouteDashboard Viper Components
private extension RouteDashboardRouter {
    var presenter: RouteDashboardPresenterApi {
        return _presenter as! RouteDashboardPresenterApi
    }
}
