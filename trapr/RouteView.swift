//
//  RouteView.swift
//  trapr
//
//  Created by Andrew Tokeley on 21/11/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import UIKit
import Viperit

//MARK: RouteView Class
final class RouteView: UserInterface {
    
    fileprivate let TABLEVIEW_CELL_ID = "cell"
    fileprivate let TOP_TABLEVIEW_CELL_ID = "cell2"
    
    fileprivate let SECTION_ROUTE_NAME = 0
    fileprivate let ROW_ROUTE_NAME = 0
    
    fileprivate let SECTION_VISIT_FREQUENCY = 0
    fileprivate let ROW_VISIT_FREQUENCY = 1
    
    fileprivate var groupedData: GroupedTableViewDatasource<Station>?
    
    // MARK: - Subviews
    
    lazy var topTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.TOP_TABLEVIEW_CELL_ID)
        
        return tableView
    }()

    lazy var sectionHeader: SectionStripView = {
        let view = Bundle.main.loadNibNamed("SectionStripView", owner: nil, options: nil)?.first as! SectionStripView
        view.delegate = self
        view.backgroundColor = UIColor.trpBackground
        view.titleLabel.text = "Sections"
        view.titleLabel.font = UIFont.trpLabelLarge
        view.actionButton.setTitle("Add", for: .normal)
        return view
    }()
    
    func addSection(sender: UIButton) {
        presenter.didSelectAddSection()
    }

    lazy var noSectionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.trpTextSmall
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
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
    
    lazy var routeNameTableViewCell: UITableViewCell = {
       
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: self.TOP_TABLEVIEW_CELL_ID)
        
        cell.contentView.addSubview(self.routeNameTextField)
        
        //cell.autoSetDimension(.height, toSize: LayoutDimensions.inputHeight)
        self.routeNameTextField.autoPinEdgesToSuperviewEdges()
        self.routeNameTextField.autoSetDimension(.height, toSize: LayoutDimensions.inputHeight)
        
        return cell
    }()
    
    lazy var routeNameTextField: UITextField = {
        
        let textField = UITextField()
        textField.placeholder = "Route name"
        textField.delegate = self
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:LayoutDimensions.textIndentMargin, height:LayoutDimensions.textIndentMargin))
        textField.leftViewMode = .always
        textField.leftView = spacerView
        textField.clearButtonMode = .whileEditing
        
        return textField
    }()
    
    lazy var visitFrequencyTableViewCell: UITableViewCell = {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: self.TOP_TABLEVIEW_CELL_ID)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "Visit frequency"
        cell.selectionStyle = .none
        
        return cell
    }()
    
    //MARK: - UIViewController
    override func loadView() {
        
        super.loadView()
        
        self.view.backgroundColor = UIColor.trpBackground
        self.navigationItem.leftBarButtonItem = closeButton
        self.navigationItem.rightBarButtonItem = doneButton
        
        self.view.addSubview(topTableView)
        self.view.addSubview(sectionHeader)
        self.view.addSubview(noSectionsLabel)
        self.view.addSubview(tableView)
        
        setConstraints()
    }
    
    func setConstraints() {
        self.topTableView.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        self.topTableView.autoPinEdge(toSuperviewEdge: .left)
        self.topTableView.autoPinEdge(toSuperviewEdge: .right)
        self.topTableView.autoSetDimension(.height, toSize: 180) // better way
        
        self.sectionHeader.autoPinEdge(.top, to: .bottom, of: self.topTableView)
        self.sectionHeader.autoPinEdge(toSuperviewEdge: .left)
        self.sectionHeader.autoPinEdge(toSuperviewEdge: .right)
        self.sectionHeader.autoSetDimension(.height, toSize: LayoutDimensions.inputHeight)
        
        self.noSectionsLabel.autoPinEdge(.top, to: .bottom, of: self.sectionHeader, withOffset: LayoutDimensions.spacingMargin)
        self.noSectionsLabel.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.textIndentMargin)
        self.noSectionsLabel.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.textIndentMargin)
        
        self.tableView.autoPinEdge(.top, to: .bottom, of: self.sectionHeader)
        self.tableView.autoPinEdge(toSuperviewEdge: .left)
        self.tableView.autoPinEdge(toSuperviewEdge: .right)
        self.tableView.autoPinEdge(toSuperviewEdge: .bottom)
    }

    //MARK: - Events
    
    func closeButtonClick(sender: UIBarButtonItem) {
        presenter.didSelectClose()
    }
    
    func doneButtonClick(sender: UIButton) {
        presenter.didSelectDone()
    }
}

extension RouteView: SectionStripViewDelegate {
    
    func sectionStrip(_ sectionStripView: SectionStripView, didSelectActionButton: UIButton) {
        presenter.didSelectAddSection()
    }
}

extension RouteView: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        presenter.didUpdateRouteName(name: textField.text)
    }

}

extension RouteView: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tableView {
            return groupedData?.numberOfSections() ?? 0
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return groupedData?.numberOfRowsInSection(section: section) ?? 0
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.TABLEVIEW_CELL_ID, for: indexPath)
            
            cell.textLabel?.text = groupedData?.cellLabelText(section: indexPath.section, row: indexPath.row)
            return cell
            
        } else {
            if indexPath.section == SECTION_ROUTE_NAME && indexPath.row == ROW_ROUTE_NAME {
                let cell = self.routeNameTableViewCell
                return cell
            } else { // if indexPath.row == ROW_VISIT_FREQUENCY {
                let cell = self.visitFrequencyTableViewCell
                //cell.detailTextLabel?.text = "Monthly" // TODO
                return cell
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == self.tableView {
            return groupedData?.sectionText(section: section) ?? ""
        } else {
            return "ROUTE DETAILS"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.topTableView {
            if indexPath.section == SECTION_VISIT_FREQUENCY {
                presenter.didSelectToChangeVisitFrequency()
            }
        }
    }
    
}

//MARK: - RouteView API
extension RouteView: RouteViewApi {
    
    func setTitle(title: String?) {
        self.title = title
    }
    
    func displayRouteName(name: String) {
        self.routeNameTextField.text = name
    }
    
    func displayVisitFrequency(frequency: TimePeriod) {
        self.visitFrequencyTableViewCell.detailTextLabel?.text = frequency.name
    }
    
    func setFocusToRouteName() {
        
    }
    
    func bindToGroupedTableViewData(groupedData: GroupedTableViewDatasource<Station>) {
        self.groupedData = groupedData
        self.tableView.reloadData()
    }
    
    func displayNoSectionsText(text: String) {
        self.noSectionsLabel.text = text
    }
    
    func hideSectionsTableView(hide: Bool) {
        tableView.alpha = hide ? 0 : 1
        noSectionsLabel.alpha = hide ? 1 : 0
    }
    
    func refreshSectionTableView() {
        tableView.reloadData()
    }
    
    func displaySectionMenuOptionItems(optionItems: [OptionItem]) {
        
    }
    
    
}

// MARK: - RouteView Viper Components API
private extension RouteView {
    var presenter: RoutePresenterApi {
        return _presenter as! RoutePresenterApi
    }
    var displayData: RouteDisplayData {
        return _displayData as! RouteDisplayData
    }
}
