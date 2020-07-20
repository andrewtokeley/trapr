//
//  TrapStatisticsPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley on 14/07/20.
//Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - TrapStatisticsPresenter Class
final class TrapStatisticsPresenter: Presenter {
}

extension TrapStatisticsPresenter: VisitDelegate {
    
    func didChangeVisit(routeId: String, stationId: String, trapTypeId: String, hasCatchData: Bool, visit: VisitEx?) {

        // get the stats, not we aren't using visit for this as it may be nil
        interactor.fetchTrapStatistics(routeId: routeId, stationId: stationId, trapTypeId: trapTypeId) { (statistics, error) in
            if let statistics = statistics {
                self.view.displayStatistics(statistics: statistics, showCatchStats: hasCatchData)
            }
        }
    }
}

// MARK: - TrapStatisticsPresenter API
extension TrapStatisticsPresenter: TrapStatisticsPresenterApi {
}

// MARK: - TrapStatistics Viper Components
private extension TrapStatisticsPresenter {
    var view: TrapStatisticsViewApi {
        return _view as! TrapStatisticsViewApi
    }
    var interactor: TrapStatisticsInteractorApi {
        return _interactor as! TrapStatisticsInteractorApi
    }
    var router: TrapStatisticsRouterApi {
        return _router as! TrapStatisticsRouterApi
    }
}
