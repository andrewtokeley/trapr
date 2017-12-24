//
//  ProfileView.swift
//  trapr
//
//  Created by Andrew Tokeley on 16/12/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import UIKit
import Viperit

//MARK: ProfileView Class
final class SettingsView: UserInterface {
    
    let TABLEVIEW_CELL_ID = "cell"
    
    let SECTION_USER =  0
    let ROW_TRAPPER_NAME = 0
    
    let SECTION_VERSIONS =  1
    let ROW_APP_VERSION = 0
    let ROW_REALM_VERSION = 1
    
    let SECTION_TESTING =  2
    let ROW_MERGE_TRAP_DATA = 0
    
    //MARK: - Subviews
    
    lazy var closeButton: UIBarButtonItem = {
        
        var view = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(closeButtonClick(sender:)))
        
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.STATION_ROW_CELL_ID)
        
        return tableView
    }()
    
    lazy var trapperNameTableViewCell: UITableViewCell = {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: self.TABLEVIEW_CELL_ID)
        
        cell.contentView.addSubview(self.trapperNameTextField)
        
        self.trapperNameTextField.autoPinEdgesToSuperviewEdges()
        self.trapperNameTextField.autoSetDimension(.height, toSize: LayoutDimensions.tableCellHeight)
        
        return cell
    }()
    
    lazy var appVersionTableViewCell: UITableViewCell = {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: self.TABLEVIEW_CELL_ID)
        cell.textLabel?.text = "App Version"
        
        return cell
    }()

    lazy var realmVersionTableViewCell: UITableViewCell = {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: self.TABLEVIEW_CELL_ID)
        cell.textLabel?.text = "Realm Version"
        
        return cell
    }()

    lazy var trapperNameTextField: UITextField = {
        
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.delegate = self
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:LayoutDimensions.textIndentMargin, height:LayoutDimensions.textIndentMargin))
        textField.leftViewMode = .always
        textField.leftView = spacerView
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = UIReturnKeyType.done
        return textField
    }()
    
    lazy var mergeWithTrapDataButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.custom)
        button.setTitle("Merge", for: .normal)
        button.addTarget(self, action: #selector(mergeButtonClick(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var mergeWithTrapDataTableViewCell: UITableViewCell = {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: self.TABLEVIEW_CELL_ID)
        
        cell.contentView.addSubview(self.mergeWithTrapDataButton)
        cell.detailTextLabel?.text = "Merge current trap data with embedded file."
        
        self.mergeWithTrapDataButton.autoPinEdgesToSuperviewEdges()
        self.mergeWithTrapDataButton.autoSetDimension(.height, toSize: LayoutDimensions.tableCellHeight)
        
        return cell
    }()
    
    // MARK: - UIViewController
    
    override func loadView() {
        
        super.loadView()
        
        self.view.backgroundColor = UIColor.trpBackground
        self.navigationItem.leftBarButtonItem = closeButton
        self.view.addSubview(tableView)
        
        // ensure the keyboard disappears when click view
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)

        setConstraints()
    }
    
    func setConstraints() {
        self.tableView.autoPinEdgesToSuperviewEdges()
    }
    
    //MARK: - Events
    
    func closeButtonClick(sender: UIBarButtonItem) {
        
        presenter.didSelectClose()
    }
    
    func mergeButtonClick(sender: UIButton) {
        presenter.mergeWithTrapData()
    }
}

//MARK: - UITableView

extension SettingsView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == SECTION_USER {
            return "PROFILE"
        } else if section == SECTION_VERSIONS {
            return "VERSIONS"
        } else if section == SECTION_TESTING {
            return "TESTING"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == SECTION_USER {
            return "Your username is used when sending data to your controller"
        } else if section == SECTION_TESTING {
            return "This is for testing purposes only - probably wouldn't click it unless you know what you're doing"
        }
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SECTION_USER {
            return 1
        } else if section == SECTION_VERSIONS {
            return 2
        } else if section == SECTION_TESTING {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        
        if section == SECTION_USER && row == ROW_TRAPPER_NAME {
            return trapperNameTableViewCell
        } else if section == SECTION_VERSIONS {
            if row == ROW_APP_VERSION {
                return self.appVersionTableViewCell
            } else if indexPath.row == ROW_REALM_VERSION {
                return self.realmVersionTableViewCell
            }
        } else if indexPath.section == SECTION_TESTING && row == ROW_MERGE_TRAP_DATA {
            return self.mergeWithTrapDataTableViewCell
        }
        return UITableViewCell()
    }
}

//MARK: - UITextField
extension SettingsView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        presenter.didUpdateTrapperName(name: textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}


//MARK: - ProfileView API
extension SettingsView: SettingsViewApi {
    
    func setTitle(title: String?) {
        self.title = title
    }
    
    func displayTrapperName(name: String?) {
        trapperNameTextField.text = name
    }
    
    func setFocusToRouteName() {
        trapperNameTextField.becomeFirstResponder()
    }
    
    func displayAppVersion(version: String) {
        self.appVersionTableViewCell.detailTextLabel?.text = version
    }
    
    func displayRealmVersion(version: String) {
        self.realmVersionTableViewCell.detailTextLabel?.text = version
    }
}

// MARK: - ProfileView Viper Components API
private extension SettingsView {
    var presenter: SettingsPresenterApi {
        return _presenter as! SettingsPresenterApi
    }
    var displayData: SettingsDisplayData {
        return _displayData as! SettingsDisplayData
    }
}
