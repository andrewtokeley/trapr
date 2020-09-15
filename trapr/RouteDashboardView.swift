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

/**
 Enumerator to identify which view a NavigationStrip related to
 */
enum ChartType: Int {
    case stationMap = 0
    case catchesChart
    case baitChart
}

//MARK: RouteDashboardView Class
final class RouteDashboardView: UserInterface {
    
    private var stations = [LocatableEntity]()
    private var stationCounts = [String: Int]()
    private var legendSegments = [Segment]()
    private var legendTitle: String?
    private var optionButtons = [MapOptionButton]()
    
    private var killCounts = [StackCount?]()
    private var killCountsCurrentIndex: Int = 0
    
    private var baitCounts = [StackCount?]()
    private var baitCountsCurrentIndex: Int = 0
    
    private let CELL_ID = "cell"
    
    private lazy var sections = [
        StaticSection("Route", [
            StaticRow(mapTypeTableViewCell),
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
    
    lazy var mapTypeNavigationStrip: NavigationStrip = {
        let view = NavigationStrip()
        view.tag = ChartType.stationMap.rawValue
        //view.textLabel.text = "Catches"
        view.setItems([
                        NavigationStripItem(title: "Bait", itemData: MapType.bait),
                        NavigationStripItem(title: "Catches", itemData: MapType.catches)],
                        selectedItemIndex: 1)
        view.delegate = self
        return view
    }()
    
    lazy var mapTypeTableViewCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.contentView.addSubview(mapTypeNavigationStrip)
        mapTypeNavigationStrip.autoPinEdgesToSuperviewEdges()
        return cell
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
        cell.chart.delegate = self
        cell.chart.tag = ChartType.catchesChart.rawValue
        cell.navigationStrip.tag = ChartType.catchesChart.rawValue
        cell.navigationStrip.delegate = self
        
        return cell
    }()
    
    lazy var poisonChartTableViewCell: BarChartTableViewCell = {
        let cell = BarChartTableViewCell()
        cell.selectionStyle = .none
        cell.navigationStrip.tag = ChartType.baitChart.rawValue
        cell.navigationStrip.delegate = self
        cell.chart.delegate = self
        cell.chart.tag = ChartType.baitChart.rawValue
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

extension RouteDashboardView: NavigationStripDelegate {
    
    func navigationStrip(_ navigationStrip: NavigationStrip, navigatedToItemAt index: Int) {
        let item = navigationStrip.items[index]
        if let view = ChartType(rawValue: navigationStrip.tag) {
            if view == .stationMap {
                if let mapType = item.itemData as? MapType {
                    presenter.didSelectMapType(mapType: mapType)
                }
            } else if view == .catchesChart {
                self.displayChart(type: .catches, index: index)
            } else if view == .baitChart {
                self.displayChart(type: .bait, index: index)
            }
        }
        
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

// MARK: -

extension RouteDashboardView: StackedBarChartDelegate {
    func stackedBarChartNumberOfBars(_ stackedBarChart: StackedBarChart) -> Int {
        let type = ChartType(rawValue: stackedBarChart.tag)
        if type == .catchesChart {
            return killCounts[killCountsCurrentIndex]?.counts.count ?? 0
        } else if type == .baitChart {
            return baitCounts[baitCountsCurrentIndex]?.counts.count  ?? 0
        }
        return 0
    }
    
    func stackedBarChartNumberOfStacks(_ stackedBarChart: StackedBarChart) -> Int {
        let type = ChartType(rawValue: stackedBarChart.tag)
        if type == .catchesChart {
            return killCounts[killCountsCurrentIndex]?.counts.first?.count ?? 0
        } else if type == .baitChart {
            return baitCounts[baitCountsCurrentIndex]?.counts.first?.count  ?? 0
        }
        return 0
    }
    
    func stackedBarChart(_ stackedBarChart: StackedBarChart, stackLabel stackIndex: Int) -> String? {
        var result: String?
        let type = ChartType(rawValue: stackedBarChart.tag)
        if type == .catchesChart {
            result = killCounts[killCountsCurrentIndex]?.labels[stackIndex]
        } else if type == .baitChart {
            result = baitCounts[baitCountsCurrentIndex]?.labels[stackIndex]
        }
        return result
    }
    
    func stackedBarChart(_ stackedBarChart: StackedBarChart, valuesAt barIndex: Int) -> [Double] {
        var result: [Double]?
        let type = ChartType(rawValue: stackedBarChart.tag)
        if type == .catchesChart {
            result = killCounts[killCountsCurrentIndex]?.counts[barIndex].compactMap { Double($0) }
        } else if type == .baitChart {
            result = baitCounts[baitCountsCurrentIndex]?.counts[barIndex].compactMap { Double($0) }
        }
        return result ?? [Double]()
    }
    
    func stackedBarChart(_ stackedBarChart: StackedBarChart, xLabelFor barIndex: Int) -> String? {
        
        // assumes 12 monthly bars, where barIndex0 is 12 months ago (offset -11) and barIndex 11 is the current month (offset 0)
        var monthsOffset: Int
        monthsOffset = -(12 - barIndex + 1)
        let displayMonth = Date().add(0, monthsOffset, 0)
        return displayMonth.toString(format: "MMMMM")
    }
    
    func stackedBarChart(_ stackedBarChart: StackedBarChart, colourOfStack stackIndex: Int) -> UIColor? {
        let availableColours = UIColor.trpStackChartColors
        
        if stackIndex < availableColours.count {
            return UIColor.trpStackChartColors[stackIndex]
        } else {
            return UIColor.red // so I know I have to fix this!
        }
    }
    
    func stackedBarChart(_ stackedBarChart: StackedBarChart, legendItemDataAtIndex index: Int) -> StackedBarChartLegendItemData? {
        
        var result: StackedBarChartLegendItemData?
        var chartData = StackCount.zero
        var lastPeriodData: StackCount? = nil
        
        let type = ChartType(rawValue: stackedBarChart.tag)
        if type == .catchesChart {
            chartData = killCounts[killCountsCurrentIndex]!
            lastPeriodData = (killCountsCurrentIndex - 1 >= 0) ? killCounts[killCountsCurrentIndex - 1] : nil
        } else if type == .baitChart {
            chartData = baitCounts[baitCountsCurrentIndex]!
            lastPeriodData = (baitCountsCurrentIndex - 1 >= 0) ? baitCounts[baitCountsCurrentIndex - 1] : nil
        }
        
        //for i in 0...chartData.stackLabels.count - 1 {
        let sumForStack = chartData.counts.reduce(0, { $0 + $1[index] })
        
        // Work out the sums for the preview period and the equivalent stack
        // Can't assume the stacks are in the same order, must rely on matching the stacklabels between years.
        var deltaValue: Int?
        var deltaValueSuffix: String? = nil
        if let lastPeriod = lastPeriodData {
            // Equivalent stack index
            if let index = lastPeriod.labels.firstIndex(of: chartData.labels[index]) {
                let sumForStackLastPeriod = Int(lastPeriod.counts.reduce(0, { $0 + $1[index] }))
                deltaValue = Int((Double(sumForStack - sumForStackLastPeriod)/Double(sumForStackLastPeriod)) * 100.0)
                deltaValueSuffix = "%"
            } else {
                // there is nothing to compare in the previous period
            }
        }
        
        // colour of stack
        if let colour = self.stackedBarChart(stackedBarChart, colourOfStack: index)
        
        {
            result = StackedBarChartLegendItemData(
                text: chartData.labels[index],
                value: sumForStack,
                textColour: colour,
                deltaValue: deltaValue,
                deltaValueSuffix: deltaValueSuffix)
        }
        
        return result

    }
    
}

// MARK: - StationMapViewDelegate

extension RouteDashboardView: StationMapViewDelegate {
    
    func stationMapNumberOfOptionButtons() -> Int {
        return optionButtons.count
    }
    
    func stationMap(_ stationMap: StationMapView, optionButtonAt index: Int) -> MapOptionButton? {
        if optionButtons.count > 0 {
            return optionButtons[index]
        }
        return nil
    }
    
    func stationMap(_ stationMap: StationMapView, optionButtonSelectedAt index: Int) {
        presenter.didselectMapOptionButton(optionButton: optionButtons[index])
    }
    
    func stationMapStations(_ stationMap: StationMapView) -> [LocatableEntity] {
        return stations
    }
    
    func stationMapLegendTitle(_ stationMap: StationMapView) -> String? {
        return self.legendTitle
    }
    
    func stationMapLegendSegments(_ stationMap: StationMapView) -> [Segment] {
        return self.legendSegments
    }
    
    func stationMapShowLegend(_ stationMap: StationMapView) -> Bool {
        return true
    }
    
    func stationMap(_ stationMap: StationMapView, colourForStation station: LocatableEntity, state: AnnotationState) -> UIColor {
        
        if let count = self.stationCounts[station.locationId] {
            //find the segment this count is in
            if let segment = self.legendSegments.first(where: { $0.range.contains(count) }) {
                return segment.colour
            }
        }
        
        // this means the station could have a count for catches or bait, but didn't record anything
        return .trpHeatNoValue
        
    }
    
    func stationMap(_ stationMap: StationMapView, radiusForStation station: LocatableEntity) -> Int {
        return 7
    }
    
    func stationMap(_ stationMap: StationMapView, isHidden station: LocatableEntity) -> Bool {
        return presenter.getIsHidden(station: station)
    }
    
//    func stationMap(_ stationMap: StationMapView, didSelectFilter option: MapOption) {
//        presenter.didselectMapFilterOption(option: option)
//    }
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
    
    func displayMapOptionButtons(buttons: [MapOptionButton], selectedIndex: Int?) {
        self.optionButtons = buttons
        self.mapTableViewCell.mapView.redrawMapOptions(selectedIndex: selectedIndex)
    }
    
    func displayStations(stations: [LocatableEntity], stationCounts: [String: Int], legendSegments: [Segment], legendTitle: String) {
        self.legendSegments = legendSegments
        self.legendTitle = legendTitle
        self.stations = stations
        self.stationCounts = stationCounts
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
    
//    func configureKillChartNavigation(navigationStripItems: [NavigationStripItem]) {
//        catchesChartTableViewCell.navigationStrip.setItems(navigationStripItems)
//    }
//
//    func configureBaitChartNavigation(navigationStripItems: [NavigationStripItem]) {
//        poisonChartTableViewCell.navigationStrip.setItems(navigationStripItems)
//    }
    
    func displayChart(type: MapType, index: Int) {
        
        if type == .catches {
            self.killCountsCurrentIndex = index
            self.catchesChartTableViewCell.chart.drawChart()
        }
        
        if type == .bait {
            self.baitCountsCurrentIndex = index
            self.poisonChartTableViewCell.chart.drawChart()
        }
    }
    
    func setChartData(type: MapType, counts: [StackCount], titles: [String?]) {
        
        // define navigation
        var items = [NavigationStripItem]()
        for title in titles {
            items.append(NavigationStripItem(title: title ?? "", itemData: nil))
        }
        
        if type == .catches {
            self.killCounts = counts
            self.killCountsCurrentIndex = counts.count - 1 // start at the last, most recent one
            
            // configure the navigation
            self.catchesChartTableViewCell.navigationStrip.setItems(items, selectedItemIndex: self.killCountsCurrentIndex)
            self.catchesChartTableViewCell.chart.drawChart()
        }
        
        if type == .bait {
            self.baitCounts = counts
            self.baitCountsCurrentIndex = counts.count - 1 // start at the last, most recent one
            
            // configure the navigation
            self.poisonChartTableViewCell.navigationStrip.setItems(items, selectedItemIndex: self.baitCountsCurrentIndex)
            self.poisonChartTableViewCell.chart.drawChart()
        }
    }
    
//    func configureKillChart(counts: StackCount, title: String, lastPeriodCounts: StackCount?, lastPeriodTitle: String?) {
//        
//        // make sure we have the right navigation
//        catchesChartTableViewCell.navigationStrip.setItems([])
//        // store counts
//        self.killCounts = [lastPeriodCounts, counts]
//        self.killCountsCurrentIndex = 1
//        
//        // configure the navigation
//        var items = [NavigationStripItem(title: title, itemData: counts)]
//        if let lastPeriodTitle = lastPeriodTitle {
//            items.append(NavigationStripItem(title: lastPeriodTitle, itemData: lastPeriodCounts))
//        }
//        self.catchesChartTableViewCell.navigationStrip.setItems(items)
//        
//        // tell chart to draw itself, the delegate methods below will supply details.
//        self.catchesChartTableViewCell.chart.drawChart()
//    }
//    
//    func configurePoisonChart(counts: StackCount, title: String, lastPeriodCounts: StackCount?, lastPeriodTitle: String?) {
//        
//        // store counts
//        self.baitCounts = [lastPeriodCounts, counts]
//        self.baitCountsCurrentIndex = 1
//        
//        // configure the navigation
//        var items = [NavigationStripItem(title: title, itemData: counts)]
//        if let lastPeriodTitle = lastPeriodTitle {
//            items.append(NavigationStripItem(title: lastPeriodTitle, itemData: lastPeriodCounts))
//        }
//        self.poisonChartTableViewCell.navigationStrip.setItems(items)
//        
//        // tell chart to draw itself, the delegate methods below will supply details.
//        self.poisonChartTableViewCell.chart.drawChart()
//    }
    
//    func configureKillChart(counts: StackCount?, title: String?, lastPeriodCounts: StackCount?, lastPeriodTitle: String?) {
//        if let killCounts = counts {
//            catchesChartTableViewCell.configureChart(currentData: killCounts, dataTitle: title, lastPeriodData: lastPeriodCounts, lastPeriodTitle: lastPeriodTitle)
//            
//            if let title = title,
//               let lastPeriodTitle = lastPeriodTitle {
//                catchesChartTableViewCell.navigationStrip.setItems([
//                    NavigationStripItem(title: title, itemData: counts),
//                    NavigationStripItem(title: lastPeriodTitle, itemData: lastPeriodCounts)]
//                )
//            }
//        }
//    }
//    
//    func configurePoisonChart(counts: StackCount?, title: String?, lastPeriodCounts: StackCount?, lastPeriodTitle: String?) {
//        if let poisonCounts = counts {
//            poisonChartTableViewCell.configureChart(currentData: poisonCounts, dataTitle: title, lastPeriodData: lastPeriodCounts, lastPeriodTitle: lastPeriodTitle)
//        }
//    }
  
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
