//
//  SettingsWireframe.swift
//  trapr
//
//  Created by Andrew Tokeley  on 25/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class SettingsWireframe: SettingsWireframeInput {
    
    var presentingViewController: UIViewController?
    var view: SettingsViewController!
    
    init() {
        self.view = self.assembleModule() as! SettingsViewController
    }
    
    private func assembleModule() -> SettingsViewInterface {
        
        view = SettingsViewController(nibName: "SettingsViewController", bundle: nil)
        view.presenter = SettingsPresenter()
        view.presenter?.view = view
        view.presenter?.router = self
        return view
    }
    
    func presentView(from viewController: UIViewController) {
    
        self.presentingViewController = viewController
        
        // present settings view (inside it's own navigationcontroller) modally
        let navigationController = UINavigationController(rootViewController: view)
        viewController.navigationController?.present(navigationController, animated: true, completion: nil)
    }
    
    func dismissView() {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
