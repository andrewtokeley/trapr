//
//  HomeWireframe.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class VisitWireframe: VisitWireframeInput {
    
    var view: VisitViewController!
    var presenter: VisitPresenter!
    var presentingViewController: UIViewController?
    
    //MARK: - Initialisation
    
    init() {
        self.view = self.assembleModule() as! VisitViewController
    }
    
    private func assembleModule() -> VisitViewInterface {
        
        view = VisitViewController(nibName: "VisitView", bundle: nil)
        
        view.presenter = VisitPresenter()
        view.presenter?.view = view
        
        let interactor = VisitInteractor()
        interactor.presenter = view.presenter
        
        view.presenter?.interactor = interactor
        
        return view
    }
    
    /**
     Present the visit view on current navigation stack
     */
    func presentView(from viewController: UIViewController, visitSummary: VisitSummary) {
        
        self.presentingViewController = viewController
        
        view.presenter?.visitSummary = visitSummary
        
        // Clear out the default back button text to leave only the <
        let backItem = UIBarButtonItem()
        backItem.title = ""
        viewController.navigationItem.backBarButtonItem = backItem
        
        viewController.navigationController?.pushViewController(view, animated: true)
    }
    
    func backButtonClicked(sender: UIBarButtonItem) {
        
    }


}
