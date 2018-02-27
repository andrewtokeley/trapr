//
//  NewRouteView.swift
//  trapr
//
//  Created by Andrew Tokeley on 19/01/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import UIKit
import Viperit

//MARK: NewRouteView Class
final class NewRouteView: UserInterface {
    
    fileprivate let SECTION_NAME = 0
    fileprivate let ROW_NAME = 0
    fileprivate let SECTION_FIRSTSTATION = 1
    fileprivate let ROW_TRAPLINE = 0
    fileprivate let ROW_STATION = 1
    fileprivate let TABLEVIEWCELL_ID = "cell"
    
    fileprivate var traplines = [Trapline]()
    
    //MARK: UIViewController
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        routeNameTextField.becomeFirstResponder()
    }
    //MARK: Subviews
    
    lazy var tableVIew: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var tableViewCellName: UITableViewCell = {
        let cell = UITableViewCell()
        cell.contentView.addSubview(routeNameTextField)
        routeNameTextField.autoPinEdgesToSuperviewEdges()
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var tableViewCellTrapline: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        cell.textLabel?.text = "Trapline"
        return cell
    }()
    
    lazy var tableViewCellStation: UITableViewCell = {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        cell.selectionStyle = .none
        cell.textLabel?.text = "First Station"
        return cell
    }()
    
    lazy var routeNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name of your route..."
        textField.delegate = self
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:LayoutDimensions.textIndentMargin, height:LayoutDimensions.textIndentMargin))
        textField.leftViewMode = .always
        textField.leftView = spacerView
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = UIReturnKeyType.done
        
        textField.addTarget(self, action: #selector(textFieldDidChange(sender:)), for: .editingChanged)
        return textField
    }()
    
    lazy var cancelButton: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.setTitle("Cancel", for: .normal)
        button.addTarget(self, action: #selector(cancelButtonClick(sender:)), for: .touchUpInside)
        var view = UIBarButtonItem(customView: button)
        return view
    }()
    
    lazy var nextButton: UIBarButtonItem = {
        
        let button = UIButton(type: .custom)
        button.setTitle("Next", for: .normal)
        button.addTarget(self, action: #selector(nextButtonClick(sender:)), for: .touchUpInside)
        var view = UIBarButtonItem(customView: button)
        return view
    }()
    
    // MARK: - Events
    
    @objc func textFieldDidChange(sender: UITextField) {
        presenter.didUpdateRouteName(name: sender.text)
    }
    
    @objc func cancelButtonClick(sender: UIBarButtonItem) {
        presenter.didSelectCancel()
    }
    
    @objc func nextButtonClick(sender: UIBarButtonItem) {
        presenter.didSelectNext()
    }
    
    @objc func viewClicked(sender: UIView) {
        routeNameTextField.endEditing(true)
        
    }
    
    // MARK: - UIViewController
    
    override func loadView() {
        
        super.loadView()
        
        self.view.backgroundColor = UIColor.trpBackground
        
        // ensure the keyboard disappears when click view
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewClicked(sender:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        self.navigationController?.view.addGestureRecognizer(tap)
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = nextButton
        
        view.addSubview(tableVIew)
        
        setConstraints()
    }
    
    private func setConstraints() {
        tableVIew.autoPinEdgesToSuperviewEdges()
    }
    
    
}

//MARK: - UITableView
extension NewRouteView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SECTION_NAME { return 1 }
        if section == SECTION_FIRSTSTATION { return 2 }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        
        if section == SECTION_NAME {
            if row == ROW_NAME {
                return tableViewCellName
            }
        } else if section == SECTION_FIRSTSTATION {
            if row == ROW_TRAPLINE {
                return tableViewCellTrapline
            } else if row == ROW_STATION {
                return tableViewCellStation
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == SECTION_FIRSTSTATION {
            return "Start of Route"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == SECTION_NAME {
            return LayoutDimensions.inputHeight
        }
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_FIRSTSTATION && indexPath.row == ROW_TRAPLINE {
            presenter.didSelectTraplineListPicker()
        } else {
            presenter.didSelectStationListPicker()
        }
        
    }
}

//MARK: - UITextFieldDelegate
extension NewRouteView: UITextFieldDelegate {
    
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        presenter.didUpdateRouteName(name: textField.text)
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

//MARK: - NewRouteView API
extension NewRouteView: NewRouteViewApi {
    
    func displayRouteName(name: String?) {
        routeNameTextField.text = name
    }
    
    func enableNextButton(enabled: Bool) {
        nextButton.isEnabled = enabled
    }
    
    func setTraplines(traplines: [Trapline]) {
        self.traplines = traplines
    }
    
    func displaySelectedTrapline(description: String?) {
        tableViewCellTrapline.detailTextLabel?.text = description
    }
    
    func displaySelectedStation(description: String?) {
        tableViewCellStation.detailTextLabel?.text = description
    }
    
}

// MARK: - NewRouteView Viper Components API
private extension NewRouteView {
    var presenter: NewRoutePresenterApi {
        return _presenter as! NewRoutePresenterApi
    }
    var displayData: NewRouteDisplayData {
        return _displayData as! NewRouteDisplayData
    }
}
