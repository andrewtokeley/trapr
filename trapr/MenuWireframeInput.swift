//
//  MenuWireframeInput.swift
//  trapr
//
//  Created by Andrew Tokeley  on 6/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

protocol MenuWireframeInput {

    func presentView(over viewController: UIViewController)
    
    func dismissView()
    func dismissView(navigateTo menuItem: MenuItem)
    
}
