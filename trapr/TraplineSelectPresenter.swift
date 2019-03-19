//
//  TraplineSelectPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 2/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - TraplineSelectPresenter Class
final class TraplineSelectPresenter: Presenter {
    
    fileprivate var delegate: TraplineSelectDelegate?
    
    fileprivate var route: Route?
    fileprivate var routeName: String?
    fileprivate var selectedTraplines = [Trapline]()
    fileprivate var selectedTraplinesText: String {
        return selectedTraplines.map({ (trapline) -> String in return trapline.code }).joined(separator: ", ")
    }
    
    private let TITLE = "New Route"
    private let DELIMMTER = ", "
    private let ROUTE_NAME = "Route name"
    
    override func viewHasLoaded() {
        
        _view.setTitle(title: route?.name ?? TITLE)
        view.setRouteName(name: route?.name)
        view.setRouteNamePlaceholderText(text: ROUTE_NAME)
        
        view.setSelectedTraplinesDescription(description: "")
        
        interactor.getAllTraplines { (traplines) in
            if let _ = self.route {
                self.selectedTraplines.removeAll()
                //self.selectedTraplines.append(route.traplines)
                //self.view.setSelectedTraplinesDescription(description: route?.name)
            }
            self.view.updateDisplay(traplines: traplines, selected: self.selectedTraplines)
            self.view.setNextButtonState(enabled: self.selectedTraplines.count > 0)
        }
    }
    
    override func setupView(data: Any) {
        if let data = data as? TraplineSelectSetupData {
            self.delegate = data.delegate
            self.route = data.route
            
            view.showCloseButton(show: data.presentingAsModal)
                //self.selectedTraplines = data.route?.traplines ?? [Trapline]()
        }
    }
}

//MARK: - StationSelectDelegate
extension TraplineSelectPresenter: StationSelectDelegate {
    
    func newStationsSelected(stations: [Station]) {
        
        if let _ = route {
            // we have a Route so need to update the stations on it
            interactor.updateStations(routeId: route!.id!, stationIds: stations.map({$0.id!}))
            self.delegate?.didUpdateRoute(route: route!)
            
        } else {
            
            // create a new route
            if let route = try? Route(name: self.routeName!, stationIds: stations.map({$0.id!})) {
                self.interactor.addRoute(route: route)
            
                self.delegate?.didCreateRoute(route: route)
            }
            // close view
            _view.navigationController?.popViewController(animated: true)
        }
    }
    
}

// MARK: - TraplineSelectPresenter API
extension TraplineSelectPresenter: TraplineSelectPresenterApi {
    
    func didChangeRouteName(name: String?) {
        self.routeName = name
    }
    
    func didSelectTrapline(trapline: Trapline) {
        self.selectedTraplines.append(trapline)
        view.setSelectedTraplinesDescription(description: selectedTraplinesText)
        view.setNextButtonState(enabled: true)
    }
    
    func didDeselectTrapline(trapline: Trapline) {
        if let index = selectedTraplines.index(of: trapline) {
            selectedTraplines.remove(at: index)
            if selectedTraplines.count == 0 {
                view.setNextButtonState(enabled: false)
            }
            view.setSelectedTraplinesDescription(description: selectedTraplinesText)
        }
    }
        
    func didSelectNext() {
        if let _ = route {
            // this will show all stations and only select those in the route
//            router.showStationSelect(traplines: self.selectedTraplines, selectedStationIds: route!.stationIds)
        } else {
            // this will show and select all stations
            router.showStationSelect(traplines: self.selectedTraplines)
        }
    }
    
    func didSelectClose() {
        _view.dismiss(animated: true, completion: nil)
    }
}

// MARK: - TraplineSelect Viper Components
private extension TraplineSelectPresenter {
    var view: TraplineSelectViewApi {
        return _view as! TraplineSelectViewApi
    }
    var interactor: TraplineSelectInteractorApi {
        return _interactor as! TraplineSelectInteractorApi
    }
    var router: TraplineSelectRouterApi {
        return _router as! TraplineSelectRouterApi
    }
}
