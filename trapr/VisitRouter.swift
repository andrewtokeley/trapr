//
//  VisitRouter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 2/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit
import MessageUI

// MARK: - VisitRouter class
final class VisitRouter: Router {
    
}

// MARK: - VisitRouter API
extension VisitRouter: VisitRouterApi {
    
    func showMap(stations: [Station], highlightedStations: [Station]?) {
        let module = AppModules.map.build()
        
        let setupData = MapSetupData()
        setupData.stations = stations
        setupData.highlightedStations = highlightedStations
        
        module.router.show(from: _view, embedInNavController: true, setupData: setupData)
    }
    
    func showStationSelectModule(setupData: StationSelectSetupData) {
        let module = AppModules.stationSelect.build()
        module.router.show(from: _view, embedInNavController: true, setupData: setupData)
    }

    func showListPicker(setupData: ListPickerSetupData) {
        let module = AppModules.listPicker.build()
        module.router.show(from: _view, embedInNavController: setupData.embedInNavController, setupData: setupData)
    }
    
    func showDatePicker(setupData: DatePickerSetupData) {
        let module = AppModules.datePicker.build()
        module.router.showAsModalOverlay(from: _view, setupData: setupData)
    }
    
    func showEditRoute(setupData: TraplineSelectSetupData) {
        let module = AppModules.traplineSelect.build()
        module.router.show(from: _view, embedInNavController: true, setupData: setupData)
    }
    
    func addVisitLogToView() {
        let module = AppModules.visitLog.build()
        
        if let visitView = _view as? VisitViewApi {
            
            if let delegate = module.presenter as? VisitDelegate {
                
                // let the presenter know the VisitDelegate so it can tell the VisitLog about changes to the current visit
                presenter.setVisitDelegate(delegate: delegate)
                
                // tell delegates (VisitView only) of UI events like when the VisitLog View scrolls
                (module.view as? VisitLogView)?.delegate = _view as? VisitLogViewDelegate
                
                // tell delegate (VisitPresenter only) of other events - like when a user selects to remove a Visit
                (module.presenter as? VisitLogPresenter)?.delegate = presenter as? VisitLogDelegate
                
                module.router.addAsChildView(ofView: _view, insideContainer: visitView.getVisitContainerView)
            }
        }

    }
    
}

//extension VisitRouter:

// MARK: - Visit Viper Components
private extension VisitRouter {
    var presenter: VisitPresenterApi {
        return _presenter as! VisitPresenterApi
    }
}
