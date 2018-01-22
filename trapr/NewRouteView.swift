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
    
    lazy var routeNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name of your route..."
        textField.delegate = self
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:LayoutDimensions.textIndentMargin, height:LayoutDimensions.textIndentMargin))
        textField.leftViewMode = .always
        textField.leftView = spacerView
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = UIReturnKeyType.done
        return textField
    }()
    
    lazy var cancelButton: UIBarButtonItem = {
        var view = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonClick(sender:)))
        return view
    }()
    
    lazy var nextButton: UIBarButtonItem = {
        var view = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonClick(sender:)))
        return view
    }()
    
    // MARK: - Events
    
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
        
        view.addSubview(routeNameTextField)
        
        setConstraints()
    }
    
    private func setConstraints() {
    
        routeNameTextField.autoPin(toTopLayoutGuideOf: self, withInset: LayoutDimensions.spacingMargin)
        routeNameTextField.autoPinEdge(toSuperviewEdge: .left)
        routeNameTextField.autoPinEdge(toSuperviewEdge: .right)
        routeNameTextField.autoSetDimension(.height, toSize: LayoutDimensions.inputHeight)
    }
    
    
}
//MARK: - UITextFieldDelegate

extension NewRouteView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        presenter.didUpdateRouteName(name: textField.text)
    }
    
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
