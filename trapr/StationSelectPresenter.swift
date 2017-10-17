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
    
    fileprivate var newVisitDelegate: NewVisitDelegate?
    fileprivate var stationSelectDelegate: StationSelectDelegate?
    fileprivate var selectedStations: [Station]!
    
    fileprivate var currentStation: Station?
    fileprivate var visitSummary: VisitSummary?
    fileprivate var allowMultiselect: Bool = false
    
    override func viewIsAboutToAppear() {
        view.setTitle(title: "Stations")
        
        view.setDoneButtonAttributes(visible: allowMultiselect, enabled: false)
        
        if !allowMultiselect {
            view.showCloseButton()
        }
    }
    
    override func setupView(data: Any) {
        if let setup = data as? StationSelectSetupData {
            
            self.newVisitDelegate = setup.newVisitDelegate
            self.stationSelectDelegate = setup.stationSelectDelegate
            
            self.allowMultiselect = setup.allowMultiselect
            self.selectedStations = setup.selectedStations ?? [Station]()
            
            view.initialiseView(traplines: setup.traplines, selectedStations: setup.selectedStations, showAllStations: setup.showAllStations, allowMultiselect: setup.allowMultiselect)
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
        if allowMultiselect {
            self.selectedStations.append(station)
            view.setDoneButtonAttributes(visible: true, enabled: true)
        } else {
            self.stationSelectDelegate?.didSelectStations(stations: [station])
            _view.dismiss(animated: true, completion: nil)
        }
    }
    
    func didDeselectStation(station: Station) {
        if let index = self.selectedStations.index(of: station) {
            self.selectedStations.remove(at: index)
        }
        view.setDoneButtonAttributes(visible: self.allowMultiselect, enabled: self.selectedStations.count > 0)
    }
    
    func didSelectCloseButton() {
        _view.dismiss(animated: true, completion: nil)
    }
    
    func didSelectDone() {
        
        self.stationSelectDelegate?.didSelectStations(stations: self.selectedStations)
        
        // close the StationSelect module
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
