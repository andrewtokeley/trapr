//
//  RouteDashboardView.swift
//  trapr
//
//  Created by Andrew Tokeley on 2/01/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import UIKit
import Viperit
import MapKit

//MARK: RouteDashboardView Class
final class RouteDashboardView: UserInterface {
    
    //MARK: - Constants
    
    //MARK: - Subviews
    
    lazy var routeNameTextField: UITextField = {
    
        let textField = UITextField()
        textField.placeholder = "Route name"
        return textField
    }()
    
    lazy var mapViewControllerHost: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var mapViewController: StationMapViewController? = {
        return self.childViewControllers.first as? StationMapViewController
    }()
    
    lazy var closeButton: UIBarButtonItem = {
        
        var view = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(closeButtonClick(sender:)))
        
        return view
    }()
    
    //MARK: - Events
    func closeButtonClick(sender: UIButton) {
        presenter.didSelectClose()
    }
    
    //MARK: - UIViewController
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.trpBackground
        self.navigationItem.leftBarButtonItem = closeButton
        
        self.view.addSubview(routeNameTextField)
        self.view.addSubview(mapViewControllerHost)
        
        setConstraints()
    }
    
    func setConstraints() {
        
        routeNameTextField.autoPin(toTopLayoutGuideOf: self, withInset: LayoutDimensions.spacingMargin)
        routeNameTextField.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.spacingMargin)
        routeNameTextField.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.spacingMargin)
        routeNameTextField.autoSetDimension(.height, toSize: LayoutDimensions.inputHeight)
        
        mapViewControllerHost.autoPinEdge(.top, to: .bottom, of: routeNameTextField, withOffset: LayoutDimensions.spacingMargin)
        mapViewControllerHost.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        mapViewControllerHost.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        mapViewControllerHost.autoSetDimension(.height, toSize: 0.4 * self.view.frame.height)
    }
}

//MARK: - RouteDashboardView API
extension RouteDashboardView: RouteDashboardViewApi {
    
    func displayTitle(_ title: String) {
        self.title = title
    }
    
    func displayRouteName(_ name: String?) {
        routeNameTextField.text = name
    }
    
    func displayStationsOnMap(stations: [Station], highlightedStations: [Station]?) {
        mapViewController?.showOnlyHighlighted()
        mapViewController?.setVisibleRegionToHighlightedStations()
        mapViewController?.enableToggleHighlightMode(true)
    }
    
    func getMapContainerView() -> UIView {
        return mapViewControllerHost
    }
}

// MARK: - RouteDashboardView Viper Components API
private extension RouteDashboardView {
    var presenter: RouteDashboardPresenterApi {
        return _presenter as! RouteDashboardPresenterApi
    }
    var displayData: RouteDashboardDisplayData {
        return _displayData as! RouteDashboardDisplayData
    }
}
