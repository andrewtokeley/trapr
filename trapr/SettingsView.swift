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

    let SECTION_EMAILS = 1
    let ROW_VISITS_EMAIL = 0
    let ROW_ORDERS_EMAIL = 1

    let SECTION_HIDDEN_ROUTES = 2
    let ROW_HIDDEN_ROUTES = 0
    
    let TEXTFIELD_TAG_NAME = 0
    let TEXTFIELD_TAG_VISIT_EMAIL = 1
    let TEXTFIELD_TAG_ORDER_EMAIL = 2
    
    //MARK: - Subviews
    
    lazy var closeButton: UIBarButtonItem = {
        
        var view = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(closeButtonClick(sender:)))
        
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    lazy var versionInfo: UILabel = {
        let label = UILabel()
        label.font = UIFont.trpLabelSmall
        label.textAlignment = .center
        label.tintColor = UIColor.darkGray
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(versionInfoClicked(sender:)))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    @objc func versionInfoClicked(sender: UITapGestureRecognizer) {
        presenter.didClickRealmLabel()
        
        let alert = UIAlertController(title: "Copied!", message: "Path to realm store has been copied to the clipboard.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    lazy var trapperNameTableViewCell: UITableViewCell = {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: self.TABLEVIEW_CELL_ID)
        
        let label = UILabel()
        label.text = "Your name"
        
        cell.contentView.addSubview(label)
        cell.contentView.addSubview(self.trapperNameTextField)
        
        cell.selectionStyle = .none
        
        label.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.spacingMargin)
        label.autoAlignAxis(toSuperviewAxis: .horizontal)
        label.autoSetDimension(.width, toSize: LayoutDimensions.tableViewLabelWidth * 1.5)
        
        self.trapperNameTextField.autoPinEdge(.left, to: .right, of: label, withOffset: LayoutDimensions.spacingMargin)
        self.trapperNameTextField.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.spacingMargin)
        self.trapperNameTextField.autoAlignAxis(toSuperviewAxis: .horizontal)
        self.trapperNameTextField.autoSetDimension(.height, toSize: LayoutDimensions.tableCellHeight)
        
        return cell
    }()
    
    lazy var trapperNameTextField: UITextField = {
        
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.textColor = UIColor.gray
        textField.textAlignment = .right
        textField.tag = self.TEXTFIELD_TAG_NAME
        textField.delegate = self
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:LayoutDimensions.textIndentMargin, height:LayoutDimensions.textIndentMargin))
        textField.leftViewMode = .always
        textField.leftView = spacerView
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = UIReturnKeyType.done
        return textField
    }()
    
    lazy var visitsEmailTableViewCell: UITableViewCell = {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: self.TABLEVIEW_CELL_ID)
        cell.selectionStyle = .none
        
        let label = UILabel()
        label.text = "Visits"
        
        cell.contentView.addSubview(label)
        cell.contentView.addSubview(self.visitsEmailTextField)
        
        label.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.spacingMargin)
        label.autoAlignAxis(toSuperviewAxis: .horizontal)
        label.autoSetDimension(.width, toSize: LayoutDimensions.tableViewLabelWidth)
        
        self.visitsEmailTextField.autoPinEdge(.left, to: .right, of: label, withOffset: LayoutDimensions.spacingMargin)
        self.visitsEmailTextField.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.spacingMargin)
        self.visitsEmailTextField.autoAlignAxis(toSuperviewAxis: .horizontal)
        self.visitsEmailTextField.autoSetDimension(.height, toSize: LayoutDimensions.tableCellHeight)
        
        return cell
    }()
    
    lazy var visitsEmailTextField: UITextField = {
        
        let textField = UITextField()
        textField.tag = self.TEXTFIELD_TAG_VISIT_EMAIL
        textField.placeholder = "Email address"
        textField.textColor = UIColor.gray
        textField.textAlignment = .right
        textField.delegate = self
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:LayoutDimensions.textIndentMargin, height:LayoutDimensions.textIndentMargin))
        textField.leftViewMode = .always
        textField.leftView = spacerView
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = UIReturnKeyType.done
        textField.keyboardType = UIKeyboardType.emailAddress
        return textField
    }()
    
    lazy var ordersEmailTableViewCell: UITableViewCell = {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: self.TABLEVIEW_CELL_ID)
        
        let label = UILabel()
        label.text = "Orders"
        
        cell.contentView.addSubview(label)
        cell.contentView.addSubview(self.ordersEmailTextField)
        
        label.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.spacingMargin)
        label.autoAlignAxis(toSuperviewAxis: .horizontal)
        label.autoSetDimension(.width, toSize: LayoutDimensions.tableViewLabelWidth)
        
        self.ordersEmailTextField.autoPinEdge(.left, to: .right, of: label, withOffset: LayoutDimensions.spacingMargin)
        self.ordersEmailTextField.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.spacingMargin)
        self.ordersEmailTextField.autoAlignAxis(toSuperviewAxis: .horizontal)
        self.ordersEmailTextField.autoSetDimension(.height, toSize: LayoutDimensions.tableCellHeight)
        
        return cell
    }()
    
    lazy var ordersEmailTextField: UITextField = {
        
        let textField = UITextField()
        textField.tag = self.TEXTFIELD_TAG_ORDER_EMAIL
        textField.placeholder = "Email address"
        textField.delegate = self
        textField.textAlignment = .right
        textField.textColor = UIColor.gray
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:LayoutDimensions.textIndentMargin, height:LayoutDimensions.textIndentMargin))
        textField.leftViewMode = .always
        textField.leftView = spacerView
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = UIReturnKeyType.done
        textField.keyboardType = UIKeyboardType.emailAddress
        return textField
    }()
    
    lazy var hiddenRoutesTableViewCell: UITableViewCell = {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: self.TABLEVIEW_CELL_ID)
        cell.textLabel?.text = "Show on Dashboard"
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        return cell
    }()

    
    // MARK: - UIViewController
    
    override func loadView() {
        
        super.loadView()
        
        self.view.backgroundColor = UIColor.trpBackground
        self.navigationItem.leftBarButtonItem = closeButton
        self.view.addSubview(tableView)
        self.view.addSubview(versionInfo)
        
        // ensure the keyboard disappears when click view
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)

        setConstraints()
    }
    
    func setConstraints() {
        self.tableView.autoPinEdge(toSuperviewEdge: .left)
        self.tableView.autoPinEdge(toSuperviewEdge: .right)
        self.tableView.autoPinEdge(toSuperviewEdge: .top)
        self.tableView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 100)
        
        self.versionInfo.autoPinEdges(toSuperviewMarginsExcludingEdge: .top)
        self.versionInfo.autoSetDimension(.height, toSize: LayoutDimensions.inputHeight)
    }
    
    //MARK: - Events
    
    @objc func closeButtonClick(sender: UIBarButtonItem) {
        
        presenter.didSelectClose()
    }
    
}

