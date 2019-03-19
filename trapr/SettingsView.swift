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
    
    /// Hide initially and only show if the presenter tells you to
    var showHideRoutes = false
    
    let TABLEVIEW_CELL_ID = "cell"
    
    let SECTION_EMAILS = 0
    let ROW_VISITS_EMAIL = 0
    
    let SECTION_HIDDEN_ROUTES = 1
    let ROW_HIDDEN_ROUTES = 0
    
    let TEXTFIELD_TAG_VISIT_EMAIL = 0
    
    //MARK: - Subviews
    
    lazy var doSomethingButton: UIButton = {
        
        let button = UIButton()
        button.backgroundColor = UIColor.trpButtonEnabled
        button.setTitle("Refresh Cache", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(doSomethingClick(sender:)), for: .touchUpInside)
        return button

    }()
    
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
        label.numberOfLines = 0
        
        return label
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
        self.view.addSubview(doSomethingButton)
        
        // ensure the keyboard disappears when click view
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)

        setConstraints()
    }
    
    func setConstraints() {
        
        self.versionInfo.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.spacingMargin)
        self.versionInfo.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.spacingMargin)
        self.versionInfo.autoPinEdge(toSuperviewEdge: .bottom, withInset: LayoutDimensions.spacingMargin)
        self.versionInfo.autoSetDimension(.height, toSize: LayoutDimensions.inputHeight)
        
        self.doSomethingButton.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.spacingMargin)
        self.doSomethingButton.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.spacingMargin)
        self.doSomethingButton.autoPinEdge(.bottom, to: .top, of: versionInfo, withOffset: -LayoutDimensions.spacingMargin)
        self.doSomethingButton.autoSetDimension(.height, toSize: LayoutDimensions.tableCellHeight)
        
        self.tableView.autoPinEdge(toSuperviewEdge: .left)
        self.tableView.autoPinEdge(toSuperviewEdge: .right)
        self.tableView.autoPinEdge(toSuperviewEdge: .top)
        self.tableView.autoPinEdge(.bottom, to: .top, of: doSomethingButton, withOffset: -LayoutDimensions.spacingMargin)
    }
    
    //MARK: - Events
    
//    @objc func firestoreSyncButtonClick(sender: UIBarButtonItem) {
//        presenter.didSelectFirestoreSync()
//    }
//
    @objc func closeButtonClick(sender: UIBarButtonItem) {
        
        presenter.didSelectClose()
    }
    
    @objc func doSomethingClick(sender: UIButton) {
        presenter.didClickDoSomething()
    }
    
}

//MARK: - UITableView

extension SettingsView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == SECTION_EMAILS {
            return "This email address will be used as the recipient email for your visit reports."
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == SECTION_HIDDEN_ROUTES && indexPath.row == ROW_HIDDEN_ROUTES {
            presenter.didSelectHiddenRoutes()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == SECTION_EMAILS {
            return "EMAIL"
        } else if section == SECTION_HIDDEN_ROUTES {
            return "ROUTES"
        }

        return nil
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.showHideRoutes {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == SECTION_EMAILS {
            return 1
        } else if section == SECTION_HIDDEN_ROUTES {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        
        if section == SECTION_EMAILS {
            if row == ROW_VISITS_EMAIL {
                return visitsEmailTableViewCell
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
        if tag == TEXTFIELD_TAG_VISIT_EMAIL {
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
    
    //func setFirestoreSyncProgress(message: String, progress: Double) {
//        if progress > 0 && progress < 100 {
//            firestoreSyncProgressBar.alpha = 1
//            firestoreSyncProgressBar.setProgress(Float(progress), animated: true)
//        } else {
//            firestoreSyncProgressBar.alpha = 0
//        }
        
    //}
    
//    func displayTrapperName(name: String?) {
//        trapperNameTextField.text = name
//    }
    
//    func setFocusToRouteName() {
//        trapperNameTextField.becomeFirstResponder()
//    }
    
    func displayDoSomethingProgress(message: String) {
        self.doSomethingButton.setTitle(message, for: .normal)
    }
    
    func displayVersionNumber(version: String) {
        versionInfo.text = "Version \(version)"
    }
    
//    func displayEmailOrdersRecipient(emailAddress: String?) {
//        self.ordersEmailTextField.text = emailAddress
//    }
    
    func displayEmailVisitsRecipient(emailAddress: String?) {
        self.visitsEmailTextField.text = emailAddress
    }
    
    func enableHideRoutes(enable: Bool) {
        self.showHideRoutes = enable
        self.tableView.reloadData()
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
