//
//  StationSelectView.swift
//  trapr
//
//  Created by Andrew Tokeley  on 3/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import UIKit
import Viperit

//MARK: StationSelectView Class
final class StationSelectView: UserInterface {
    
    fileprivate var traplines: [Trapline]!
    fileprivate var selectedStationsByTrapline: [[Station]]?
    fileprivate var showAllStations: Bool = true
    fileprivate var selectedStations: [Station]?
    fileprivate var allowMultiselect: Bool = false
    
    // Constants
    fileprivate let TABLEVIEW_CELL_ID = "cell"

    // may not need
    fileprivate var currentStation: Station!
    
    //MARK: - Private helpers
    fileprivate func selectedStationsInTrapline(trapline: Trapline) -> [Station] {
        
        var stations = [Station]()
        if let _ = selectedStations {
            for station in trapline.stations {
                if selectedStations!.contains(where: { $0.code == station.code }) {
                    stations.append(station)
                }
            }
        }
        return stations
    }
    
    //MARK: - Events
    
    func closeButtonClick(sender: UIBarButtonItem) {
        presenter.didSelectCloseButton()
    }

    func doneButtonClick(sender: UIBarButtonItem) {
        presenter.didSelectDone()
    }
    
    // MARK: - Subviews
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.TABLEVIEW_CELL_ID)
        
        return tableView
    }()
    
    lazy var closeButton: UIBarButtonItem = {
        
        var view = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(closeButtonClick(sender:)))
        
        return view
    }()
    
    lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButtonClick(sender:)))
        return button
    }()
    
    //MARK: - UIViewController
    override func loadView() {
        
        super.loadView()
        
        self.view.addSubview(tableView)
        
        setConstraints()
    }
    
    func setConstraints() {
        self.tableView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero)
    }

}

//MARK: - TableView Delegates
extension StationSelectView: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return traplines.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showAllStations {
            return traplines[section].stations.count
        } else {
            return selectedStationsByTrapline?[section].count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TABLEVIEW_CELL_ID, for: indexPath)
        
        var station: Station
        if showAllStations {
            station = traplines[indexPath.section].stations[indexPath.row]
        } else {
            station = (selectedStationsByTrapline?[indexPath.section][indexPath.row])!
        }
        
        if (self.selectedStations?.contains(station)) ?? false {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.selectionStyle = .none
        cell.textLabel?.text = station.code
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return traplines[section].code?.uppercased()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var station: Station
        if showAllStations {
            station = traplines[indexPath.section].stations[indexPath.row]
        } else {
            station = (selectedStationsByTrapline?[indexPath.section][indexPath.row])!
        }

        if allowMultiselect {
            let cell = tableView.cellForRow(at: indexPath)
            
            if cell?.accessoryType == .checkmark {
                cell?.accessoryType = .none
                presenter.didDeselectStation(station: station)
            } else {
                cell?.accessoryType = .checkmark
                presenter.didSelectStation(station: station)
            }
        } else {
            presenter.didSelectStation(station: station)
        }
        
    }
}
//MARK: - StationSelectView API
extension StationSelectView: StationSelectViewApi {
    
    func setTitle(title: String) {
        
        self.title = title
    }
    
    func showCloseButton() {
        self.navigationItem.leftBarButtonItem = closeButton
    }
    
    func setDoneButtonAttributes(visible: Bool, enabled: Bool) {
        if visible {
            self.navigationItem.rightBarButtonItem = doneButton
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        doneButton.isEnabled = enabled
    }
    
//    func updateViewWithStation(currentStation: Station, visitSummary: VisitSummary) {
//        
//        self.traplines = visitSummary.route.traplines
//        self.currentStation = currentStation
//        tableView.reloadData()
//    }

    func initialiseView(traplines: [Trapline], selectedStations: [Station]?, showAllStations: Bool, allowMultiselect: Bool) {
        self.traplines = traplines
        self.selectedStations = selectedStations
        self.showAllStations = showAllStations
        self.allowMultiselect = allowMultiselect
        
        self.selectedStationsByTrapline = [[Station]]()
        for trapline in self.traplines {
            self.selectedStationsByTrapline?.append(selectedStationsInTrapline(trapline: trapline))
        }
        tableView.reloadData()
    }
    
}

// MARK: - StationSelectView Viper Components API
private extension StationSelectView {
    var presenter: StationSelectPresenterApi {
        return _presenter as! StationSelectPresenterApi
    }
    var displayData: StationSelectDisplayData {
        return _displayData as! StationSelectDisplayData
    }
}
