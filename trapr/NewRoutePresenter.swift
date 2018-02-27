//
//  NewRoutePresenter.swift
//  trapr
//
//  Created by Andrew Tokeley on 19/01/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

private struct NewRouteParameters {
    var routeName: String?
    var initialStation: Station?
    
    var complete: Bool {
        return routeName != nil && initialStation != nil
    }
}

// MARK: - NewRoutePresenter Class
final class NewRoutePresenter: Presenter {
    
    fileprivate let LISTPICKER_TRAPLINE = 0
    fileprivate let LISTPICKER_STATION = 1
    
    fileprivate var newRouteParameters = NewRouteParameters()
    
    fileprivate var traplines = [Trapline]()
    fileprivate var selectedTrapline: Trapline?
    fileprivate var stations = [Station]()
    
    override func viewIsAboutToAppear() {
        _view.setTitle(title: "New Route")
        needsNavigationUpdate()
    }
}

// MARK: - NewRoutePresenter API
extension NewRoutePresenter: NewRoutePresenterApi {
    
    func didSelectNext() {
        
        if self.newRouteParameters.complete {
            router.showRouteDashboard(newRouteName: self.newRouteParameters.routeName!,  station: self.newRouteParameters.initialStation!)
        }
    }
    
    func didSelectCancel() {
        _view.dismiss(animated: true, completion: nil)
    }
    
    func didUpdateRouteName(name: String?) {
        needsNavigationUpdate()
        newRouteParameters.routeName = name
    }
    
    private func needsNavigationUpdate() {
        view.enableNextButton(enabled: newRouteParameters.complete)
    }
    
    func didSelectTraplineListPicker() {
        
        // make sure the view knows what traplines to show
        interactor.retrieveTraplines()
        
        let setup = ListPickerSetupData()
        setup.delegate = self
        setup.enableMultiselect = false
        setup.tag = LISTPICKER_TRAPLINE
        setup.embedInNavController = false
        router.showListPicker(setupData: setup)
    }
    
    func didSelectStationListPicker() {
        let setup = ListPickerSetupData()
        setup.delegate = self
        setup.enableMultiselect = false
        setup.tag = LISTPICKER_STATION
        setup.embedInNavController = false
        router.showListPicker(setupData: setup)
    }
    
    func didFetchTraplines(traplines: [Trapline]) {
        self.traplines = traplines
        
        view.setTraplines(traplines: traplines)
    }
    
    func didFetchStations(stations: [Station]) {
        self.stations = stations
    }
}

extension NewRoutePresenter: ListPickerDelegate {
    
    func listPickerHeaderText(_ listPicker: ListPickerView) -> String {
        return ""
    }
    
    func listPickerNumberOfRows(_ listPicker: ListPickerView) -> Int {
        if listPicker.tag == LISTPICKER_STATION { return stations.count }
        if listPicker.tag == LISTPICKER_TRAPLINE { return traplines.count }
        return 0
    }
    
    func listPickerTitle(_ listPicker: ListPickerView) -> String {
        if listPicker.tag == LISTPICKER_STATION { return "Station" }
        if listPicker.tag == LISTPICKER_TRAPLINE { return "Trapline" }
        return ""
    }
    
    func listPicker(_ listPicker: ListPickerView, itemTextAt index: Int) -> String {
        if listPicker.tag == LISTPICKER_STATION { return stations[index].longCode }
        if listPicker.tag == LISTPICKER_TRAPLINE { return traplines[index].code! }
        return ""
    }
    
    func listPicker(_ listPicker: ListPickerView, didSelectItemAt index: Int) {
        if listPicker.tag == LISTPICKER_TRAPLINE {
            if self.selectedTrapline != traplines[index] {
                self.selectedTrapline = traplines[index]
                self.newRouteParameters.initialStation = nil
                if let stations = selectedTrapline?.stations {
                    self.didFetchStations(stations: Array(stations))
                }
                view.displaySelectedTrapline(description: selectedTrapline?.code)
                view.displaySelectedStation(description: nil)
                needsNavigationUpdate()
            }
            
        }
        
        if listPicker.tag == LISTPICKER_STATION {
            newRouteParameters.initialStation = stations[index]
            view.displaySelectedStation(description: newRouteParameters.initialStation!.longCode)
            needsNavigationUpdate()
        }
    }
    
}
// MARK: - NewRoute Viper Components
private extension NewRoutePresenter {
    var view: NewRouteViewApi {
        return _view as! NewRouteViewApi
    }
    var interactor: NewRouteInteractorApi {
        return _interactor as! NewRouteInteractorApi
    }
    var router: NewRouteRouterApi {
        return _router as! NewRouteRouterApi
    }
}
