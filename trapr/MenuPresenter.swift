//
//  MenuPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 12/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

class MenuPresenter {
    
    var router: MenuWireframe?
    
    func didSelectClose() {
        router?.dismissView()
    }
}
