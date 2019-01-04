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
    
    let MAP_HEIGHT_MIN: CGFloat = 350
    let GRAPH_HEIGHT: CGFloat = 200
    
    let NUMBER_OF_SUMMARY_CELLS = 4
    let CELL_ID = "cell"
    let ROW_LASTVISITED = 1
    let ROW_VISITS = 2
    let ROW_TIMES = 3
    
    var killNumberOfBars: Int = 0
    var poisonNumberOfBars: Int = 0
    var poisonCountFunction: ((Int) -> Int)?
    
    var heightOfScrollableArea: CGFloat {
        // 3 row tableview, 2 graphs with headings + a little extra
        return LayoutDimensions.inputHeight * 3 + GRAPH_HEIGHT * 2 + LayoutDimensions.inputHeight * 2 + LayoutDimensions.spacingMargin
    }
    
    //MARK: - Subviews
    
    lazy var summaryTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        return tableView
    }()
    
    lazy var routeSummaryTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: CELL_ID)
        cell.textLabel?.text = "Stations"
        cell.accessoryType = .none
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
    }()
    
    lazy var visitsTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: CELL_ID)
        cell.textLabel?.text = "Visits"
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
    }()
    
    lazy var lastVisitTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: CELL_ID)
        cell.textLabel?.text = "Last Visited"
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
    }()
    
    lazy var timesTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: CELL_ID)
        cell.textLabel?.text = "Times"
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
    }()
    
    lazy var scrollViewContentView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: heightOfScrollableArea))
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.addSubview(scrollViewContentView)
        
        scrollViewContentView.addSubview(summaryTableView)
        scrollViewContentView.addSubview(barChartKills)
        scrollViewContentView.addSubview(barChartKillsTitle)
        scrollViewContentView.addSubview(barChartPoison)
        scrollViewContentView.addSubview(barChartPoisonTitle)
        
        scrollView.contentSize = CGSize(width: scrollViewContentView.frame.width, height: heightOfScrollableArea)
        
        return scrollView
    }()
    
    lazy var barChartKillsTitle: UILabel = {
        let label = UILabel()
        label.text = "CATCHES"
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
    
    lazy var cancelButton: UIBarButtonItem = {
        let cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonClick(sender:)), for: .touchUpInside)
        
        var button = UIBarButtonItem(customView: cancelButton)
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
    
    @objc func cancelButtonClick(sender: UIButton) {
        presenter.didSelectCancel()
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
        
        // not going to have this for now - bloat!
        //self.view.addSubview(resizeButton)
        
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
        mapBottomConstaint = mapViewControllerHost.autoPinEdge(toSuperviewEdge: .bottom, withInset: MAP_HEIGHT_MIN)
        
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

        // Inside the scrollView...
        
        summaryTableView.autoPinEdge(toSuperviewEdge: .top)
        summaryTableView.autoPinEdge(toSuperviewEdge: .left)
        summaryTableView.autoPinEdge(toSuperviewEdge: .right)
        summaryTableView.autoSetDimension(.height, toSize: CGFloat(NUMBER_OF_SUMMARY_CELLS) * LayoutDimensions.tableCellHeight * 1.2)
        
        barChartKillsTitle.autoPinEdge(.top, to: .bottom, of: summaryTableView, withOffset: LayoutDimensions.smallSpacingMargin)
        barChartKillsTitle.autoPinEdge(toSuperviewEdge: .left)
        barChartKillsTitle.autoPinEdge(toSuperviewEdge: .right)
        
        barChartKills.autoPinEdge(.top, to: .bottom, of: barChartKillsTitle, withOffset: -LayoutDimensions.smallSpacingMargin)
        barChartKills.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.smallSpacingMargin)
        barChartKills.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.smallSpacingMargin)
        barChartKills.autoSetDimension(.height, toSize: GRAPH_HEIGHT)

        barChartPoisonTitle.autoPinEdge(.top, to: .bottom, of: barChartKills, withOffset: LayoutDimensions.smallSpacingMargin)
        barChartPoisonTitle.autoPinEdge(toSuperviewEdge: .left)
        barChartPoisonTitle.autoPinEdge(toSuperviewEdge: .right)
        
        barChartPoison.autoPinEdge(.top, to: .bottom, of: barChartPoisonTitle, withOffset: -LayoutDimensions.smallSpacingMargin)
        barChartPoison.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.smallSpacingMargin)
        barChartPoison.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.smallSpacingMargin)
        barChartPoison.autoSetDimension(.height, toSize: GRAPH_HEIGHT)
        
        // Overlayed on to map
