//
//  MapRouter.swift
//  trapr
//
//  Created by Andrew Tokeley on 28/12/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - MapRouter class
final class MapRouter: Router {
    /**
     Add a MapViewController instance as a child of the RouteDashboard view
     */
    func addMapAsChildView(containerView: UIView) {
        
        let mapViewController = StationMapViewController()
        mapViewController.delegate = presenter as? StationMapDelegate
        
        viewController.addChildViewController(mapViewController)
        containerView.addSubview(mapViewController.view)
        mapViewController.view.autoPinEdgesToSuperviewEdges()
        mapViewController.didMove(toParentViewController: viewController)
    }
}

// MARK: - MapRouter API
extension MapRouter: MapRouterApi {
}

// MARK: - Map Viper Components
private extension MapRouter {
    var presenter: MapPresenterApi {
        return _presenter as! MapPresenterApi
    }
}
