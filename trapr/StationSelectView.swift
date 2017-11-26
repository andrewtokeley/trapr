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
    fileprivate var groupedData: GroupedTableViewDatasource<Station>!
    
    fileprivate var allowMultiselect: Bool = false
    
    // Constants
    fileprivate let TABLEVIEW_CELL_ID = "cell"
    fileprivate let TABLEVIEW_HEADER_ID = "header"
    
    fileprivate var EDIT_BUTTON_TEXT = "Sort"
    
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
    
//    private func stationsInSection(section: Int) -> [Station] {
//        let traplineCode = traplines[section].code
//        let stationsInTrapline = stations.filter({ $0.trapline?.code == traplineCode })
//        return stationsInTrapline
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.groupedData.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupedData.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TABLEVIEW_CELL_ID, for: indexPath)
        
        let groupedDataItem = self.groupedData.data(section: indexPath.section, row: indexPath.row)
        
        cell.accessoryType = groupedDataItem.selected ? .checkmark : .none
        cell.selectionStyle = .none
        cell.textLabel?.text = self.groupedData.cellLabelText(section: indexPath.section, row: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //let station = stationsInSection(section: indexPath.section)[indexPath.row]
        //let groupedDataItem = self.groupedData.data(section: indexPath.section, row: indexPath.row)
        
        presenter.didSelectRow(section: indexPath.section, row: indexPath.row)
        
//        if allowMultiselect {
//            let cell = tableView.cellForRow(at: indexPath)
//
//            if cell?.accessoryType == .checkmark {
//                cell?.accessoryType = .none
//                presenter.didDeselectStation(section: indexPath.section, station: groupedDataItem.item)
//            } else {
//                cell?.accessoryType = .checkmark
//                presenter.didSelectStation(section: indexPath.section, station: groupedDataItem.item)
//            }
//        } else {
//            presenter.didSelectStation(section: indexPath.section, station: groupedDataItem.item)
//        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TABLEVIEW_HEADER_ID) as? MultiselectTableViewHeader ?? MultiselectTableViewHeader(reuseIdentifier: TABLEVIEW_HEADER_ID)
        
        header.textLabel?.text = self.groupedData.sectionText(section: section)
        header.section = section
        header.multiselectDelegate = self
        header.displayMultiselectOption(option: presenter.getToggleState(section: section))
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        presenter.didMoveRow(from: sourceIndexPath, to: destinationIndexPath)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        return proposedDestinationIndexPath
    }
    
}

extension StationSelectView: MultiselectTableViewHeaderDelegate {
    
    func multiselectTableViewHeader(_ header: MultiselectTableViewHeader, multiselectOptionClicked: MultiselectOptions, section: Int) {
        presenter.didSelectMultiselectToggle(section: section)
    }    
}

//MARK: - StationSelectView API
extension StationSelectView: StationSelectViewApi {
    
    func setMultiselectToggle(section: Int, state: MultiselectOptions) {
        
        if let header = tableView.headerView(forSection: section) as? MultiselectTableViewHeader {
            header.displayMultiselectOption(option: state)
        }
    }
    
    func setTitle(title: String) {
        
        self.title = title
    }
    
    func showCloseButton() {
        self.navigationItem.leftBarButtonItem = closeButton
    }
    
    func setDoneButtonAttributes(visible: Bool, enabled: Bool) {
        if visible {
            self.navigationItem.setRightBarButtonItems([doneButton, editButton], animated: true)
        } else {
            self.navigationItem.rightBarButtonItems?.removeAll()
        }
        
        doneButton.isEnabled = enabled
        editButton.isEnabled = enabled
    }
    
    func updateGroupedData(groupedData: GroupedTableViewDatasource<Station>) {
        self.groupedData = groupedData
        tableView.reloadData()
    }
    
    func updateGroupedData(section: Int, groupedData: GroupedTableViewDatasource<Station>) {
        self.groupedData = groupedData
        tableView.reloadSections([section] as IndexSet, with: .automatic)
    }
    
    func updateSelectedStations(section: Int, selectedStations: [Station]) {
        self.selectedStations = selectedStations
        tableView.reloadSections([section] as IndexSet, with: .automatic)
    }
    
    func initialiseView(groupedData: GroupedTableViewDatasource<Station>, traplines:[Trapline], stations: [Station], selectedStations: [Station]?, allowMultiselect: Bool) {

        self.groupedData = groupedData
        self.traplines = traplines
        self.stations = stations
        self.selectedStations = selectedStations ?? [Station]()
        self.allowMultiselect = allowMultiselect
        
        tableView.reloadData()
    }
    
    func enableSorting(enabled: Bool) {
        tableView.setEditing(enabled, animated: true)
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
