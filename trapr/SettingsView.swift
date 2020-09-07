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
    
    let SECTION_ROUTES_TITLE = "Route"
    
    let TEXTFIELD_TAG_VISIT_EMAIL = 0
    
    lazy var sections: [StaticSection] = {
        return [
            StaticSection("Email", "This email address will be used as the recipient email for your visit reports.", [
                    StaticRow(visitsEmailTableViewCell)]
            ),
            StaticSection(SECTION_ROUTES_TITLE, [
                    StaticRow(hiddenRoutesTableViewCell)]
            )
        ]
    }()
    
    //MARK: - Subviews
    
    lazy var closeButton: UIBarButtonItem = {
        
        var view = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(closeButtonClick(sender:)))
        
        return view
    }()
    
    lazy var tableView: StaticTableView = {
        let tableView = StaticTableView(sections: self.sections)
        tableView.staticTableViewDelegate = self
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
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: self.TABLEVIEW_CELL_ID)
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
        
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: self.TABLEVIEW_CELL_ID)
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
        //self.view.addSubview(doSomethingButton)
        
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
        
        self.tableView.autoPinEdge(toSuperviewEdge: .left)
        self.tableView.autoPinEdge(toSuperviewEdge: .right)
        self.tableView.autoPinEdge(toSuperviewEdge: .top)
        self.tableView.autoPinEdge(.bottom, to: .top, of: versionInfo, withOffset: -LayoutDimensions.spacingMargin)
    }
    
    //MARK: - Events
    
    @objc func closeButtonClick(sender: UIBarButtonItem) {
        presenter.didSelectClose()
    }
    
}

//MARK: - UITableView

extension SettingsView: StaticTableViewDelegate {

    func tableView(_ tableView: StaticTableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.row(indexPath).cell == hiddenRoutesTableViewCell {
            self.presenter.didSelectHiddenRoutes()
        }
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
    
    func displayVersionNumber(version: String) {
        versionInfo.text = "Version \(version)"
    }
    
    func displayEmailVisitsRecipient(emailAddress: String?) {
        self.visitsEmailTextField.text = emailAddress
    }
    
    func enableHideRoutes(enable: Bool) {
        
        tableView.section(by: SECTION_ROUTES_TITLE)?.isVisible = enable
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
