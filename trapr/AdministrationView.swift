//
//  AdministrationView.swift
//  trapr
//
//  Created by Andrew Tokeley on 22/10/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import UIKit
import Viperit

//MARK: AdministrationView Class
final class AdministrationView: UserInterface {
    
    //MARK: - Subviews
    
    lazy var productionAppWarning: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.red
        return label
    }()
    
    lazy var closeButton: UIBarButtonItem = {
        
        var view = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(closeButtonClick(sender:)))
        
        return view
    }()
    
    lazy var importButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.trpButtonEnabled
        button.setTitle("Import", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(importButtonClick(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var progressMessage: UITextView = {
        let view = UITextView()
        view.textColor = UIColor.trpTextDark
        view.backgroundColor = UIColor.clear
        view.font = UIFont.trpLabelNormal
        view.isEditable = false
        view.text = """
        Stations: 704 \n
        Traps: 2002 \n
        Trap Types: 5 \n
        """
        return view
    }()
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.trpBackground
        self.navigationItem.leftBarButtonItem = closeButton
        
        self.view.addSubview(importButton)
        self.view.addSubview(progressMessage)
        self.view.addSubview(productionAppWarning)
        
        self.setConstraints()
    }
    
    private func setConstraints() {

        productionAppWarning.autoPinEdge(toSuperviewEdge: .bottom, withInset: LayoutDimensions.spacingMargin)
        productionAppWarning.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.spacingMargin)
        productionAppWarning.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.spacingMargin)
        productionAppWarning.autoSetDimension(.height, toSize: LayoutDimensions.inputHeight)

        importButton.autoPinEdge(.bottom, to: .top, of: productionAppWarning, withOffset: -LayoutDimensions.spacingMargin)
        importButton.autoSetDimension(.height, toSize: LayoutDimensions.inputHeight)
        importButton.autoSetDimension(.width, toSize: 250)
        importButton.autoAlignAxis(toSuperviewAxis: .vertical)
        
        progressMessage.autoPin(toTopLayoutGuideOf: self, withInset: LayoutDimensions.spacingMargin)
        progressMessage.autoPinEdge(.bottom, to: .top, of: importButton, withOffset: -LayoutDimensions.spacingMargin)
        progressMessage.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.spacingMargin)
        progressMessage.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.spacingMargin)
        
    }
    
    //MARK - Event Handlers
    
    @objc func closeButtonClick(sender: UIBarButtonItem) {
        presenter.didSelectClose()
    }
    
    @objc func importButtonClick(sender: UIButton) {
        presenter.didSelectImport()
    }
}

//MARK: - AdministrationView API
extension AdministrationView: AdministrationViewApi {
    
    func showProductionWarning() {
        productionAppWarning.text = "WARNING: This app is pointing to production data!"
        importButton.backgroundColor = UIColor.red
    }
    
}

// MARK: - AdministrationView Viper Components API
private extension AdministrationView {
    var presenter: AdministrationPresenterApi {
        return _presenter as! AdministrationPresenterApi
    }
    var displayData: AdministrationDisplayData {
        return _displayData as! AdministrationDisplayData
    }
}
