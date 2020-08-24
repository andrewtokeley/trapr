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
    
    private var stations = [LocatableEntity]()
    
    private let CELL_ID = "cell"
    
    private let SECTIONS = 4
    
    private let SECTION_MAP = 0
    private let ROW_MAP = 0

    private let SECTION_VISITS = 1
    private let ROW_ROUTE_SUMMARY = 0
    private let ROW_LASTVISITED = 1
    private let ROW_VISITS = 2
    private let ROW_TIMES = 3
    
    private let SECTION_CATCHES = 2
    private let ROW_CATCHES_GRAPH = 0
    
    private let SECTION_POISON = 3
    private let ROW_POISON_GRAPH = 0
    
    private let MAPOPTION_ALLTRAPTYPES = 0
    private let MAPOPTION_POSSUMMASTER = 1
    private let MAPOPTION_TIMMS = 2
    private let MAPOPTION_DOC200 = 3
    
    fileprivate var visibleSections = [Int]()
    
    private var killNumberOfBars: Int = 0
    private var poisonNumberOfBars: Int = 0
    private var poisonCountFunction: ((Int) -> Int)?
    
    //MARK: - Subviews
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.color = .trpHighlightColor
        return spinner
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var routeSummaryTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: CELL_ID)
        cell.textLabel?.text = "Stations"
        cell.accessoryType = .none
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var visitsTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: CELL_ID)
        cell.textLabel?.text = "Visits"
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var lastVisitTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: CELL_ID)
        cell.textLabel?.text = "Last Visited"
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var timesTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: CELL_ID)
        cell.textLabel?.text = "Times"
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var mapTableViewCell: MapTableViewCell = {
        let cell = MapTableViewCell(showFilter: true, delegate: self)
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var catchesGraphTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: CELL_ID)
        cell.textLabel?.text = "Times"
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var poisonGraphTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: CELL_ID)
        cell.textLabel?.text = "Times"
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
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
    
    lazy var routeNameTextField: UITextField = {
    
        let textField = UITextField()
        textField.placeholder = "Route name"
        textField.delegate = self
        textField.textAlignment = .center
        textField.returnKeyType = UIReturnKeyType.done
        return textField
    }()
    
    lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "show"), style: .plain, target: self, action: #selector(editButtonClick(sender:)))
        return button
    }()
    
    lazy var closeButton: UIBarButtonItem = {
        var view = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(closeButtonClick(sender:)))
        return view
    }()
    
    @objc func closeButtonClick(sender: UIButton) {
        presenter.didSelectClose()
    }
    
    @objc func editButtonClick(sender: UIButton) {
        presenter.didSelectEditMenu()
    }

    //MARK: - UIViewController
    
    @objc func viewClicked(sender: UIView) {
        routeNameTextField.endEditing(true)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        
        visibleSections = [SECTION_MAP, SECTION_VISITS, SECTION_POISON, SECTION_CATCHES]
        
        self.view.backgroundColor = UIColor.trpBackground
        
        // ensure the keyboard disappears when click view
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewClicked(sender:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        self.navigationController?.view.addGestureRecognizer(tap)
        
        self.navigationItem.titleView = routeNameTextField
        self.navigationItem.rightBarButtonItem = self.editButton
        
        self.view.addSubview(tableView)
        self.view.addSubview(spinner)
        
        setConstraints()
    }
    
    func setConstraints() {
        tableView.autoPinEdgesToSuperviewEdges()
        spinner.autoPinEdgesToSuperviewEdges()
    }
    
}

//MARK: - TableView

