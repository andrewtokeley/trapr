//
//  UIViewControllerExtension.swift
//  trapr
//
//  Created by Andrew Tokeley on 17/01/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func embed(childViewController: UIViewController) {
        childViewController.willMove(toParentViewController: self)
        
        view.addSubview(childViewController.view)
        childViewController.view.frame = view.bounds
        childViewController.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        addChildViewController(childViewController)
    }


    func unembed(childViewController: UIViewController) {
        assert(childViewController.parent == self)
        
        childViewController.willMove(toParentViewController: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParentViewController()
    }
}
