//
//  TraplineSelectRouter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 2/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - TraplineSelectRouter class
final class TraplineSelectRouter: Router {
    
    func showStationSelect(traplines: [Trapline]) {
        let module = AppModules.stationSelect.build()
        
        let setupData = StationSelectSetupData(traplines: traplines)
        setupData.stationSelectDelegate = presenter as? StationSelectDelegate
        setupData.allowMultiselect = true
        setupData.showAllStations = true
        
        module.router.show(from: _view, embedInNavController: false, setupData: setupData)
    }
}

// MARK: - TraplineSelectRouter API
extension TraplineSelectRouter: TraplineSelectRouterApi {
    
}

// MARK: - TraplineSelect Viper Components
private extension TraplineSelectRouter {
    var presenter: TraplineSelectPresenterApi {
        return _presenter as! TraplineSelectPresenterApi
    }
}
