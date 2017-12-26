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
    
    fileprivate let STATION_ROW_CELL_ID = "cell"
    fileprivate let TOP_TABLEVIEW_CELL_ID = "cell2"
    fileprivate let HEADER_ID_ADDSTATIONS = "header_add"
    fileprivate let HEADER_ID_STATIONSECTION = "header_stationsection"
    
    fileprivate let SECTION_DETAILS = 0
    fileprivate let ROW_ROUTE_NAME = 0
    fileprivate let ROW_VISIT_FREQUENCY = 1
    
    fileprivate let SECTION_STATIONS_HEADER = 1
    fileprivate let ROW_STATIONS_HEADER_DESCRIPTION = 0
    
    fileprivate var groupedData: GroupedTableViewDatasource<Station>?
    
    // MARK: - Subviews
    
    lazy var topTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.STATION_ROW_CELL_ID)
        tableView.register(TableViewHeaderWithAction.self, forHeaderFooterViewReuseIdentifier: self.HEADER_ID_ADDSTATIONS)
        tableView.register(TableViewHeaderWithAction.self, forHeaderFooterViewReuseIdentifier: self.HEADER_ID_STATIONSECTION)
        
        return tableView
    }()

    func addSection(sender: UIButton) {
        presenter.didSelectAddSection()
    }
    
    lazy var closeButton: UIBarButtonItem = {
        
        var view = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(closeButtonClick(sender:)))
        
        return view
    }()
    
    lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(doneButtonClick(sender:)))
        return button
    }()
    
    lazy var routeNameTableViewCell: UITableViewCell = {
       
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: self.TOP_TABLEVIEW_CELL_ID)
        
        cell.contentView.addSubview(self.routeNameTextField)
        
        self.routeNameTextField.autoPinEdgesToSuperviewEdges()
        self.routeNameTextField.autoSetDimension(.height, toSize: LayoutDimensions.tableCellHeight)
        
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
        textField.returnKeyType = UIReturnKeyType.done
        return textField
    }()
    
    lazy var visitFrequencyTableViewCell: UITableViewCell = {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: self.TOP_TABLEVIEW_CELL_ID)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = "Visit frequency"
        cell.selectionStyle = .none
        
        return cell
    }()
    
    lazy var sectionHeadingDescriptionTableViewCell: UITableViewCell = {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: self.TOP_TABLEVIEW_CELL_ID)
        cell.accessoryType = .none
        cell.textLabel?.text = "Add stations from one or more  traplines."
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        //cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        return cell
    }()
    
    //MARK: - Helpers
    
    fileprivate func adjustedStationSection(section: Int) -> Int {
        return section - 2
    }
    
    //MARK: - UIViewController
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //HACK - this prevents the Save button changing color from white!
        // https://stackoverflow.com/questions/39026593/handling-tint-color-changes-of-uibarbuttonitems-in-navigation-controller
        navigationController?.navigationBar.tintColorDidChange()
    }
    
    override func loadView() {
        
        super.loadView()
        
        self.view.backgroundColor = UIColor.trpBackground
        self.navigationItem.leftBarButtonItem = closeButton
        self.navigationItem.rightBarButtonItem = doneButton
        
        self.view.addSubview(topTableView)
        setConstraints()
    }
    
    func setConstraints() {
        
        self.topTableView.autoPinEdgesToSuperviewEdges()
    }

    //MARK: - Events
    
    func closeButtonClick(sender: UIBarButtonItem) {
        presenter.didSelectClose()
    }
    
    func doneButtonClick(sender: UIButton) {
        presenter.didSelectDone()
    }
}

//MARK: - SectionStripViewDelegate
extension RouteView: SectionStripViewDelegate {
    
    func sectionStrip(_ sectionStripView: SectionStripView, didSelectActionButton: UIButton) {
        presenter.didSelectAddSection()
    }
}

