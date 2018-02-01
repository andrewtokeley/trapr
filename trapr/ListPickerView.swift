//
//  ListPickerView.swift
//  trapr
//
//  Created by Andrew Tokeley  on 3/11/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import UIKit
import Viperit

//MARK: ListPickerView Class
final class ListPickerView: UserInterface {
    
    fileprivate let CELL_ID = "cell"
    fileprivate let TABLEVIEW_HEADER_ID = "header"
    fileprivate var multiselectEnabled = false
    fileprivate var selectedIndices = [Int]()
    fileprivate var includeSelectNone: Bool = false
    
    //MARK: - Subviews
    
    lazy var doneButton: UIBarButtonItem = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(doneButtonClick(sender:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        return barButton
    }()
    
    lazy var closeButton: UIBarButtonItem = {
        var view = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(closeButtonClick(sender:)))
        return view
    }()
    
    lazy var tableView: UITableView = {
       
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.CELL_ID)
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    //MARK: - UIViewController
    
    override func loadView() {
        super.loadView()

        self.view.addSubview(tableView)
        
        setConstraints()
    }
    
    private func setConstraints() {
        tableView.autoPinEdgesToSuperviewEdges()
    }

    fileprivate func adjRow(_ index: Int) -> Int {
        return includeSelectNone ? index - 1 : index
    }
    
    //MARK: - Events
    
    @objc func doneButtonClick(sender: UIButton) {
        presenter.didSelectDone()
    }
    
    @objc func closeButtonClick(sender: UIButton) {
        presenter.didSelectClose()
    }
}

//MARK: - UITableView
extension ListPickerView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (displayData.delegate?.listPickerNumberOfRows(self) ?? 0) +  (includeSelectNone ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: CELL_ID)
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: CELL_ID)
        }
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        cell!.selectionStyle = .none
        cell!.detailTextLabel?.numberOfLines = 0

        if includeSelectNone && indexPath.row == 0 {
            cell!.textLabel?.text = "None"
            cell!.detailTextLabel?.text = ""
        } else {
            cell!.textLabel?.text = displayData.delegate?.listPicker(self, itemTextAt: adjRow(indexPath.row))
            cell!.detailTextLabel?.text = displayData.delegate?.listPicker(self, itemDetailAt: adjRow(indexPath.row))
        }
        
        cell!.accessoryType = selectedIndices.contains(adjRow(indexPath.row)) ? .checkmark : .none
        
        if !multiselectEnabled {
            if displayData.delegate?.listPickerHasChildListPicker(self) ?? false {
                cell!.accessoryType = .disclosureIndicator
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if multiselectEnabled {
            
            let initalMultipleSelectState = displayData.delegate?.listPickerInitialMultiselectState(self)
            
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TABLEVIEW_HEADER_ID) as? MultiselectTableViewHeader ?? MultiselectTableViewHeader(reuseIdentifier: TABLEVIEW_HEADER_ID, initialState: initalMultipleSelectState ?? .none)
            header.textLabel?.text = displayData.delegate?.listPickerHeaderText(self)
            header.section = section
            header.multiselectDelegate = self
            return header
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return displayData.delegate?.listPickerHeaderText(self)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (includeSelectNone && indexPath.row == 0) {
            presenter.didSelectNoSelection()
        } else {
            presenter.didSelectItem(row: adjRow(indexPath.row))
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return LayoutDimensions.tableHeaderHeight
    }

}

//MARK: - MultiselectTableViewHeaderDelegate

extension ListPickerView: MultiselectTableViewHeaderDelegate {
    
    func multiselectTableViewHeader(_ header: MultiselectTableViewHeader, multiselectOptionClicked: MultiselectOptions, section: Int) {
        
        if multiselectOptionClicked == .selectAll {
            presenter.didSelectAllItems()
        } else if multiselectOptionClicked == .selectNone {
            presenter.didSelectNoItems()
        }
    }
}

//MARK: - ListPickerView API
extension ListPickerView: ListPickerViewApi {
    
    var tag: Int { return self.view.tag }
    
    func setTag(tag: Int) {
        self.view.tag = tag
    }
    
    func showCloseButton(show: Bool) {
        self.navigationItem.leftBarButtonItem = show ? closeButton : nil
    }
    
//    func setTitle(title: String) {
//        self.title = title
//    }
//    
    func setSelectedIndices(indices: [Int]) {
        self.selectedIndices = indices
        self.tableView.reloadData()
    }
    
    func showDoneButton(show: Bool) {
        self.navigationItem.rightBarButtonItem = show ? doneButton : nil
    }
    
    func enableMultiselect(enable: Bool) {
        self.multiselectEnabled = enable
    }
    
    func includeSelectNone(enable: Bool) {
        self.includeSelectNone = enable
        tableView.reloadData()
    }
}

// MARK: - ListPickerView Viper Components API
private extension ListPickerView {
    var presenter: ListPickerPresenterApi {
        return _presenter as! ListPickerPresenterApi
    }
    var displayData: ListPickerDisplayData {
        return _displayData as! ListPickerDisplayData
    }
}
