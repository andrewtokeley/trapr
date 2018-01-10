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
    
    var mapBottomConstaint: NSLayoutConstraint?
    var mapTopConstraint: NSLayoutConstraint?
    
    //MARK: - Constants
    
    //MARK: - Subviews
    
//    lazy var barChartKills: BarChartView = {
//        
//    }()
    
    lazy var editDescription: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.white
        label.tintColor = UIColor.trpTextDark
        label.font = UIFont.trpLabelNormal
        label.alpha = 0 // hide initially
        label.textAlignment = .center
        return label
    }()
    
    lazy var editStationOptions: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.alpha = 0
        
        view.addSubview(self.resetStationsButton)
        self.resetStationsButton.autoAlignAxis(toSuperviewAxis: .vertical)
        self.resetStationsButton.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        return view
    }()
    
    lazy var editOrderOptions: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.alpha = 0
        
        view.addSubview(self.reverseOrderButton)
        view.addSubview(self.resetOrderButton)
        view.addSubview(self.clearOrderButton)
        
        self.reverseOrderButton.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.spacingMargin)
        self.reverseOrderButton.autoSetDimension(.width, toSize: 80)
        self.reverseOrderButton.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        self.resetOrderButton.autoAlignAxis(toSuperviewAxis: .vertical)
        self.resetOrderButton.autoAlignAxis(toSuperviewAxis: .horizontal)
        self.resetOrderButton.autoSetDimension(.width, toSize: 80)
        
        self.clearOrderButton.autoAlignAxis(toSuperviewAxis: .horizontal)
        self.clearOrderButton.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.spacingMargin)
        self.clearOrderButton.autoSetDimension(.width, toSize: 80)
        
        return view
    }()
    
    lazy var resetOrderButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reset", for: .normal)
        button.addTarget(self, action: #selector(resetOrder(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var clearOrderButton: UIButton = {
        let button = UIButton()
        button.setTitle("Clear", for: .normal)
        button.addTarget(self, action: #selector(clearOrder(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var reverseOrderButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reverse", for: .normal)
        button.addTarget(self, action: #selector(reverseOrder(sender:)), for: .touchUpInside)
        return button
    }()
    lazy var resetStationsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reset", for: .normal)
        button.addTarget(self, action: #selector(resetStations(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var routeNameTextField: UITextField = {
    
        let textField = UITextField()
        textField.placeholder = "Route name"
        textField.delegate = self
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = UIReturnKeyType.done
        return textField
    }()
    
    lazy var mapViewControllerHost: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    lazy var mapViewController: StationMapViewController? = {
        return self.childViewControllers.first as? StationMapViewController
    }()
    
    lazy var editDoneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(editDoneButtonClick(sender:)))
        return button
    }()
    
    lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "show"), style: .plain, target: self, action: #selector(editButtonClick(sender:)))
        return button
    }()
    
    lazy var cancelEditButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelEditButtonClick(sender:)))
        return button
    }()
    
    lazy var closeButton: UIBarButtonItem = {
        var view = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(closeButtonClick(sender:)))
        return view
    }()
    
    
    
    //MARK: - Events
    
    func resetOrder(sender: UIButton) {
        presenter.didSelectResetOrder()
    }
    
    func clearOrder(sender: UIButton) {
        presenter.didSelectClearOrder()
    }
    
    func reverseOrder(sender: UIButton) {
        presenter.didSelectReverseOrder()
    }
    
    func resetStations(sender: UIButton) {
        presenter.didSelectResetStations()
    }
    
    func closeButtonClick(sender: UIButton) {
        presenter.didSelectClose()
    }
    
    func editButtonClick(sender: UIButton) {
        presenter.didSelectEditMenu()
    }

    func cancelEditButtonClick(sender: UIButton) {
        presenter.didSelectEditCancel()
    }
    
    func editDoneButtonClick(sender: UIButton) {
        presenter.didSelectEditDone()
    }

    func resizeButtonClick(sender: UIButton) {
        //presenter.didSelectEdit()
    }
    
    //MARK: - UIViewController
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.trpBackground
        
        // ensure the keyboard disappears when click view
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        self.view.addSubview(routeNameTextField)
        self.view.addSubview(mapViewControllerHost)
        self.view.addSubview(editDescription)
        self.view.addSubview(editStationOptions)
        self.view.addSubview(editOrderOptions)
        
        setConstraints()
    }
    
    func setConstraints() {
        
        routeNameTextField.autoPin(toTopLayoutGuideOf: self, withInset: LayoutDimensions.spacingMargin)
        routeNameTextField.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.spacingMargin)
        routeNameTextField.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.spacingMargin)
        routeNameTextField.autoSetDimension(.height, toSize: LayoutDimensions.inputHeight)
        
        mapTopConstraint = mapViewControllerHost.autoPin(toTopLayoutGuideOf: self, withInset: LayoutDimensions.inputHeight + 2 * LayoutDimensions.spacingMargin)
        mapViewControllerHost.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        mapViewControllerHost.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        mapBottomConstaint = mapViewControllerHost.autoPinEdge(toSuperviewEdge: .bottom, withInset: 300)
        
        editDescription.autoPinEdge(.left, to: .left, of: mapViewControllerHost)
        editDescription.autoPinEdge(.right, to: .right, of: mapViewControllerHost)
        editDescription.autoPinEdge(.top, to: .top, of: mapViewControllerHost)
        editDescription.autoSetDimension(.height, toSize: LayoutDimensions.inputHeight)
        
        editStationOptions.autoPinEdge(.left, to: .left, of: mapViewControllerHost)
        editStationOptions.autoPinEdge(.right, to: .right, of: mapViewControllerHost)
        editStationOptions.autoPinEdge(.bottom, to: .bottom, of: mapViewControllerHost)
        editStationOptions.autoSetDimension(.height, toSize: LayoutDimensions.inputHeight)
        
        editOrderOptions.autoPinEdge(.left, to: .left, of: mapViewControllerHost)
        editOrderOptions.autoPinEdge(.right, to: .right, of: mapViewControllerHost)
        editOrderOptions.autoPinEdge(.bottom, to: .bottom, of: mapViewControllerHost)
        editOrderOptions.autoSetDimension(.height, toSize: LayoutDimensions.inputHeight)

    }
}

