//
//  StationSelectPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 3/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

enum ModuleMode {
    case editingRoute
    case creatingRoute
    case selectingStation
}

// MARK: - StationSelectPresenter Class
final class StationSelectPresenter: Presenter {
    
    fileprivate var traplines = [Trapline]()
    fileprivate var stations = [Station]()
    fileprivate var selectedStations = [Station]()
    fileprivate var allowMultiselect: Bool = false
    fileprivate var stationSelectDelegate: StationSelectDelegate?

    fileprivate var toggleState: [MultiselectToggle]!
    fileprivate var TITLE = "Route"
    
    fileprivate var mode: ModuleMode?
    
    override func viewIsAboutToAppear() {
        view.setTitle(title: TITLE)
        
        view.setDoneButtonAttributes(visible: allowMultiselect, enabled: false)
        
        if !allowMultiselect {
            view.showCloseButton()
        }
        
        view.initialiseView(traplines: self.traplines, stations: self.stations, selectedStations: self.selectedStations, allowMultiselect: self.allowMultiselect)
        
        updateNavigationItemState()
    }
    
    override func setupView(data: Any) {
        if let setup = data as? StationSelectSetupData {
            
            self.traplines = setup.traplines
            self.stations = setup.stations
            self.allowMultiselect = setup.allowMultiselect
            self.selectedStations = setup.selectedStations ?? [Station]()
            self.stationSelectDelegate = setup.stationSelectDelegate
            
            if self.allowMultiselect {
                
                // default to all stations being selected
                self.toggleState = Array(repeating: MultiselectToggle.selectNone, count: setup.traplines.count)
            } else {
                
                // Hide toggle button if single select
                self.toggleState = Array(repeating: MultiselectToggle.none, count: setup.traplines.count)
            }
        }
    }
    
    fileprivate func updateNavigationItemState() {
        view.setDoneButtonAttributes(visible: self.allowMultiselect, enabled: self.selectedStations.count > 0)
    }
}

// MARK: - StationSelectPresenter API
extension StationSelectPresenter: StationSelectPresenterApi {
        
    func didSelectStation(station: Station) {
        if allowMultiselect {
            
            self.selectedStations.append(station)
            updateNavigationItemState()
        } else {
            
            self.stationSelectDelegate?.didSelectStations(stations: [station])
            _view.dismiss(animated: true, completion: nil)
        }
    }
    
    func didDeselectStation(station: Station) {
        if let index = selectedStations.index(where: { $0.longCode == station.longCode }) {
            self.selectedStations.remove(at: index)
        }
        updateNavigationItemState()
    }
    
    func didSelectCloseButton() {
        _view.dismiss(animated: true, completion: nil)
    }
    
    func didSelectMultiselectToggle(section: Int) {
        
        // get the stations in the section
        let traplineCode = self.traplines[section].code
        let stationsInSection = self.stations.filter({ $0.trapline?.code == traplineCode })

        if self.toggleState[section] == .selectNone {
            
            self.toggleState[section] = .selectAll

            // make sure all these stations are NOT the selectStations array
            for station in stationsInSection {
                
                if let index = selectedStations.index(where: { $0.longCode == station.longCode }) {
                    selectedStations.remove(at: index)
                }
            }
        } else {
            
            self.toggleState[section] = .selectNone
            
            // make sure all these stations are in the selectStations array
            for station in stationsInSection {
                if !selectedStations.contains(where: { $0.longCode == station.longCode }) {
                    selectedStations.append(station)
                }
            }
            
        }
        view.setMultiselectToggle(section: section, state: self.toggleState[section])
        view.updateSelectedStations(section: section, selectedStations: selectedStations)
        
        updateNavigationItemState()
    }
    
    func didSelectDone() {
        
        self.stationSelectDelegate?.didSelectStations(stations: self.selectedStations)
        
        // close the StationSelect module
        _view.dismiss(animated: true, completion: nil)
    }
    
    func didSelectEdit() {
        
    }
    
    func getToggleState(section: Int) -> MultiselectToggle {
        return toggleState[section]
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
