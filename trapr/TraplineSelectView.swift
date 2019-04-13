//
//  TraplineSelectView.swift
//  trapr
//
//  Created by Andrew Tokeley  on 2/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import UIKit
import Viperit

//MARK: TraplineSelectView Class
final class TraplineSelectView: UserInterface {
    
    fileprivate var traplines: [Trapline]!
    fileprivate var selectedTraplines: [Trapline]?
    
    fileprivate var TABLEVIEW_CELL_ID = "cell"
    fileprivate var NEXT_BUTTON_TEXT = "Next"
    
    fileprivate var SELECTED_TRAPLINES_HEADER_TEXT = "ROUTE TRAPLINES"
    fileprivate var ALL_TRAPLINES_HEADER_TEXT = "TRAPLINES"
    fileprivate var SELECTED_TRAPLINES_FOOTER_TEXT = "Select which traplines are included in the Route. You will be able to select specifc stations in the next step."

    //MARK: - Events
    
    @objc func nextButtonClick(sender: UIBarButtonItem) {
        presenter.didSelectNext()
    }
    
    @objc func closeButtonClick(sender: UIBarButtonItem) {
        presenter.didSelectClose()
    }
    
    // MARK: - Subviews
    
    lazy var routeNameTextField: UITextField = {
        let field = UITextField()
        field.font = UIFont.trpLabelNormal
        field.backgroundColor = UIColor.white
        
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:LayoutDimensions.textIndentMargin, height:LayoutDimensions.textIndentMargin))
        field.leftViewMode = .always
        field.leftView = spacerView

        field.delegate = self
        
        return field
    }()
    
    lazy var nextButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: self.NEXT_BUTTON_TEXT, style: .plain, target: self, action: #selector(nextButtonClick(sender:)))
        
        button.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.trpNavigationBarTint], for: .normal)
        button.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.trpNavigationBarTintDisabled], for: .disabled)
        
        return button
    }()
    
    lazy var closeButton: UIBarButtonItem = {

        let button = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(closeButtonClick(sender:)))
        return button
    }()
    
    lazy var selectedTraplinesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.trpTableViewSectionHeading
        label.textColor = UIColor.trpTextDark
        label.text = self.SELECTED_TRAPLINES_HEADER_TEXT
        return label
    }()

    lazy var selectedTraplinesView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.addSubview(self.selectedTraplinesText)
        
        return view
    }()
    
    lazy var selectedTraplinesText: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.white
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.font = UIFont.trpLabelNormal
        
        return label
    }()
    
    lazy var selectedTraplinesFooterText: UILabel = {
        let label = UILabel()
        label.text = self.SELECTED_TRAPLINES_FOOTER_TEXT
        label.numberOfLines = 0
        label.font = UIFont.trpTableViewSectionHeading
        label.textColor = UIColor.trpTextDark
        return label
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundView = nil
        tableView.backgroundColor = UIColor.trpBackground
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.TABLEVIEW_CELL_ID)
        
        return tableView
    }()
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.trpBackground
        self.view.addSubview(routeNameTextField)
        self.view.addSubview(selectedTraplinesLabel)
        self.view.addSubview(selectedTraplinesView)
        self.view.addSubview(selectedTraplinesFooterText)
        self.view.addSubview(tableView)
        
        self.navigationItem.rightBarButtonItem = self.nextButton
        setConstraints()
        
    }
        
    func setConstraints() {
        
        self.routeNameTextField.autoPin(toTopLayoutGuideOf: self, withInset: LayoutDimensions.spacingMargin)
        self.routeNameTextField.autoPinEdge(toSuperviewEdge: .left)
        self.routeNameTextField.autoPinEdge(toSuperviewEdge: .right)
        self.routeNameTextField.autoSetDimension(.height, toSize: LayoutDimensions.inputHeight)
        
        self.selectedTraplinesLabel.autoPinEdge(.top, to: .bottom, of: self.routeNameTextField, withOffset: LayoutDimensions.spacingMargin)
        self.selectedTraplinesLabel.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.textIndentMargin)
        
        self.selectedTraplinesView.autoPinEdge(.top, to: .bottom, of: self.selectedTraplinesLabel, withOffset: LayoutDimensions.spacingMargin / 2)
        self.selectedTraplinesView.autoPinEdge(toSuperviewEdge: .left)
        self.selectedTraplinesView.autoPinEdge(toSuperviewEdge: .right)
        self.selectedTraplinesView.autoSetDimension(.height, toSize: LayoutDimensions.inputHeight)
        
        self.selectedTraplinesText.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.init(top: 0, left: LayoutDimensions.textIndentMargin, bottom: 0, right: 0), excludingEdge: .right)
        
        self.selectedTraplinesFooterText.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.textIndentMargin)
        self.selectedTraplinesFooterText.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.textIndentMargin)
        self.selectedTraplinesFooterText.autoPinEdge(.top, to: .bottom, of: self.selectedTraplinesView, withOffset: LayoutDimensions.textIndentMargin)
        
        self.tableView.autoPinEdge(.top, to: .bottom, of: self.selectedTraplinesFooterText, withOffset: LayoutDimensions.spacingMargin)
        self.tableView.autoPinEdge(toSuperviewEdge: .left)
        self.tableView.autoPinEdge(toSuperviewEdge: .right)
        self.tableView.autoPinEdge(toSuperviewEdge: .bottom)
    }

}

//MARK: - TextField
extension TraplineSelectView: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        presenter.didChangeRouteName(name: textField.text)
    }
    
}

//MARK: - TableView
extension TraplineSelectView: UITableViewDelegate, UITableViewDataSource {
    //MARK: UITableview
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return traplines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TABLEVIEW_CELL_ID, for: indexPath)
        let trapline = traplines[indexPath.row]
        cell.textLabel?.text = trapline.code
        cell.selectionStyle = .none
        
        // decide whether it's selected or not
        if selectedTraplines?.contains(trapline) ?? false {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
            presenter.didDeselectTrapline(trapline: self.traplines[indexPath.row])
        } else {
            cell?.accessoryType = .checkmark
            presenter.didSelectTrapline(trapline: self.traplines[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.ALL_TRAPLINES_HEADER_TEXT
    }
}

//MARK: - TraplineSelectView API
extension TraplineSelectView: TraplineSelectViewApi {
    
    func setRouteNamePlaceholderText(text: String) {
        self.routeNameTextField.placeholder = text
    }
    
//    func setTitle(title: String) {
//        self.title = title
//    }
    
    func setRouteName(name: String?) {
        self.routeNameTextField.text = name
    }
    
    func setSelectedTraplinesDescription(description: String) {
        self.selectedTraplinesText.text = description
    }
    
    func updateDisplay(traplines: [Trapline], selected: [Trapline]?) {
        self.traplines = traplines
        self.selectedTraplines = selected
        self.tableView.reloadData()
    }
    
    func setNextButtonState(enabled: Bool) {
        self.nextButton.isEnabled = enabled
    }
    
    func showCloseButton(show: Bool) {
        self.navigationItem.leftBarButtonItem = show ? closeButton : nil
    }
}

// MARK: - TraplineSelectView Viper Components API
private extension TraplineSelectView {
    var presenter: TraplineSelectPresenterApi {
        return _presenter as! TraplineSelectPresenterApi
    }
    var displayData: TraplineSelectDisplayData {
        return _displayData as! TraplineSelectDisplayData
    }
}
