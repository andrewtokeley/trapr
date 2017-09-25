//
//  MenuRouter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 6/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class MenuWireframe: NSObject, MenuWireframeInput {
    
    var presentingViewController: UIViewController!
    var view: MenuView!
    var settingsWireframe: SettingsWireframe!
    
    override init() {
        super.init()
        self.view = self.assembleModule() as MenuView
    }
    
    private func assembleModule() -> MenuView {
        
        //Get all views in the xib
        let view = Bundle.main.loadNibNamed("Menu", owner: self, options: nil)?.first as! MenuView
        
        //Set wanted position and size (frame)
        
        view.presenter = MenuPresenter()
        view.presenter?.router = self
        
        settingsWireframe = SettingsWireframe()
        
        //view.presenter?.view = view
        //view.presenter?.router = self
        
        //visitWireframe = VisitWireframe()
        
        return view
    }
    
    func presentView(over viewController: UIViewController) {
        
        presentingViewController = viewController
        
        // Offset off the screen initially
        view.frame = viewController.view.frame.offsetBy(dx: -viewController.view.frame.width, dy: 0)
        view.background.alpha = 0
        
        viewController.navigationController?.view.addSubview(view)
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            
            self.view.frame = viewController.view.frame
            
        }, completion: { (finished) in
            UIView.animate(withDuration: 0.0, animations: {
                
                self.view.background.alpha = 0.5
                
            }, completion: nil)
        })
        
    }
    
    func dismissView() {
        dismissView(completion: nil)
    }

    func dismissView(navigateTo menuItem: MenuItem) {
        
        switch (menuItem) {
            case .Home:
                dismissView()
            case .Map:
                dismissView()
            case .Sync:
                dismissView()
            case .Settings:
                dismissView(completion: { (flag) in self.settingsWireframe.presentView(from: self.presentingViewController) })
                break
        }
    
    }
    
    private func dismissView(completion: ((Bool) -> Void)?) {
        
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            
            self.view.frame = self.presentingViewController.view.frame.offsetBy(dx: -self.presentingViewController.view.frame.width, dy: 0)
            
        }, completion: { (finished) in
            UIView.animate(withDuration: 0.0, animations: {
                
                self.view.removeFromSuperview()
                
            }, completion: completion)
        })
        
        
    }
}
