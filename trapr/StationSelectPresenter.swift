//
//  StationSelectPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 3/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - StationSelectPresenter Class
final class StationSelectPresenter: Presenter {
    
    fileprivate var delegate: StationSelectDelegate?
    fileprivate var currentStation: Station?
    fileprivate var visitSummary: VisitSummary?
    
    override func viewIsAboutToAppear() {
        view.setTitle(title: "Stations")
    }
    
    override func setupView(data: Any) {
        if let setup = data as? StationSelectSetupData {
            self.currentStation = setup.currentStation
            self.visitSummary = setup.visitSummary
            self.delegate = setup.delegate
            if let station = setup.currentStation {
                if let summary = setup.visitSummary {
                    view.updateViewWithStation(currentStation: station, visitSummary: summary)
                }
            }
            else {
                // find the most relevant station to default to
                
            }
        }
    }
}

// MARK: - StationSelectPresenter API
//extension StationSelectPresenter: TraplineSelectDelegate {
//    
//    func didSelectTrapline(trapline: Trapline) {
////        if let station = trapline.stations.first {
////            view.updateViewWithStation(currentStation: station, visitSummary: visitSummary)
////        }
//    }
//}

// MARK: - StationSelectPresenter API
extension StationSelectPresenter: StationSelectPresenterApi {
    
//    func didRequestToSelectTrapline() {
//        let setupData = TraplineSelectSetupData(visitSummary: visitSummary!, currentTrapline: self.currentStation!.trapline!, delegate: self)
//        router.showTraplineSelectModule(setupData: setupData)
//    }
    
    func didSelectStation(station: Station) {
        self.delegate?.didSelectStation(station: station)
        _view.dismiss(animated: true, completion: nil)
    }
    
    func didSelectCloseButton() {
        _view.dismiss(animated: true, completion: nil)
    }
}

// MARK: - StationSelect Viper Components
private extension StationSelectPresenter {
    var view: StationSelectViewApi {
        return _view as! StationSelectViewApi
    }
    var interactor: StationSelectInteractorApi {
        return _interactor as! StationSelectInteractorApi
    }
    var router: StationSelectRouterApi {
        return _router as! StationSelectRouterApi
    }
}
