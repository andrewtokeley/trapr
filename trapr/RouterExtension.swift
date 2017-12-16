//
//  RouterExtension.swift
//  trapr
//
//  Created by Andrew Tokeley  on 3/11/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

extension Router {
    func showAsModalOverlay(from: UIViewController, setupData: Any? = nil) {
        
        //if let data = setupData {
            _presenter.setupView(data: setupData)
        //}
        
        _view.modalTransitionStyle = .crossDissolve
        _view.modalPresentationStyle = .overCurrentContext
        
        let view = self._view
        
        // Need to call .present on a different thread - some bug which causes random delays in presenting view if you are responding to a didSelectRow event in UITableView :-(
        DispatchQueue.main.async {
            from.present(view!, animated: false, completion: nil)
        }
        
    }
}