//MARK: - UITableView

extension SettingsView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_HIDDEN_ROUTES && indexPath.row == ROW_HIDDEN_ROUTES {
            presenter.didSelectHiddenRoutes()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == SECTION_USER {
            return "PROFILE"
        } else if section == SECTION_EMAILS {
            return "EMAIL"
        } else if section == SECTION_HIDDEN_ROUTES {
            return "ROUTES"
        }

        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == SECTION_USER {
            return "Your username is used when submitting your Visits"
        }
        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SECTION_USER {
            return 1
        } else if section == SECTION_EMAILS {
            return 2
        } else if section == SECTION_HIDDEN_ROUTES {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        
        if section == SECTION_USER {
            return trapperNameTableViewCell
        } else if section == SECTION_EMAILS {
            if row == ROW_VISITS_EMAIL {
                return visitsEmailTableViewCell
            } else if row == ROW_ORDERS_EMAIL {
                return ordersEmailTableViewCell
            }
        } else if section == SECTION_HIDDEN_ROUTES {
            return hiddenRoutesTableViewCell
        }
        return UITableViewCell()
    }
}

//MARK: - UITextField
extension SettingsView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let tag = textField.tag
        
        if tag == TEXTFIELD_TAG_NAME {
            presenter.didUpdateTrapperName(name: textField.text)
        } else if tag == TEXTFIELD_TAG_ORDER_EMAIL {
            presenter.didUpdateEmailOrdersRecipient(emailAddress: textField.text)
        } else if tag == TEXTFIELD_TAG_VISIT_EMAIL {
            presenter.didUpdateEmailVisitsRecipient(emailAddress: textField.text)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}


//MARK: - ProfileView API
extension SettingsView: SettingsViewApi {
    
//    func setTitle(title: String?) {
//        self.title = title
//    }
    
    func displayTrapperName(name: String?) {
        trapperNameTextField.text = name
    }
    
    func setFocusToRouteName() {
        trapperNameTextField.becomeFirstResponder()
    }
    
    func displayVersionNumbers(appVersion: String, realmVersion: String) {
        versionInfo.text = "App \(appVersion), Realm \(realmVersion)"
    }
    
    func displayEmailOrdersRecipient(emailAddress: String?) {
        self.ordersEmailTextField.text = emailAddress
    }
    
    func displayEmailVisitsRecipient(emailAddress: String?) {
        self.visitsEmailTextField.text = emailAddress
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