//MARK: - UITextFieldDelegate
extension RouteView: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        presenter.didUpdateRouteName(name: textField.text)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension RouteView: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        
        // Details
        // + Stations
        // + Each Station Groupp
        return 1 + 1 + (groupedData?.numberOfSections() ?? 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == SECTION_DETAILS {
            return 2
        } else if section == SECTION_STATIONS_HEADER {
            return 0
        } else {
            return groupedData?.numberOfRowsInSection(section: adjustedStationSection(section: section)) ?? 0
        }
        
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == SECTION_DETAILS {
            if indexPath.row == ROW_VISIT_FREQUENCY {
                return self.visitFrequencyTableViewCell
            } else if indexPath.row == ROW_ROUTE_NAME {
                return self.routeNameTableViewCell
            }
        } else if indexPath.section > SECTION_STATIONS_HEADER {
            let cell = tableView.dequeueReusableCell(withIdentifier: self.STATION_ROW_CELL_ID, for: indexPath)
            cell.textLabel?.text = groupedData?.cellLabelText(section: adjustedStationSection(section: indexPath.section), row: indexPath.row)
            return cell
        }
//        else if indexPath.section == SECTION_STATIONS_HEADER {
//            return sectionHeadingDescriptionTableViewCell
//        }
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == SECTION_STATIONS_HEADER {
            if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HEADER_ID_ADDSTATIONS) as? TableViewHeaderWithAction {
                header.delegate = self
                header.section = section
                header.actionButton.setTitle("Add", for: .normal)
                header.detailTextLabel?.text = "Add stations from one or more  traplines."
                return header
            }
        } else if section > SECTION_STATIONS_HEADER {
            if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HEADER_ID_STATIONSECTION) as? TableViewHeaderWithAction {
                header.delegate = self
                header.section = section
                
                let image = UIImage(named: "show")?.withRenderingMode(.alwaysTemplate)
                header.actionButton.setImage(image, for: .normal)
                header.actionButton.tintColor = UIColor.trpNavigationBar
                
                return header
            }
        }
        return tableView.headerView(forSection: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == SECTION_STATIONS_HEADER {
            return "TRAPLINES"
        } else if section == SECTION_DETAILS {
            return "DETAILS"
        } else {
            return groupedData?.sectionText(section: adjustedStationSection(section: section)) ?? ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_DETAILS && indexPath.row == ROW_VISIT_FREQUENCY {
            presenter.didSelectToChangeVisitFrequency()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == SECTION_STATIONS_HEADER {
            return LayoutDimensions.tableHeaderHeight * 1
        }
        return LayoutDimensions.tableHeaderHeight
    }
    
}

//MARK: - TableViewHeaderWithActionDelegate
extension RouteView: TableViewHeaderWithActionDelegate {
    func tableViewHeaderWithAction(_ tableViewHeaderWithAction: TableViewHeaderWithAction, actionButtonClickedForSection section: Int) {
        if tableViewHeaderWithAction.reuseIdentifier == HEADER_ID_ADDSTATIONS {
            presenter.didSelectAddSection()
        }
        if tableViewHeaderWithAction.reuseIdentifier == HEADER_ID_STATIONSECTION {
            // open menu
            presenter.didSelectShowSectionMenu(section: adjustedStationSection(section: section))
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
        self.topTableView.reloadData()
    }
    
    func displayNoSectionsText(text: String) {
        //self.noSectionsLabel.text = text
    }
    
    func hideSectionsTableView(hide: Bool) {
//        tableView.alpha = hide ? 0 : 1
//        noSectionsLabel.alpha = hide ? 1 : 0
    }
    
    func refreshSectionTableView() {
        topTableView.reloadData()
    }
    
    func displaySectionMenuOptionItems(title: String?, message: String?, optionItems: [OptionItem]) {
        let menu = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        for option in optionItems {
            
            let style: UIAlertActionStyle = option.isDestructive ? .destructive : .default
            let optionItem = UIAlertAction(title: option.title, style: style, handler: {
                (action) in
                if let title = action.title {
                    self.presenter.didSelectSectionMenuOptionItem(title: title)
                }
            })
            optionItem.isEnabled = option.isEnabled
            menu.addAction(optionItem)
        }
        
        // always add a cancel
        menu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(menu, animated: true, completion: nil)
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
