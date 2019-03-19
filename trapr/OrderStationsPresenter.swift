//
//  OrderStationsPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley on 31/01/19.
//Copyright © 2019 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - OrderStationsPresenter Class
final class OrderStationsPresenter: Presenter {
    
    fileprivate var routeId: String?
    fileprivate var viewModel: StationViewModel?
    
    override func setupView(data: Any) {
        
        _view.setTitle(title: "Stations")
        if let data = data as? OrderStationsSetupData {
            if let stations = data.stations {
                
                routeId = data.routeId
                
                viewModel = StationViewModel(stationNames: stations.map( { $0.longCode }) )
                view.updateViewModel(viewModel: viewModel!)
            } else {
                fatalError()
            }
        }
    }
}

// MARK: - OrderStationsPresenter API
extension OrderStationsPresenter: OrderStationsPresenterApi {
    
    func didMoveStation(sourceIndex: Int, destinationIndex: Int) {
        if let routeId = routeId {
            interactor.moveStation(routeId: routeId, sourceIndex: sourceIndex, destinationIndex: destinationIndex) { (stationNames) in
                    self.viewModel?.stationNames = stationNames
                    self.view.updateViewModel(viewModel: self.viewModel!)
            }
        }
    }
    
    func didSelectDone() {
        
    }
    
}

// MARK: - OrderStations Viper Components
private extension OrderStationsPresenter {
    var view: OrderStationsViewApi {
        return _view as! OrderStationsViewApi
    }
    var interactor: OrderStationsInteractorApi {
        return _interactor as! OrderStationsInteractorApi
    }
    var router: OrderStationsRouterApi {
        return _router as! OrderStationsRouterApi
    }
}
