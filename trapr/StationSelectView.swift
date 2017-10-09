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
final class StationSelectView: UserInterface, UITableViewDelegate, UITableViewDataSource {
    
    fileprivate var traplines: [Trapline]!
    fileprivate var currentStation: Station!
    
    private var SECTION_TRAPLINE = 0
    private var SECTION_STATIONS = 1
    private var TABLEVIEW_CELL_ID = "cell"
    
    //MARK: UITableview
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return traplines.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return traplines[section].stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TABLEVIEW_CELL_ID, for: indexPath)
        
        let station = traplines[indexPath.section].stations[indexPath.row]
        cell.textLabel?.text = station.code
        cell.accessoryType = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return traplines[section].code?.uppercased()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let station = traplines[indexPath.section].stations[indexPath.row]
        presenter.didSelectStation(station: station)
    }
    
    //MARK: - Events
    
    func closeButtonAction(sender: UIBarButtonItem) {
        
        presenter.didSelectCloseButton()
    }

    // MARK: Create View
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.TABLEVIEW_CELL_ID)
        
        return tableView
    }()
    
    lazy var closeButton: UIBarButtonItem = {
        
        var view = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(closeButtonAction(sender:)))
        
        return view
    }()
    
    override func loadView() {
        
        super.loadView()
        
        self.view.addSubview(tableView)
        self.navigationItem.leftBarButtonItem = closeButton

        setConstraints()
    }
    
    func setConstraints() {
        
        self.tableView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero)
    }

}

//MARK: - StationSelectView API
extension StationSelectView: StationSelectViewApi {
    
    func setTitle(title: String) {
        
        self.title = title
    }
    
    func updateViewWithStation(currentStation: Station, visitSummary: VisitSummary) {
        
        self.traplines = visitSummary.traplines
        self.currentStation = currentStation
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