extension RouteDashboardView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        presenter.didUpdateRouteName(name: textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

//MARK: - RouteDashboardView API
extension RouteDashboardView: RouteDashboardViewApi {
    
    func showEditDescription(_ show: Bool, description: String? = nil) {
        editDescription.alpha = show ? 1 : 0
        editDescription.text = description
    }
    
    func showEditStationOptions(_ show: Bool) {
        editStationOptions.alpha = show ? 1 : 0
    }
    
    func showEditOrderOptions(_ show: Bool) {
        editOrderOptions.alpha = show ? 1 : 0
    }
    
    func showEditNavigation(_ show: Bool) {
        if show {
            self.navigationItem.leftBarButtonItem = self.cancelEditButton
            self.navigationItem.rightBarButtonItem = self.editDoneButton
        } else {
            self.navigationItem.leftBarButtonItem = self.closeButton
            self.navigationItem.rightBarButtonItem = self.editButton
        }
    }
    
    func reapplyStylingToAnnotationViews() {
        self.mapViewController?.reapplyStylingToAnnotationViews()
    }
    
    func reloadMap(forceAnnotationRebuild: Bool = false) {
        self.mapViewController?.reload(forceRebuildOfAnnotations: forceAnnotationRebuild)
    }
    
    func setAlphaEditDoneButton(_ alpha: CGFloat) {
        //self.editDoneButton.alpha = alpha
    }
    
    func displayFullScreenMap() {
        UIView.animate(withDuration: 0.5, animations: {
            self.mapBottomConstaint?.constant = 0
            self.view.layoutIfNeeded()
        })
        UIView.animate(withDuration: 0.5, animations: {
            self.mapTopConstraint?.constant = 0
            self.view.layoutIfNeeded()
        })
        
    }
    
    func displayCollapsedMap() {
        UIView.animate(withDuration: 0.5, animations: {
            self.mapBottomConstaint?.constant = -300
            self.view.layoutIfNeeded()
        })
        UIView.animate(withDuration: 0.5, animations: {
            self.mapTopConstraint?.constant = LayoutDimensions.inputHeight + 2 * LayoutDimensions.spacingMargin
            self.view.layoutIfNeeded()
        })
    }
    
    func displayTitle(_ title: String) {
        self.title = title
    }
    
    func displayRouteName(_ name: String?) {
        routeNameTextField.text = name
    }
    
    func setVisibleRegionToCentreOfStations(distance: Double) {
        self.mapViewController?.setVisibleRegionToCentreOfStations(distance: distance)
    }
    
    func setVisibleRegionToHighlightedStations() {
        mapViewController?.setVisibleRegionToHighlightedStations()
    }
    
    func setVisibleRegionToAllStations() {
        mapViewController?.setVisibleRegionToAllStations()
    }
    
    func getMapContainerView() -> UIView {
        return mapViewControllerHost
    }
    
    func enableToggleHighlightMode(_ enable: Bool) {
        //mapViewController?.enableToggleHighlightMode(enable)
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
