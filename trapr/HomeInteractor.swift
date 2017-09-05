//
//  HomeInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation

class HomeInteractor: HomeInteractorInput {
    
    var presenter: HomeInteractorOutput?
    
    //MARK: - HomeInteractorInput
    
    func initialiseHomeModule() {
        presenter?.setRecentVisits()
    }
}
