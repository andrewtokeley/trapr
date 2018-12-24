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
    var initialStation: _Station?
    
    var complete: Bool {
        return routeName != nil && initialStation != nil
    }
}

// MARK: - NewRoutePresenter Class
final class NewRoutePresenter: Presenter {
    
    fileprivate let LISTPICKER_TRAPLINE = 0
    fileprivate let LISTPICKER_STATION = 1
    fileprivate let LISTPICKER_REGION = 2
    
    fileprivate var newRouteParameters = NewRouteParameters()
    
    fileprivate var traplines = [_Trapline]()
    fileprivate var stations = [_Station]()
    fileprivate var regions = [_Region]()

    fileprivate var selectedTrapline: _Trapline?
    fileprivate var selectedRegion: _Region?

    override func viewIsAboutToAppear() {
        _view.setTitle(title: "New Route")
        
        if self.selectedRegion == nil {
            // default to the first region
            interactor.retrieveRegions()
        }
        
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
    
    func didSelectRegionListPicker() {
        // make sure the view knows what regions to show
        interactor.retrieveRegions()
        
        let setup = ListPickerSetupData()
        setup.delegate = self
        setup.enableMultiselect = false
        setup.tag = LISTPICKER_REGION
        setup.embedInNavController = false
        router.showListPicker(setupData: setup)
    }
    
    func didSelectTraplineListPicker() {
        
        if let region = selectedRegion {
         
            // make sure the view knows what traplines to show for the selected region
            if let regionId = region.id {
                interactor.retrieveTraplines(regionId: regionId)
                
                let setup = ListPickerSetupData()
                setup.delegate = self
                setup.enableMultiselect = false
                setup.tag = LISTPICKER_TRAPLINE
                setup.embedInNavController = false
                router.showListPicker(setupData: setup)
            }
        }
    }
    
    func didSelectStationListPicker() {
        
        if let _ = selectedTrapline {
            
            let setup = ListPickerSetupData()
            setup.delegate = self
            setup.enableMultiselect = false
            setup.tag = LISTPICKER_STATION
            setup.embedInNavController = false
            router.showListPicker(setupData: setup)
        }
    }
    
    func didFetchTraplines(traplines: [_Trapline]) {
        self.traplines = traplines
        
        view.setTraplines(traplines: traplines)
    }
    
    func didFetchRegions(regions: [_Region]) {
        self.regions = regions
        
        if let defaultRegion = self.regions.first, let routeId = defaultRegion.id {
            self.selectedRegion = defaultRegion
            interactor.retrieveTraplines(regionId: routeId)
            view.displaySelectedRegion(description: defaultRegion.name)
        }
    }
    
    func didFetchStations(stations: [_Station]) {
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
        if listPicker.tag == LISTPICKER_REGION { return regions.count}
        return 0
    }
    
    func listPickerTitle(_ listPicker: ListPickerView) -> String {
        if listPicker.tag == LISTPICKER_STATION { return "Station" }
        if listPicker.tag == LISTPICKER_TRAPLINE { return "Trapline" }
        if listPicker.tag == LISTPICKER_REGION { return "Region" }
        return ""
    }
    
    func listPicker(_ listPicker: ListPickerView, itemTextAt index: Int) -> String {
        if listPicker.tag == LISTPICKER_STATION { return stations[index].longCode }
        if listPicker.tag == LISTPICKER_TRAPLINE { return traplines[index].code }
        if listPicker.tag == LISTPICKER_REGION { return regions[index].name }
        return ""
    }
    
    func listPicker(_ listPicker: ListPickerView, didSelectItemAt index: Int) {
        
        if listPicker.tag == LISTPICKER_TRAPLINE {
            if self.selectedTrapline != traplines[index] {
                self.selectedTrapline = traplines[index]
                self.newRouteParameters.initialStation = nil
                
                // refresh the stations list
                if let traplineId = selectedTrapline?.id {
                    self.interactor.retrieveStations(traplineId: traplineId)
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
        
        if listPicker.tag == LISTPICKER_REGION {
            if self.selectedRegion != regions[index] {
                self.selectedRegion = regions[index]
                
                // refresh the traplines
                if let regionId = selectedRegion!.id {
                    interactor.retrieveTraplines(regionId: regionId)
                }

                self.newRouteParameters.initialStation = nil
                
                view.displaySelectedRegion(description: selectedRegion?.name)
                view.displaySelectedTrapline(description: nil)
                view.displaySelectedStation(description: nil)

                needsNavigationUpdate()
            }
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
