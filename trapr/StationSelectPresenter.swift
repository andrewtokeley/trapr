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
    
    fileprivate var sortingEnabled = false
    
    fileprivate var groupedData: GroupedTableViewDatasource<Station>!
    
    fileprivate var toggleState: [MultiselectOptions] {
        
        var state = [MultiselectOptions]()
        
        // hide toggle if single select
        if !self.allowMultiselect || self.sortingEnabled {
            state = Array(repeating: MultiselectOptions.none, count: groupedData.numberOfSections())
        } else {
            for i in 0...groupedData.numberOfSections() - 1 {
                if groupedData.hasSelected(section: i) {
                    state.append(.selectNone)
                } else {
                    state.append(.selectAll)
                }
            }
        }
        
        return state
    }
    
    fileprivate var TITLE = "Route"
    
    fileprivate var mode: ModuleMode?
    
    override func viewIsAboutToAppear() {
        
        _view.setTitle(title: TITLE)
        
        view.setDoneButtonAttributes(visible: allowMultiselect, enabled: false)
        
        if !allowMultiselect {
            view.showCloseButton()
        }
        
        showStations(selectedOnly: false)
        
        for section in 0...groupedData.numberOfSections() - 1 {
            view.setMultiselectToggle(section: section, state: self.toggleState[section])
        }
        
        updateNavigationItemState()
    }
    
    fileprivate func showStations(selectedOnly: Bool) {
        
        let selectedStations = self.groupedData.dataItems(selectedOnly: true)
        
        // show all the stations or just the ones selected inside the groupdData instance
        let stationsToShow = selectedOnly ? self.groupedData.dataItems(selectedOnly: true) : self.stations
        
        // get a bool array for those selected
        let selected = stationsToShow.map({ (station) in return selectedStations.contains(where: { (selected) in return selected.longCode == station.longCode }) })
        
        // recreate the groupedData structure
        self.groupedData = GroupedTableViewDatasource<Station>(data: stationsToShow, selected: selected, sectionName: {
            (station) in
            return station.trapline!.code!
        }, cellLabelText: {
            (station) in
            return station.code!
        })
        
        view.initialiseView(groupedData: self.groupedData, traplines: self.traplines, stations: self.stations, selectedStations: self.selectedStations, allowMultiselect: self.allowMultiselect)
    }
    
    override func setupView(data: Any) {
        if let setup = data as? StationSelectSetupData {
            
            self.traplines = setup.traplines
            self.stations = setup.stations
            self.allowMultiselect = setup.allowMultiselect
            self.selectedStations = setup.selectedStations ?? [Station]()
            self.stationSelectDelegate = setup.stationSelectDelegate
            
            // initialize GroupedData
            let selected = self.stations.map({ (station) in return self.selectedStations.contains(where: { (selected) in return selected.longCode == station.longCode }) })
            
            self.groupedData = GroupedTableViewDatasource<Station>(data: self.stations, selected: selected, sectionName: {
                (station) in
                return station.trapline!.code!
            }, cellLabelText: {
                (station) in
                return station.code!
            })
            
//            if self.allowMultiselect {
//
//                // default to all stations being selected
//                self.toggleState = Array(repeating: MultiselectToggle.selectNone, count: setup.traplines.count)
//            } else {
//
//                // Hide toggle button if single select
//                self.toggleState = Array(repeating: MultiselectToggle.none, count: setup.traplines.count)
//            }
        }
    }
    
    fileprivate func updateNavigationItemState() {
        view.setDoneButtonAttributes(visible: self.allowMultiselect, enabled: self.selectedStations.count > 0)
    }
}

// MARK: - StationSelectPresenter API
extension StationSelectPresenter: StationSelectPresenterApi {
    
    func didSelectRow(section: Int, row: Int) {
        
        let groupDataItem = self.groupedData.data(section: section, row: row)
        
        if allowMultiselect {
            
            // toggle state
            groupDataItem.selected = !groupDataItem.selected
            print(groupedData.dataItems(selectedOnly: true).count)
            view.updateGroupedData(section: section, groupedData: self.groupedData)
            updateNavigationItemState()
            
        } else {
            
            self.stationSelectDelegate?.newStationsSelected(stations: [groupDataItem.item])
            _view.dismiss(animated: true, completion: nil)
        }
    }
    
//    func didSelectStation(section: Int, station: Station) {
//        if allowMultiselect {
//
//            self.selectedStations.append(station)
//
//            self.groupedData.setSelected(section: <#T##Int#>, row: <#T##Int#>, selected: <#T##Bool#>)
//            updateNavigationItemState()
//
//            view.updateSelectedStations(section: section, selectedStations: self.selectedStations)
//            view.updateGroupedData(section: section, groupedData: self.groupedData)
//        } else {
//
//            self.stationSelectDelegate?.didSelectStations(stations: [station])
//            _view.dismiss(animated: true, completion: nil)
//        }
//    }
    
//    func didDeselectStation(section: Int, station: Station) {
//        if let index = selectedStations.index(where: { $0.longCode == station.longCode }) {
//            self.selectedStations.remove(at: index)
//        }
//        updateNavigationItemState()
//        view.updateSelectedStations(section: section, selectedStations: self.selectedStations)
//    }
    
    func didSelectCloseButton() {
        _view.dismiss(animated: true, completion: nil)
    }
    
    func didSelectMultiselectToggle(section: Int) {
        
        if self.toggleState[section] == .selectNone {
            
            // Deselect all stations in section
            self.groupedData.setSelected(section: section, selected: false)
            
        } else {
            
            // Deselect all stations in section
            self.groupedData.setSelected(section: section, selected: true)
        }

        // this will get the checkmarks set
        view.updateGroupedData(section: section, groupedData: self.groupedData)
        
        // this will set the headers
        view.setMultiselectToggle(section: section, state: self.toggleState[section])
        
        updateNavigationItemState()
    }
    
    func didSelectDone() {
        
        self.stationSelectDelegate?.newStationsSelected(stations: self.groupedData.dataItems(selectedOnly: true))
        
        // close the StationSelect module
        _view.dismiss(animated: true, completion: nil)
    }
    
    func didMoveRow(from: IndexPath, to:IndexPath) {
        
        self.groupedData.moveItem(from: from, to: to)
        self.stations = groupedData.dataItems(selectedOnly: false)
        
        view.updateGroupedData(groupedData: self.groupedData)
    }
    
    func didSelectEdit() {
        
        self.sortingEnabled = !self.sortingEnabled
        showStations(selectedOnly: self.sortingEnabled)
        
        view.enableSorting(enabled: self.sortingEnabled)
    }
    
    func getToggleState(section: Int) -> MultiselectOptions {
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
