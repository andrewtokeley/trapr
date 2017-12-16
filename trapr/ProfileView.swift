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
final class ProfileView: UserInterface {
    
    let TABLEVIEW_CELL_ID = "cell"
    let ROW_TRAPPER_NAME = 0
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
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
    
    // MARK: - UIViewController
    
    override func loadView() {
        
        super.loadView()
        
        self.view.backgroundColor = UIColor.trpBackground
        self.navigationItem.leftBarButtonItem = closeButton
        self.view.addSubview(tableView)
        setConstraints()
    }
    
    func setConstraints() {
        self.tableView.autoPinEdgesToSuperviewEdges()
    }
    
    //MARK: - Events
    
    func closeButtonClick(sender: UIBarButtonItem) {
        presenter.didSelectClose()
    }
}

//MARK: - UITableView

extension ProfileView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "PROFILE"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "Enter your name or nickname"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // just trapper name for now
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == ROW_TRAPPER_NAME {
            return trapperNameTableViewCell
        }
        return UITableViewCell()
    }
}

//MARK: - UITextField
extension ProfileView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        presenter.didUpdateTrapperName(name: textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}


//MARK: - ProfileView API
extension ProfileView: ProfileViewApi {
    
    func setTitle(title: String?) {
        self.title = title
    }
    
    func displayTrapperName(name: String) {
        trapperNameTextField.text = name
    }
    
    func setFocusToRouteName() {
        trapperNameTextField.becomeFirstResponder()
    }
}

// MARK: - ProfileView Viper Components API
private extension ProfileView {
    var presenter: ProfilePresenterApi {
        return _presenter as! ProfilePresenterApi
    }
    var displayData: ProfileDisplayData {
        return _displayData as! ProfileDisplayData
    }
}
