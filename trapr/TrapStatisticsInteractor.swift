//
//  TrapStatisticsInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley on 14/07/20.
//Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - TrapStatisticsInteractor Class
final class TrapStatisticsInteractor: Interactor {
    
    fileprivate lazy var trapStatisticsService = { ServiceFactory.sharedInstance.trapStatisticsService }()
}

// MARK: - TrapStatisticsInteractor API
extension TrapStatisticsInteractor: TrapStatisticsInteractorApi {
    
    func fetchTrapStatistics(routeId: String, stationId: String, trapTypeId: String, completion: ((TrapStatistics?, Error?) -> Void)?) {
        
        trapStatisticsService.getTrapStatistics(routeId: routeId, stationId: stationId, trapTypeId: trapTypeId) { (trapStatistics, error) in
            if let error = error {
                completion?(nil, error)
            } else {
                completion?(trapStatistics, nil)
            }
        }
    }
}

// MARK: - Interactor Viper Components Api
private extension TrapStatisticsInteractor {
    var presenter: TrapStatisticsPresenterApi {
        return _presenter as! TrapStatisticsPresenterApi
    }
}
