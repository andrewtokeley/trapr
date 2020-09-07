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
    
    private lazy var sections = [
        StaticSection("Route", [
            StaticRow(mapTableViewCell, 400)]
        ),
        StaticSection("Stations", [
            StaticRow(routeSummaryTableViewCell),
            StaticRow(trapsDescriptionTableViewCell)]
        ),
        StaticSection("Visits", [
            StaticRow(lastVisitTableViewCell),
            StaticRow(visitsTableViewCell)]
        ),
        StaticSection("Catches", [
            StaticRow(catchesChartTableViewCell, 350)]
        ),
        StaticSection("Lures & Poison", [
            StaticRow(poisonChartTableViewCell, 350),
            StaticRow(averageLureTableViewCell, 100)]
        )
    ]
    
    //MARK: - Subviews
    
    lazy var spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.color = .trpHighlightColor
        return spinner
    }()
    
    lazy var tableView: StaticTableView = {
        let tableView = StaticTableView(sections: sections)
        tableView.staticTableViewDelegate = self
        return tableView
    }()
    
    lazy var routeSummaryTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: CELL_ID)
        cell.textLabel?.text = "Stations"
        cell.accessoryType = .none
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var trapsDescriptionTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: CELL_ID)
        cell.textLabel?.text = "Traps"
        cell.accessoryType = .disclosureIndicator
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
    
    lazy var averageLureTableViewCell: UITableViewCell = {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: CELL_ID)
        cell.textLabel?.text = "Avg. Lure Usage"
        cell.selectionStyle = .none
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }()
    
    lazy var mapTableViewCell: MapTableViewCell = {
        let cell = MapTableViewCell(showFilter: true, delegate: self)
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var catchesChartTableViewCell: BarChartTableViewCell = {
        let cell = BarChartTableViewCell()
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var poisonChartTableViewCell: BarChartTableViewCell = {
        let cell = BarChartTableViewCell()
        cell.selectionStyle = .none
        return cell
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
        routeNameTextField.autoSetDimension(.width, toSize: 150)
        tableView.autoPinEdgesToSuperviewEdges()
        spinner.autoPinEdgesToSuperviewEdges()
    }
    
}

//MARK: - StaticTableViewDelegate

extension RouteDashboardView: StaticTableViewDelegate {
    
    func tableView(_ tableView: StaticTableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.row(indexPath).cell == visitsTableViewCell {
            presenter.didSelectVisitHistory()
        } else if tableView.row(indexPath).cell == lastVisitTableViewCell {
            presenter.didSelectLastVisited()
        } else if tableView.row(indexPath).cell == trapsDescriptionTableViewCell {
            presenter.didSelectTraps()
        }
    }
}

// MARK: - StationMapViewDelegate

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
    
    func displayTrapsDescription(description: String?) {
        self.trapsDescriptionTableViewCell.detailTextLabel?.text = description
    }
    
    func displayAverageLureSummary(summary: String) {
        self.averageLureTableViewCell.detailTextLabel?.text = summary
    }
    
    func showVisitDetails(show: Bool) {
        // don't want to show the visits, catches or poison sections

        if show {
            tableView.setVisibility(sectionTitles: (sections.compactMap { $0.title }), isVisible: true)
        } else {
            tableView.setVisibility(sectionTitles: (sections.compactMap { $0.title }), isVisible: false)
            tableView.section(by: "Route")?.isVisible = true
        }
        
        if show {
            
        }
        
        tableView.reloadData()
    }
    
    func configureKillChart(counts: StackCount?, title: String?, lastPeriodCounts: StackCount?, lastPeriodTitle: String?) {
        if let killCounts = counts {
            catchesChartTableViewCell.configureChart(currentData: killCounts, dataTitle: title, lastPeriodData: lastPeriodCounts, lastPeriodTitle: lastPeriodTitle)
        }
    }
    
    func configurePoisonChart(counts: StackCount?, title: String?, lastPeriodCounts: StackCount?, lastPeriodTitle: String?) {
        if let poisonCounts = counts {
            poisonChartTableViewCell.configureChart(currentData: poisonCounts, dataTitle: title, lastPeriodData: lastPeriodCounts, lastPeriodTitle: lastPeriodTitle)
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

// MARK: - RouteDashboardView Viper Components API
private extension RouteDashboardView {
    var presenter: RouteDashboardPresenterApi {
        return _presenter as! RouteDashboardPresenterApi
    }
    var displayData: RouteDashboardDisplayData {
        return _displayData as! RouteDashboardDisplayData
    }
}
