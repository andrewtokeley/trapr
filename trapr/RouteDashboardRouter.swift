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
    
    func showVisitModule(visitSummary: VisitSummary) {
        // waiting on this one until I commit to converting Visit modules
        let module = AppModules.visit.build()
        
        // Remove title from back button
        _view.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let setup = VisitSetup()
        setup.visitSummary = visitSummary
        module.router.show(from: _view, embedInNavController: false, setupData: setup)
    }
    
//    func showVisitModule(visitSummary: VisitSummary) {
//        let module = AppModules.visit.build()
//        
//        // Remove title from back button
//        _view.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        
//        module.router.show(from: _view, embedInNavController: false, setupData: visitSummary)
//    }
    
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
    
    func showOrderStationsModule(routeId: String, stations: [Station]) {
        let module = AppModules.orderStations.build()
        let setupData = OrderStationsSetupData()
        setupData.stations = stations
        setupData.routeId = routeId
        
        // Remove title from back button
        _view.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        module.router.show(from: _view, embedInNavController: false, setupData: setupData)
    }
    
    func showVisitHistoryModule(visitSummaries: [VisitSummary]) {
        let module = AppModules.visitHistory.build()
        let setupData = VisitHistorySetupData()
        setupData.visitSummaries = visitSummaries
        setupData.delegate = _presenter as? VisitHistoryDelegate
        
        // Remove title from back button
        _view.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        module.router.show(from: _view, embedInNavController: false, setupData: setupData)
    }
    
//    func showVisitHistoryModule(route: Route) {
//        
//        let module = AppModules.visitHistory.build()
//        let setupData = VisitHistorySetupData()
//        setupData.route = route
//        
//        // Remove title from back button
//        _view.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        
//        module.router.show(from: _view, embedInNavController: false, setupData: setupData)
//    }
}

// MARK: - RouteDashboard Viper Components
private extension RouteDashboardRouter {
    var presenter: RouteDashboardPresenterApi {
        return _presenter as! RouteDashboardPresenterApi
    }
}
