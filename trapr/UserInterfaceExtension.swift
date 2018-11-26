//
//  UserInterfaceExtension.swift
//  trapr
//
//  Created by Andrew Tokeley on 6/01/18.
//  Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

extension UserInterface {
    
    func setTitle(title: String?) {
        self.title = title
    }
    
    func presentConfirmation(title: String = "Are you sure?", message: String? = nil, response: ((Bool) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in response?(true) })
        let no = UIAlertAction(title: "No", style: .default, handler: { (action) in response?(false) })
        
        alert.addAction(yes)
        alert.addAction(no)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentMessage(title: String, message: String? = nil, response: ((Bool) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) in response?(true) })
        
        alert.addAction(ok)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func displayMenuOptions(options: [OptionItem], actionHandler: ((String) -> Void)?) {
        let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for option in options {
            let action = UIAlertAction(title: option.title, style: option.isDestructive ? .destructive : .default, handler: {
                (action) in
                
                actionHandler?(action.title!)
                //self.presenter.didSelectMenuItem(title: action.title!)
            })
            action.isEnabled = option.isEnabled
            //action.
            menu.addAction(action)
        }
        
        // always add a cancel
        menu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(menu, animated: true, completion: nil)
    }
}
