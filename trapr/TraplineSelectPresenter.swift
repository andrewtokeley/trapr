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
    
    private let TITLE = "New Route"
    
    fileprivate var delegate: TraplineSelectDelegate?
    
    fileprivate var routeName: String?
    fileprivate var selectedTraplines = [Trapline]()
    fileprivate var selectedTraplinesText: String {
        return selectedTraplines.map({ (trapline) -> String in return trapline.code! }).joined(separator: ", ")
    }
    
    private let DELIMMTER = ", "
    private let ROUTE_NAME = "Route name"
    
    override func viewIsAboutToAppear() {
        
        if let traplines = interactor.getAllTraplines() {
            view.updateDisplay(traplines: traplines)
        }
        
        view.setTitle(title: TITLE)
        view.setRouteNamePlaceholderText(text: ROUTE_NAME)
        view.setNextButtonState(enabled: false)
        view.setSelectedTraplinesDescription(description: "")
    }
    
    override func setupView(data: Any) {
        if let data = data as? TraplineSelectDelegate {
            self.delegate = data
        }
    }
}

//MARK: - StationSelectDelegate
extension TraplineSelectPresenter: StationSelectDelegate {
    
    func didSelectStations(stations: [Station]) {
        
        if let _ = routeName {
            let route = Route(name: self.routeName!, stations: stations)
            
            if !ServiceFactory.sharedInstance.routeService.routeExists(route: route) {
                ServiceFactory.sharedInstance.routeService.add(route: route)
            }
            
            self.delegate?.didCreateRoute(route: route)
            
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
        router.showStationSelect(traplines: self.selectedTraplines)
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
