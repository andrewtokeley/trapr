//
//  StationSearchView.swift
//  trapr
//
//  Created by Andrew Tokeley on 6/06/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import UIKit
import Viperit

//MARK: StationSearchView Class
final class StationSearchView: UserInterface {
    
    fileprivate let CELL_ID = "cell"
    fileprivate var nearbyStations = [Station]()
    fileprivate var nearbyStationDistances = [String]()
    fileprivate var otherStations = [Station]()
    fileprivate var displayingSearchResults = false
    fileprivate var filteredStations = [Station]()
    
    //MARK: Helpers
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    //MARK: Subviews
    
    lazy var addStationButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(addStationButtonClick(sender:)))
        return button
    }()
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Search"
        return controller
    }()
    
    //MARK: - Events
    
    @objc func addStationButtonClick(sender: UIBarButtonItem) {
        presenter.didSelectAdd()
    }
    
    //MARK: - UIViewController
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(tableView)
        self.navigationItem.rightBarButtonItem = self.addStationButton
        
        // add search controller
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
        
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.searchBar.becomeFirstResponder()
    }
    private func setConstraints() {
        tableView.autoPinEdgesToSuperviewEdges()
    }
    
}

extension StationSearchView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        presenter.didEnterSearchTerm(searchTerm: searchController.searchBar.text!)
    }
}

//MARK: - UITableView
extension StationSearchView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if nearbyStations.count > 0 {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if nearbyStations.count > 0 {
            if section == 0 {
                return nearbyStations.count
            }
        }
        return otherStations.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: CELL_ID)
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: CELL_ID)
        }
        var detailText: String?
        
        if nearbyStations.count > 0 {
            if indexPath.section == 0 {
                cell?.textLabel?.text = nearbyStations[indexPath.row].longCode
                detailText = nearbyStationDistances[indexPath.row]
            } else {
                cell?.textLabel?.text = otherStations[indexPath.row].longCode
            }
        } else {
            cell?.textLabel?.text = otherStations[indexPath.row].longCode
        }
        
        cell?.detailTextLabel?.text = detailText
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if nearbyStations.count > 0 {
            if section == 0 {
                return "NEARBY"
            }
        }
        
        if displayingSearchResults {
            if otherStations.count != 0 {
                return "MATCHING STATIONS"
            } else {
                return "NO MATCHES"
            }
        } else {
            return "ALL STATIONS"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if nearbyStations.count > 0 {
            if indexPath.section == 0 {
                presenter.didSelectStation(station: nearbyStations[indexPath.row])
            } else {
                presenter.didSelectStation(station: otherStations[indexPath.row])
            }
        } else {
            presenter.didSelectStation(station: otherStations[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return LayoutDimensions.tableHeaderHeight
    }
    
}

//MARK: - StationSearchView API
extension StationSearchView: StationSearchViewApi {
    
    func showNearbyStations(stations: [Station], distances: [String]) {
        self.nearbyStations = stations
        self.nearbyStationDistances = distances
        self.displayingSearchResults = false
        tableView.reloadData()
    }
    
    func showOtherStations(stations: [Station]) {
        self.otherStations = stations
        self.displayingSearchResults = false
        tableView.reloadData()
    }
    
    func showSearchResults(stations: [Station]) {
        self.nearbyStations = [Station]()
        self.otherStations = stations
        self.displayingSearchResults = true
        tableView.reloadData()
    }
    
}

// MARK: - StationSearchView Viper Components API
private extension StationSearchView {
    var presenter: StationSearchPresenterApi {
        return _presenter as! StationSearchPresenterApi
    }
    var displayData: StationSearchDisplayData {
        return _displayData as! StationSearchDisplayData
    }
}
