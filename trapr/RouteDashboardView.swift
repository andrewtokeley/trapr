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
import Charts

//MARK: RouteDashboardView Class
final class RouteDashboardView: UserInterface {
    
    var mapBottomConstaint: NSLayoutConstraint?
    var mapTopConstraint: NSLayoutConstraint?
    
    var killNumberOfBars: Int = 0
    var poisonNumberOfBars: Int = 0
    var poisonCountFunction: ((Int) -> Int)?
    
    //MARK: - Subviews
    
    lazy var scrollViewContentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.addSubview(scrollViewContentView)
        scrollView.contentSize = CGSize(width: 200, height: 400)
        
        scrollViewContentView.addSubview(barChartKills)
        scrollViewContentView.addSubview(barChartKillsTitle)
        scrollViewContentView.addSubview(barChartPoison)
        scrollViewContentView.addSubview(barChartPoisonTitle)
        
        return scrollView
    }()
    
    lazy var barChartKillsTitle: UILabel = {
        let label = UILabel()
        label.text = "CATCH"
        label.textAlignment = .center
        label.font = UIFont.trpLabelSmall
        return label
    }()
    
    lazy var barChartKills: BarChartViewEx = {
        let chart = BarChartViewEx()
        chart.drawGridBackgroundEnabled = false
        chart.chartDescription = nil
        chart.legend.enabled = true
        chart.legend.direction = .leftToRight
        
        // configure x axis
        let xAxis = chart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        xAxis.valueFormatter = self
        xAxis.granularity = 1
        xAxis.labelCount = 12
        
        let yAxis = chart.getAxis(.left)
        yAxis.drawGridLinesEnabled = true
        yAxis.gridColor = UIColor.trpChartGridlines
        yAxis.granularity = 1
        chart.getAxis(.right).granularity = 1
        return chart
    }()
    
    lazy var barChartPoisonTitle: UILabel = {
        let label = UILabel()
        label.text = "POISON"
        label.textAlignment = .center
        label.font = UIFont.trpLabelSmall
        return label
    }()
    
    lazy var barChartPoison: BarChartViewEx = {
        let chart = BarChartViewEx()
        chart.drawGridBackgroundEnabled = false
        chart.chartDescription = nil
        chart.legend.enabled = false
        chart.legend.direction = .leftToRight
        
        // configure x axis
        let xAxis = chart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        xAxis.valueFormatter = self
        xAxis.granularity = 1
        xAxis.labelCount = 12

        let yAxis = chart.getAxis(.left)
        yAxis.drawGridLinesEnabled = true
        yAxis.gridColor = UIColor.trpChartGridlines
        yAxis.granularity = 1
        chart.getAxis(.right).granularity = 1
        return chart
    }()
    
    lazy var editDescription: VerticallyCentredTextView = {
        let label = VerticallyCentredTextView()
        
        label.isEditable = false
        label.backgroundColor = UIColor.white
        label.tintColor = UIColor.trpTextDark
        label.font = UIFont.trpLabelSmall
        label.alpha = 0 // hide initially
        label.textAlignment = .center
        return label
    }()
    
    lazy var editStationOptions: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.alpha = 0
        
//        view.addSubview(self.resetStationsButton)
//        self.resetStationsButton.autoAlignAxis(toSuperviewAxis: .horizontal)
//        self.resetStationsButton.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.spacingMargin)
        
        view.addSubview(self.selectAllStationsOnTraplineButton)
        self.selectAllStationsOnTraplineButton.autoAlignAxis(toSuperviewAxis: .horizontal)
        self.selectAllStationsOnTraplineButton.autoAlignAxis(toSuperviewAxis: .vertical)
        //self.selectAllStationsOnTraplineButton.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.spacingMargin)
        
        return view
    }()
    
    lazy var editOrderOptions: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.alpha = 0
        
        view.addSubview(self.reverseOrderButton)
        //view.addSubview(self.resetOrderButton)
        view.addSubview(self.clearOrderButton)
        
        self.reverseOrderButton.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.spacingMargin)
        self.reverseOrderButton.autoSetDimension(.width, toSize: 80)
        self.reverseOrderButton.autoAlignAxis(toSuperviewAxis: .horizontal)
        
