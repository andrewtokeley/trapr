//
//  MenuRouter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 6/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class MenuWireframe: MenuWireframeInput {
    
    var presentingViewController: UIViewController!
    var view: MenuView!
    
    init() {
        self.view = self.assembleModule() as MenuView
    }
    
    private func assembleModule() -> MenuView {
        
        view = MenuView()
        //view.presenter = HomePresenter()
        //view.presenter?.view = view
        //view.presenter?.router = self
        
        //visitWireframe = VisitWireframe()
        
        return view
    }
    
    func presentView(over viewController: UIViewController) {
        
        presentingViewController = viewController
        
        view.frame = CGRect(x: 0, y: 0, width: 150, height: viewController.view.bounds.height)
        view.backgroundColor = UIColor.white
        viewController.view.addSubview(view)
        
    }
    
    func dismissView() {
        view.removeFromSuperview()
    }
}
