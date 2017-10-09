//
//  StationSelectInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley  on 3/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - StationSelectInteractor Class
final class StationSelectInteractor: Interactor {
}

// MARK: - StationSelectInteractor API
extension StationSelectInteractor: StationSelectInteractorApi {
    
    func getDefaultStation() -> Station {
    
        // TODO: change so that it defaults to the first station of the last trapline visited
        
        // Assumes there are traplines loaded into the app and the first one returned has at least one station - fair assumption, but WARNING!
        let traplines = ServiceFactory.sharedInstance.traplineService.getTraplines()
        return traplines!.first!.stations.first!
    }
}

// MARK: - Interactor Viper Components Api
private extension StationSelectInteractor {
    var presenter: StationSelectPresenterApi {
        return _presenter as! StationSelectPresenterApi
    }
}