//        self.resetOrderButton.autoAlignAxis(toSuperviewAxis: .vertical)
//        self.resetOrderButton.autoAlignAxis(toSuperviewAxis: .horizontal)
//        self.resetOrderButton.autoSetDimension(.width, toSize: 80)
        
        self.clearOrderButton.autoAlignAxis(toSuperviewAxis: .horizontal)
        self.clearOrderButton.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.spacingMargin)
        self.clearOrderButton.autoSetDimension(.width, toSize: 80)
        
        return view
    }()
    
//    lazy var resetOrderButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Reset", for: .normal)
//        button.setTitleColor(UIColor.trpButtonEnabled, for: .normal)
//        button.addTarget(self, action: #selector(resetOrder(sender:)), for: .touchUpInside)
//        return button
//    }()
    
    lazy var clearOrderButton: UIButton = {
        let button = UIButton()
        button.setTitle("Clear", for: .normal)
        button.addTarget(self, action: #selector(clearOrder(sender:)), for: .touchUpInside)
        button.setTitleColor(UIColor.trpButtonEnabled, for: .normal)
        return button
    }()
    
    lazy var reverseOrderButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reverse", for: .normal)
        button.addTarget(self, action: #selector(reverseOrder(sender:)), for: .touchUpInside)
        button.setTitleColor(UIColor.trpButtonEnabled, for: .normal)
        return button
    }()
    
//    lazy var resetStationsButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Undo", for: .normal)
//        button.setTitleColor(UIColor.trpButtonEnabled, for: .normal)
//        button.addTarget(self, action: #selector(resetStations(sender:)), for: .touchUpInside)
//        return button
//    }()
    
    lazy var selectAllStationsOnTraplineButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select All Stations", for: .normal)
        button.addTarget(self, action: #selector(selectAllStations(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var routeNameTextField: UITextField = {
    
        let textField = UITextField()
        textField.placeholder = "Route name"
        textField.delegate = self
        textField.textAlignment = .center
        textField.returnKeyType = UIReturnKeyType.done
        return textField
    }()
    
    lazy var mapViewControllerHost: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    lazy var mapViewController: StationMapViewController? = {
        let map = self.childViewControllers.first as? StationMapViewController
        map?.showUserLocation(true)
        return self.childViewControllers.first as? StationMapViewController
    }()
    
    lazy var editDoneButton: UIBarButtonItem = {
        
        let button = UIButton()
        button.addTarget(self, action: #selector(editDoneButtonClick(sender:)), for: .touchUpInside)
        button.setTitle("Save", for: .normal)
        let barButton = UIBarButtonItem(customView: button)
        return barButton
    }()
    
    lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "show"), style: .plain, target: self, action: #selector(editButtonClick(sender:)))
        return button
    }()
    
    lazy var closeButton: UIBarButtonItem = {
        var view = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(closeButtonClick(sender:)))
        return view
    }()
    
    lazy var resizeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(resizeButtonClick(sender:)), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Events
    @objc func selectAllStations(sender: UIButton) {
        presenter.didSelectToSelectAllStations()
    }
    
//    @objc func resetOrder(sender: UIButton) {
//        presenter.didSelectResetOrder()
//    }
    
    @objc func clearOrder(sender: UIButton) {
        presenter.didSelectClearOrder()
    }
    
    @objc func reverseOrder(sender: UIButton) {
        presenter.didSelectReverseOrder()
    }
    
