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
    
    var editDoneEnabled: Bool = false {
        didSet {
            self.editDoneButton.isEnabled = editDoneEnabled
        }
    }
    
    //MARK: - Constants
    
    //MARK: - Subviews
    
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
        textField.textColor = UIColor.white
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
    
    lazy var cancelEditButton: UIBarButtonItem = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.addTarget(self, action: #selector(cancelEditButtonClick(sender:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        return barButton
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
    
    @objc func resetOrder(sender: UIButton) {
        presenter.didSelectResetOrder()
    }
    
    @objc func clearOrder(sender: UIButton) {
        presenter.didSelectClearOrder()
    }
    
    @objc func reverseOrder(sender: UIButton) {
        presenter.didSelectReverseOrder()
    }
    
    @objc func resetStations(sender: UIButton) {
        presenter.didSelectResetStations()
    }
    
    @objc func closeButtonClick(sender: UIButton) {
        presenter.didSelectClose()
    }
    
    @objc func editButtonClick(sender: UIButton) {
        presenter.didSelectEditMenu()
    }

    @objc func cancelEditButtonClick(sender: UIButton) {
        presenter.didSelectEditCancel()
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
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.trpBackground
        
        // ensure the keyboard disappears when click view
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewClicked(sender:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        self.navigationController?.view.addGestureRecognizer(tap)
        
        self.navigationItem.titleView = routeNameTextField
        //self.view.addSubview(routeNameTextField)
        self.view.addSubview(mapViewControllerHost)
        self.view.addSubview(editDescription)
        self.view.addSubview(editStationOptions)
        self.view.addSubview(editOrderOptions)
        self.view.addSubview(barChartKills)
        self.view.addSubview(barChartKillsTitle)
        self.view.addSubview(barChartPoison)
        self.view.addSubview(barChartPoisonTitle)
        self.view.addSubview(resizeButton)
        setConstraints()
    }
    
    func setConstraints() {
        
        //routeNameTextField.autoSetDimension(.width, toSize: self.view.frame.width * 0.8)

        //mapTopConstraint = mapViewControllerHost.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        mapViewControllerHost.autoPin(toTopLayoutGuideOf: self, withInset: 0)
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
        
        barChartKillsTitle.autoPinEdge(.top, to: .bottom, of: mapViewControllerHost, withOffset: LayoutDimensions.spacingMargin)
        barChartKillsTitle.autoPinEdge(toSuperviewEdge: .left)
        barChartKillsTitle.autoPinEdge(toSuperviewEdge: .right)
        
        barChartKills.autoPinEdge(.top, to: .bottom, of: barChartKillsTitle, withOffset: -LayoutDimensions.smallSpacingMargin)
        barChartKills.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.smallSpacingMargin)
        barChartKills.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.smallSpacingMargin)
        barChartKills.autoSetDimension(.height, toSize: 150)

        barChartPoisonTitle.autoPinEdge(.top, to: .bottom, of: barChartKills, withOffset: LayoutDimensions.smallSpacingMargin)
        barChartPoisonTitle.autoPinEdge(toSuperviewEdge: .left)
        barChartPoisonTitle.autoPinEdge(toSuperviewEdge: .right)
        
        barChartPoison.autoPinEdge(.top, to: .bottom, of: barChartPoisonTitle, withOffset: -LayoutDimensions.smallSpacingMargin)
        barChartPoison.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.smallSpacingMargin)
        barChartPoison.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.smallSpacingMargin)
        barChartPoison.autoSetDimension(.height, toSize: 150)
        
        resizeButton.autoPinEdge(.bottom, to: .bottom, of: mapViewControllerHost, withOffset: -LayoutDimensions.smallSpacingMargin)
        resizeButton.autoPinEdge(.right, to: .right, of: mapViewControllerHost, withOffset: -LayoutDimensions.smallSpacingMargin)
        resizeButton.autoSetDimension(.width, toSize: 30)
        resizeButton.autoSetDimension(.height, toSize: 30)
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
    
    func setMapResizeIconState(state: ResizeState) {
        resizeButton.alpha = state == .hidden ? 0 : 1
        if state != .hidden {
            resizeButton.setImage(UIImage(named: state == .collapse ? "collapse" : "expand" ), for: .normal)
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
    
    func showKillChart(_ show: Bool) {
        barChartKills.alpha = show ? 1 : 0
        barChartKillsTitle.alpha = show ? 1 : 0
    }
    
    func showPoisonChart(_ show: Bool) {
        barChartPoison.alpha = show ? 1 : 0
        barChartPoisonTitle.alpha = show ? 1 : 0
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
//        UIView.animate(withDuration: 0.5, animations: {
//            self.mapTopConstraint?.constant = 0
//            self.view.layoutIfNeeded()
//        })
    }
    
    func displayCollapsedMap() {
        UIView.animate(withDuration: 0.5, animations: {
            self.mapBottomConstaint?.constant = -350
            self.view.layoutIfNeeded()
        })
    }
    
    func displayTitle(_ title: String) {
        routeNameTextField.text = title
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
    
//    func displayKillDataChart() {
//        
//        // assuming x is the number of months ago
//        let values = [
//            BarChartDataEntry(x: 0, yValues: [3,1,1]),
//            BarChartDataEntry(x: -1, yValues: [0,0,0]),
//            BarChartDataEntry(x: -2, yValues: [1,0,0]),
//            BarChartDataEntry(x: -3, yValues: [1,0,0]),
//            BarChartDataEntry(x: -4, yValues: [0,0,0]),
//            BarChartDataEntry(x: -5, yValues: [1,0,0]),
//            BarChartDataEntry(x: -6, yValues: [2,0,0]),
//            BarChartDataEntry(x: -7, yValues: [0,1,0]),
//            BarChartDataEntry(x: -8, yValues: [0,1,0]),
//            BarChartDataEntry(x: -9, yValues: [0,1,0]),
//            BarChartDataEntry(x: -10, yValues: [0,1,0]),
//            BarChartDataEntry(x: -11, yValues: [1,1,1])
//        ]
//        let killDataSet = BarChartDataSet(values: values, label: nil)
//        killDataSet.colors = [UIColor.trpChartBarStack1, UIColor.trpChartBarStack2, UIColor.trpChartBarStack3]
//        killDataSet.stackLabels = ["Possum", "Rat", "Other"]
//
//        let data = BarChartData(dataSet: killDataSet)
//        data.barWidth = 0.3
//        data.setDrawValues(false)
//        self.barChartKills.data = data
//        
//    }
//    func displayPoisonDataChart() {
//        
//        // assuming x is the number of months ago
//        let values = [
//            BarChartDataEntry(x: 0, y: 5),
//            BarChartDataEntry(x: -1, y: 15),
//            BarChartDataEntry(x: -2, y: 5),
//            BarChartDataEntry(x: -3, y: 0),
//            BarChartDataEntry(x: -4, y: 0),
//            BarChartDataEntry(x: -5, y: 4),
//            BarChartDataEntry(x: -6, y: 3),
//            BarChartDataEntry(x: -7, y: 5),
//            BarChartDataEntry(x: -8, y: 6),
//            BarChartDataEntry(x: -9, y: 10),
//            BarChartDataEntry(x: -10, y: 12),
//            BarChartDataEntry(x: -11, y: 1)
//        ]
//        let killDataSet = BarChartDataSet(values: values, label: nil)
//        killDataSet.setColor(UIColor.trpMapDefaultStation)
//        
//        let data = BarChartData(dataSet: killDataSet)
//        self.barChartPoison.data = data
//        data.setDrawValues(false)
//        data.barWidth = 0.3
//    }
}

//extension RouteDashboardView: BarChartDelegate {
//
//    func chartNumberOfBars(_ chart: BarChartViewEx) -> Int {
////        if chart == self.barChartKills {
////            return killNumberOfBars
////        } else if chart == self.barChartPoison {
////            return poisonNumberOfBars
////        } else {
////            return 0
////        }
//        return killNumberOfBars
//    }
//    func chartNumberOfStacks(_ chart: BarChartViewEx) -> Int {
////        if chart == self.barChartKills {
////            return killSpecies.count
////        } else if chart == self.barChartPoison {
////            return 1
////        } else {
////            return 0
////        }
//        return killSpecies.count
//    }
//
//    func chart(_ chart: BarChartViewEx, valuesAt barIndex: Int) -> [Double] {
////        if chart == self.barChartKills {
//        let kills = self.killCountFunction?(barIndex)
//        if let values = kills?.values {
//            return Array(values.map({ Double($0) }))
//        } else {
//            return [Double]()
//        }
////        } else if chart == self.barChartPoison {
////            var value: Double = 0
////            if let valueAsInt = self.poisonCountFunction?(barIndexPath.bar) {
////                value = Double(valueAsInt)
////            }
////            return value
////        } else {
////            return 0
////        }
//    }
//
//    func chart(_ chart: BarChartViewEx, colorOfStack stackIndex: Int) -> UIColor {
//        if stackIndex <= 2 {
//            return [UIColor.trpChartBarStack1, UIColor.trpChartBarStack2, UIColor.trpChartBarStack3][stackIndex]
//        }
//        return UIColor.red
//    }
//
//    func chart(_ chart: BarChartViewEx, titleOfStack stackIndex: Int) -> String {
//        //if chart == barChartKills {
//            return self.killSpecies[stackIndex].name ?? "?"
//        //}
//        //return ""
//    }
//
//    func chart(_ chart: BarChartViewEx, xLabelFor barIndex: Int, axis: AxisBase?) -> String {
//
//        //if axis == self.barChartKills.xAxis {
//            // bar 0 is the first bar, so should be 11 months ago
//            // bar 11 is the current month
//            let monthsAgo = 12 - (barIndex + 1)
//            let displayMonth = Date().add(0, -Int(monthsAgo), 0)
//            return displayMonth.toString(from: "MMMMM")
//        //}
//        //return String(barIndex)
//    }
//
//}

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
