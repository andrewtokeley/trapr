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
    
    fileprivate var traplines = [Trapline]()
    fileprivate var stations = [Station]()
    fileprivate var selectedStations = [Station]()
    
    fileprivate var allowMultiselect: Bool = false
    
    // Constants
    fileprivate let TABLEVIEW_CELL_ID = "cell"
    fileprivate let TABLEVIEW_HEADER_ID = "header"
    
    fileprivate var EDIT_BUTTON_TEXT = "Edit"
    
    //MARK: - Events
    
    func editButtonClick(sender: UIBarButtonItem) {
        presenter.didSelectEdit()
    }
    
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
    
    lazy var editButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: self.EDIT_BUTTON_TEXT, style: .plain, target: self, action: #selector(editButtonClick(sender:)))
        
        return button
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
    
    private func stationsInSection(section: Int) -> [Station] {
        let traplineCode = traplines[section].code
        let stationsInTrapline = stations.filter({ $0.trapline?.code == traplineCode })
        return stationsInTrapline
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return traplines.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stationsInSection(section:section).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TABLEVIEW_CELL_ID, for: indexPath)
        
        let station = stationsInSection(section: indexPath.section)[indexPath.row]
        
        if (self.selectedStations.contains(where: { $0.longCode == station.longCode })) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.selectionStyle = .none
        cell.textLabel?.text = station.code
        return cell
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//
//        return traplines[section].code?.uppercased()
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let station = stationsInSection(section: indexPath.section)[indexPath.row]
        
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TABLEVIEW_HEADER_ID) as? MultiselectTableViewHeader ?? MultiselectTableViewHeader(reuseIdentifier: TABLEVIEW_HEADER_ID)
        
        header.textLabel?.text = self.traplines[section].code?.uppercased()
        header.section = section
        header.delegate = self
        header.setState(state: presenter.getToggleState(section: section))
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
}

extension StationSelectView: MultiselectTableViewHeaderDelegate {
    
    func multiselectTableViewHeader(_ header: MultiselectTableViewHeader, toggledSection: Int) {
        presenter.didSelectMultiselectToggle(section: toggledSection)
    }

}

//MARK: - StationSelectView API
extension StationSelectView: StationSelectViewApi {
    
    func setMultiselectToggle(section: Int, state: MultiselectToggle) {
        
        tableView.reloadSections([section] as IndexSet, with: .automatic)
    }
    
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
    
    func updateSelectedStations(section: Int, selectedStations: [Station]) {
        self.selectedStations = selectedStations
        
        tableView.reloadSections([section] as IndexSet, with: .automatic)
    }
    
    func initialiseView(traplines:[Trapline], stations: [Station], selectedStations: [Station]?, allowMultiselect: Bool) {

        self.traplines = traplines
        self.stations = stations
        self.selectedStations = selectedStations ?? [Station]()
        self.allowMultiselect = allowMultiselect
        
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