//    @objc func resetStations(sender: UIButton) {
//        presenter.didSelectResetStations()
//    }
    
    @objc func closeButtonClick(sender: UIButton) {
        presenter.didSelectClose()
    }
    
    @objc func editButtonClick(sender: UIButton) {
        presenter.didSelectEditMenu()
    }

    @objc func editDoneButtonClick(sender: UIButton) {
        presenter.didSelectEditDone()
    }

    @objc func resizeButtonClick(sender: UIButton) {
        presenter.didSelectResize()
    }
    
    //MARK: - UIViewController
    @objc func viewClicked(sender: UIView) {
        routeNameTextField.endEditing(true)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SCROLL: \(scrollView.contentSize)")
    }
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.trpBackground
        
        // ensure the keyboard disappears when click view
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewClicked(sender:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        self.navigationController?.view.addGestureRecognizer(tap)
        
        self.navigationItem.titleView = routeNameTextField
        
        // make sure to add mapViewControllerHost before the other views which need to be on top of it
        self.view.addSubview(mapViewControllerHost)
        self.view.addSubview(resizeButton)
        self.view.addSubview(editDescription)
        self.view.addSubview(editStationOptions)
        self.view.addSubview(editOrderOptions)
        
        self.view.addSubview(scrollView)
        
        setConstraints()
    }
    
    func setConstraints() {
        
        mapTopConstraint = mapViewControllerHost.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        mapViewControllerHost.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        mapViewControllerHost.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        mapBottomConstaint = mapViewControllerHost.autoPinEdge(toSuperviewEdge: .bottom, withInset: 350)
        
        editDescription.autoPinEdge(.left, to: .left, of: mapViewControllerHost)
        editDescription.autoPinEdge(.right, to: .right, of: mapViewControllerHost)
        editDescription.autoPinEdge(.top, to: .top, of: mapViewControllerHost)
        editDescription.autoSetDimension(.height, toSize: LayoutDimensions.inputHeight * 1.2)
        
        editStationOptions.autoPinEdge(.left, to: .left, of: mapViewControllerHost)
        editStationOptions.autoPinEdge(.right, to: .right, of: mapViewControllerHost)
        editStationOptions.autoPinEdge(.bottom, to: .bottom, of: mapViewControllerHost)
        editStationOptions.autoSetDimension(.height, toSize: LayoutDimensions.inputHeight)
        
        editOrderOptions.autoPinEdge(.left, to: .left, of: mapViewControllerHost)
        editOrderOptions.autoPinEdge(.right, to: .right, of: mapViewControllerHost)
        editOrderOptions.autoPinEdge(.bottom, to: .bottom, of: mapViewControllerHost)
        editOrderOptions.autoSetDimension(.height, toSize: LayoutDimensions.inputHeight)
        
        scrollView.autoPinEdge(.top, to: .bottom, of: mapViewControllerHost, withOffset: LayoutDimensions.spacingMargin)
        scrollView.autoPinEdge(toSuperviewEdge: .left)
        scrollView.autoPinEdge(toSuperviewEdge: .right)
        scrollView.autoPinEdge(toSuperviewEdge: .bottom)
        
        scrollViewContentView.autoPinEdgesToSuperviewEdges()
        
        barChartKillsTitle.autoPinEdge(toSuperviewEdge: .top)
        barChartKillsTitle.autoPinEdge(toSuperviewEdge: .left)
        barChartKillsTitle.autoPinEdge(toSuperviewEdge: .right)
        
        barChartKills.autoPinEdge(.top, to: .bottom, of: barChartKillsTitle, withOffset: -LayoutDimensions.smallSpacingMargin)
        barChartKills.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.smallSpacingMargin)
        barChartKills.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.smallSpacingMargin)
        barChartKills.autoSetDimension(.height, toSize: 250)

        barChartPoisonTitle.autoPinEdge(.top, to: .bottom, of: barChartKills, withOffset: LayoutDimensions.smallSpacingMargin)
        barChartPoisonTitle.autoPinEdge(toSuperviewEdge: .left)
        barChartPoisonTitle.autoPinEdge(toSuperviewEdge: .right)
        
        barChartPoison.autoPinEdge(.top, to: .bottom, of: barChartPoisonTitle, withOffset: -LayoutDimensions.smallSpacingMargin)
        barChartPoison.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.smallSpacingMargin)
        barChartPoison.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.smallSpacingMargin)
        barChartPoison.autoSetDimension(.height, toSize: 250)
        
        resizeButton.autoPinEdge(.bottom, to: .bottom, of: mapViewControllerHost, withOffset: -LayoutDimensions.smallSpacingMargin)
        resizeButton.autoPinEdge(.right, to: .right, of: mapViewControllerHost, withOffset: -LayoutDimensions.smallSpacingMargin)
        resizeButton.autoSetDimension(.width, toSize: 20)
        resizeButton.autoSetDimension(.height, toSize: 20)
    }
}

