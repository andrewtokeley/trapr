//
//  TraplineSelectInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley  on 2/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - TraplineSelectInteractor Class
final class TraplineSelectInteractor: Interactor {
}

// MARK: - TraplineSelectInteractor API
extension TraplineSelectInteractor: TraplineSelectInteractorApi {
    
    func getRecentTraplines() -> [Trapline]? {
        return ServiceFactory.sharedInstance.traplineService.getRecentTraplines()
    }
    
    func getAllTraplines() -> [Trapline]? {
        return ServiceFactory.sharedInstance.traplineService.getTraplines()
    }
}

// MARK: - Interactor Viper Components Api
private extension TraplineSelectInteractor {
    var presenter: TraplineSelectPresenterApi {
        return _presenter as! TraplineSelectPresenterApi
    }
}