extension RouteDashboardView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SECTION_MAP {
            return 1
        } else if section == SECTION_VISITS {
            return 4
        } else if section == SECTION_CATCHES {
            return 1
        } else if section == SECTION_POISON {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.isHidden = !visibleSections.contains(indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if visibleSections.contains(section) {
            switch section {
                case SECTION_MAP: return "Map"
                case SECTION_VISITS: return "Visits"
                case SECTION_CATCHES: return "Catches"
                case SECTION_POISON: return "Poison"
                default: return ""
            }
        }
        return ""
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SECTIONS
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if visibleSections.contains(indexPath.section) {
            if indexPath.section == SECTION_MAP {
                if indexPath.row == ROW_MAP {
                    return 400
                }
            } else {
                return UITableView.automaticDimension
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let section = indexPath.section
        
        var cell: UITableViewCell?
        
        if section == SECTION_MAP {
            cell = mapTableViewCell
            
        } else if section == SECTION_VISITS {
            if row == ROW_LASTVISITED {
                cell = lastVisitTableViewCell
            } else if row == ROW_VISITS {
                cell = visitsTableViewCell
            } else if row == ROW_TIMES {
                cell = timesTableViewCell
            } else if row == ROW_ROUTE_SUMMARY {
                cell = routeSummaryTableViewCell
            }
        } else if section == SECTION_CATCHES {
            cell = catchesGraphTableViewCell
        } else if section == SECTION_POISON {
            cell = poisonGraphTableViewCell
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if visibleSections.contains(section) {
            return tableView.headerView(forSection: section)
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if visibleSections.contains(section) {
            return tableView.footerView(forSection: section)
        }
        return nil
    }
}

extension RouteDashboardView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        
        if section == SECTION_VISITS {
            if row == ROW_VISITS {
                presenter.didSelectVisitHistory()
            } else if row == ROW_LASTVISITED {
                presenter.didSelectLastVisited()
            } else if row == ROW_TIMES {
                presenter.didSelectTimes()
            }
        }
    }
}

// MARK: - StationMapViewDelegat
extension RouteDashboardView: StationMapViewDelegate {
    
    func stationMapStations(_ stationMap: StationMapView) -> [LocatableEntity] {
        return stations
    }
    
    func stationMapShowHeatMap(_ stationMap: StationMapView) -> Bool {
        return true
    }
    
    func stationMap(_ stationMap: StationMapView, colourForStation station: LocatableEntity, state: AnnotationState) -> UIColor {
        return presenter.getColorForMapStation(station: station, state: state)
    }
    
    func stationMap(_ stationMap: StationMapView, radiusForStation station: LocatableEntity) -> Int {
        return 7
    }
    
    func stationMap(_ stationMap: StationMapView, isHidden station: LocatableEntity) -> Bool {
        return presenter.getIsHidden(station: station)
    }
    
    func stationMap(_ stationMap: StationMapView, didSelectFilter option: MapOption) {
        presenter.didselectMapFilterOption(option: option)
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
    
    func displayHeatmap(title: String, segments: [Segment]) {
        self.mapTableViewCell.mapView.heatMapLegend.title = title
        self.mapTableViewCell.mapView.heatMapLegend.setSegments(segments: segments)
    }
    
    func displayStations(stations: [LocatableEntity]) {
        self.stations = stations
        self.mapTableViewCell.mapView.reload(forceRebuildOfAnnotations: true)
    }
    
    func showVisitDetails(show: Bool) {
        // don't want to show the visits, catches or poison sections

        visibleSections.removeAll()
        if show {
            visibleSections.append(contentsOf: [SECTION_MAP, SECTION_VISITS, SECTION_POISON, SECTION_CATCHES])
        } else {
            visibleSections.append(contentsOf: [SECTION_MAP])
        }
        
        tableView.reloadData()
    }
    
    func configureKillChart(catchSummary: StackCount) {
        barChartKills.alpha = 1
        //barChartKillsTitle.alpha = 1
        self.killNumberOfBars = catchSummary.counts.count
        let yValues = catchSummary.counts.map({ $0.map( { Double($0) }) })
        
        barChartKills.buildData(yValues: yValues, stackLabels: catchSummary.labels, stackColors: UIColor.trpStackChartColors )
    }
    
    func configurePoisonChart(poisonSummary: StackCount) {
        
        if !poisonSummary.isZero {
            barChartPoison.alpha = 1
            //barChartPoisonTitle.alpha = 1
            self.poisonNumberOfBars = poisonSummary.counts.count
            let yValues = poisonSummary.counts.map({ $0.map( { Double($0) }) })
            barChartPoison.buildData(yValues: yValues, stackLabels: poisonSummary.labels, stackColors: [UIColor.trpChartBarStack4])
        } else {
            barChartPoison.alpha = 0
        }
    }
  
    func reapplyStylingToAnnotationViews() {
        mapTableViewCell.mapView.reapplyStylingToAnnotationViews()
    }
    
    func reloadMap(forceAnnotationRebuild: Bool = false) {
        mapTableViewCell.mapView.reload(forceRebuildOfAnnotations: forceAnnotationRebuild)
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
    }
    
    func displayTimes(description: String, allowSelection: Bool) {
        timesTableViewCell.detailTextLabel?.text = description
        timesTableViewCell.accessoryType = allowSelection ? .disclosureIndicator : .none
    }
    
    func setVisibleRegionToAllStations() {
        self.mapTableViewCell.mapView.setVisibleRegionToAllStations()
    }

    func showSpinner() {
        spinner.alpha = 1
        spinner.startAnimating()
        tableView.alpha = 0
    }
    
    func stopSpinner() {
        spinner.alpha = 0
        spinner.stopAnimating()
        tableView.alpha = 1
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