//MARK: - UITextFieldDelegate
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
    
    func setMapResizeIconState(state: ResizeState) {
        resizeButton.alpha = state == .hidden ? 0 : 1
        if state != .hidden {
            resizeButton.setImage(UIImage(named: state == .collapse ? "collapse2" : "expand2" ), for: .normal)
        }
    }
    
    func configureKillChart(catchSummary: StackCount) {
        self.killNumberOfBars = catchSummary.counts.count
        let yValues = catchSummary.counts.map({ $0.map( { Double($0) }) })
        barChartKills.buildData(yValues: yValues, stackLabels: catchSummary.labels, stackColors: UIColor.trpStackChartColors )
    }
    
    func configurePoisonChart(poisonSummary: StackCount) {
        self.poisonNumberOfBars = poisonSummary.counts.count
        let yValues = poisonSummary.counts.map({ $0.map( { Double($0) }) })
        barChartPoison.buildData(yValues: yValues, stackLabels: poisonSummary.labels, stackColors: [UIColor.trpChartBarStack4])
    }
    
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

    func displayFullScreenMap() {
        UIView.animate(withDuration: 0.5, animations: {
            //self.mapTopConstraint?.constant = -30
            self.mapBottomConstaint?.constant = 0
            self.view.layoutIfNeeded()
        })

    }
    
    func displayCollapsedMap() {
        UIView.animate(withDuration: 0.5, animations: {
            //self.mapTopConstraint?.constant = 0
            self.mapBottomConstaint?.constant = -350
            self.view.layoutIfNeeded()
        })
    }
    
    func displayTitle(_ title: String, editable: Bool) {
        routeNameTextField.text = title
        routeNameTextField.isEnabled = editable
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
    
    func setVisibleRegionToStation(station: Station, distance: Double) {
        mapViewController?.setVisibleRegionToStation(station: station, distance: distance)
    }
    
    func getMapContainerView() -> UIView {
        return mapViewControllerHost
    }
    
    func enableToggleHighlightMode(_ enable: Bool) {
        //mapViewController?.enableToggleHighlightMode(enable)
    }
    
    func setTitleOfSelectAllStations(title: String) {
        self.selectAllStationsOnTraplineButton.setTitle(title, for: .normal)
    }
    
    func enableSelectAllStationsButton(_ enable: Bool) {
        self.selectAllStationsOnTraplineButton.isEnabled = enable
    }
    
//    func enableResetStationsButton(_ enable: Bool) {
//        self.resetStationsButton.isEnabled = enable
//    }

    func enableEditDone(_ enable: Bool) {
        self.editDoneButton.isEnabled = enable
    }
    
    func enableReverseOrder(_ enable: Bool) {
        self.reverseOrderButton.isEnabled = enable
    }
    
}

// MARK: - IAxisValueFormatter
extension RouteDashboardView: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        var monthsOffset: Int
        
        if axis == barChartKills.xAxis {
            monthsOffset = -(killNumberOfBars - (Int(value) + 1))
        } else {
            monthsOffset = -(poisonNumberOfBars - (Int(value) + 1))
        }
        
        let displayMonth = Date().add(0, monthsOffset, 0)
        return displayMonth.toString(from: "MMMMM")
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