//        resizeButton.autoPinEdge(.bottom, to: .bottom, of: mapViewControllerHost, withOffset: -LayoutDimensions.smallSpacingMargin)
//        resizeButton.autoPinEdge(.right, to: .right, of: mapViewControllerHost, withOffset: -LayoutDimensions.smallSpacingMargin)
//        resizeButton.autoSetDimension(.width, toSize: 20)
//        resizeButton.autoSetDimension(.height, toSize: 20)
    }
}

//MARK: - SummaryTableView

extension RouteDashboardView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NUMBER_OF_SUMMARY_CELLS
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        var cell: UITableViewCell?
        
        if row == ROW_LASTVISITED {
            cell = lastVisitTableViewCell
        } else if row == ROW_VISITS {
            cell = visitsTableViewCell
        } else if row == ROW_TIMES {
            cell = timesTableViewCell
        } else {
            cell = routeSummaryTableViewCell
        }
        
        return cell!
    }
}

extension RouteDashboardView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        if row == ROW_VISITS {
            presenter.didSelectVisitHistory()
        } else if row == ROW_LASTVISITED {
            presenter.didSelectLastVisited()
        } else if row == ROW_TIMES {
            presenter.didSelectTimes()
        }
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
        if !catchSummary.isZero {
            barChartKills.alpha = 1
            barChartKillsTitle.alpha = 1
            self.killNumberOfBars = catchSummary.counts.count
            let yValues = catchSummary.counts.map({ $0.map( { Double($0) }) })
            
            barChartKills.buildData(yValues: yValues, stackLabels: catchSummary.labels, stackColors: UIColor.trpStackChartColors )
        } else {
            barChartKills.alpha = 0
            barChartKillsTitle.alpha = 0
        }
    }
    
    func configurePoisonChart(poisonSummary: StackCount) {
        
        if !poisonSummary.isZero {
            barChartPoison.alpha = 1
            barChartPoisonTitle.alpha = 1
            self.poisonNumberOfBars = poisonSummary.counts.count
            let yValues = poisonSummary.counts.map({ $0.map( { Double($0) }) })
            barChartPoison.buildData(yValues: yValues, stackLabels: poisonSummary.labels, stackColors: [UIColor.trpChartBarStack4])
        } else {
            barChartPoison.alpha = 0
            barChartPoisonTitle.alpha = 0
        }
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
            self.navigationItem.leftBarButtonItem = self.cancelButton
            
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
            self.mapBottomConstaint?.constant = -self.MAP_HEIGHT_MIN
            self.view.layoutIfNeeded()
        })
        
        
    }
    
    func displayTitle(_ title: String, editable: Bool) {
        routeNameTextField.text = title
        routeNameTextField.isEnabled = editable
    }
    
    func displayLastVisitedDate(date: String, allowSelection: Bool) {
        lastVisitTableViewCell.detailTextLabel?.text = date
        lastVisitTableViewCell.accessoryType = allowSelection ? .disclosureIndicator : .none
    }
    
    func displayVisitNumber(number: String, allowSelection: Bool) {
        visitsTableViewCell.detailTextLabel?.text = number
        visitsTableViewCell.accessoryType = allowSelection ? .disclosureIndicator : .none
    }
    
    func displayStationSummary(summary: String, numberOfStations: Int) {
        routeSummaryTableViewCell.detailTextLabel?.text = summary
        //routeSummaryTableViewCell.textLabel?.text = "Stations (\(numberOfStations))"
    }
    
    func displayTimes(description: String, allowSelection: Bool) {
        timesTableViewCell.detailTextLabel?.text = description
        timesTableViewCell.accessoryType = allowSelection ? .disclosureIndicator : .none
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
    
    func showSpinner() {
        print("SHOW SPINNER")
    }
    
    func stopSpinner() {
        print("STOP SPINNER")
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
        return displayMonth.toString(format: "MMMMM")
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
