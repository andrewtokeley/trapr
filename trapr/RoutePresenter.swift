//
//  RoutePresenter.swift
//  trapr
//
//  Created by Andrew Tokeley on 21/11/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

enum sectionMenuOptionTitle: String {
    case edit = "Edit"
    case moveUp = "Move up"
    case moveDown = "Move down"
    case reverseOrder = "Reverse order"
    case deleteSection = "Delete section"
}

// MARK: - RoutePresenter Class
final class RoutePresenter: Presenter {
    
    // MARK: - File private properties
    fileprivate var setupData: RouteSetupData!
    fileprivate var currentRoute: Route?
    fileprivate var sectionContext: Int = 0
    fileprivate var traplineContext: Trapline?
    fileprivate var sectionMenuOptions = [OptionItem]()
    
    fileprivate let LISTPICKER_VISITFREQUENCY = 0
    fileprivate let LISTPICKER_TRAPLINE = 1
    fileprivate let LISTPICKER_STATIONS = 2
    
    fileprivate lazy var traplines: [Trapline] = {
        return ServiceFactory.sharedInstance.traplineService.getTraplines() ?? [Trapline]()
    }()
    
    fileprivate var isNew: Bool {
        if let _ = self.setupData {
            return self.setupData!.route == nil
        }
        return true
    }

    fileprivate var groupedData: GroupedTableViewDatasource<Station>? {
        
        // construct the grouped data from the route stations
        if let _ = currentRoute {
            
            let stations = Array(currentRoute!.stations)
            
            let groupedData = GroupedTableViewDatasource<Station>(data: stations, selected: [Bool](repeatElement(false, count: stations.count)), sectionName: { (station) in return station.trapline!.code!}, cellLabelText: { (station) in return station.longCode})
            
            return groupedData
        }
        return nil
    }
    
    fileprivate var orderedStations: [Station] {
        var stations = [Station]()
        if let sorted = self.traplineContext?.stations.sorted(byKeyPath: "code") {
            stations = Array(sorted)
        }
        return stations
    }
    
    // MARK: - Private properties
    private let NO_SECTIONS_TEXT = "Sections are defined by a Trapline and some, or all, of its Stations."

    // MARK: - Presenter overrides
    override func setupView(data: Any) {
        if let setupData = data as? RouteSetupData {
            self.setupData = setupData
         
            // we take a copy of the route instance to allow properties to be updated before saving, otherwise everything has to be wrapped in realm.write {}
            if let route = setupData.route {
                self.currentRoute = Route(value: route)
            } else {
                self.currentRoute = Route()
            }
            
            self.initialiseView()
        }
    }
    
    // MARK: - Initialisation
    private func initialiseView() {
        
        view.setTitle(title: "Route")
        
        view.hideSectionsTableView(hide: isNew)
        
        if isNew {
            
            view.displayNoSectionsText(text: NO_SECTIONS_TEXT)
            view.displayRouteName(name: "")
            view.setFocusToRouteName()
            view.displayVisitFrequency(frequency: TimePeriod.month)
        } else {

            view.displayRouteName(name: setupData.route!.name ?? "")
            view.displayVisitFrequency(frequency: setupData.route!.visitFrequency)
            if let data = groupedData {
                view.bindToGroupedTableViewData(groupedData: data)
            }
        }
    }
    
    fileprivate func saveRoute() {
        if let _ = self.currentRoute {
            let route = Route(value: self.currentRoute!)
            interactor.saveRoute(route: route)
        }
    }

}

// MARK: - RoutePresenter API
extension RoutePresenter: RoutePresenterApi {
    
    func didSelectClose() {
        _view.dismiss(animated: true, completion: nil)
    }
    
    func didSelectDone() {
        _view.view.endEditing(true)
        saveRoute()
        _view.dismiss(animated: true, completion: nil)
    }
    
    func didSelectAddSection() {
        let listPickerTraplineSetup = ListPickerSetupData()
        listPickerTraplineSetup.delegate = self
        listPickerTraplineSetup.embedInNavController = false
        listPickerTraplineSetup.tag = LISTPICKER_TRAPLINE
        
        let listPickerStationsSetupData = ListPickerSetupData()
        listPickerStationsSetupData.delegate = self
        listPickerStationsSetupData.tag = LISTPICKER_STATIONS
        listPickerStationsSetupData.embedInNavController = false
        listPickerStationsSetupData.enableMultiselect = true
        
        // default to having all stations selected
        if let stationCount = self.traplineContext?.stations.count {
            listPickerStationsSetupData.selectedIndicies = Array(0...stationCount)
        }
        
        listPickerTraplineSetup.childSetupData = listPickerStationsSetupData
        
        router.showListPicker(setupData: listPickerTraplineSetup)
    }
    
    func didUpdateRouteName(name: String?) {
        self.currentRoute?.name = name
    }
    
    func didSelectToChangeVisitFrequency() {
        
        let listpickerSetup = ListPickerSetupData()
        listpickerSetup.delegate = self
        listpickerSetup.tag = LISTPICKER_VISITFREQUENCY
        listpickerSetup.embedInNavController = false
        router.showListPicker(setupData: listpickerSetup)
    }
    
    func didSelectDeleteStation(item: GroupedTableViewDatasourceItem<Station>) {
        
    }
    
    func didSelectShowSectionMenu(section: Int) {
        
        self.sectionMenuOptions = [
            OptionItem(title: sectionMenuOptionTitle.edit.rawValue, isEnabled: true),
            OptionItem(title: sectionMenuOptionTitle.moveUp.rawValue, isEnabled: true),
            OptionItem(title: sectionMenuOptionTitle.moveDown.rawValue, isEnabled: true),
            OptionItem(title: sectionMenuOptionTitle.reverseOrder.rawValue, isEnabled: true),
            OptionItem(title: sectionMenuOptionTitle.deleteSection.rawValue, isEnabled: true, isDestructive: true),
        ]
        
        self.sectionContext = section
        self.traplineContext = groupedData?.data(section: section, row: 0).item.trapline
        
        // get the description of the section for the title of the menu
        if let stations = groupedData?.dataItems(section: self.sectionContext, selectedOnly: false)
        {
            let title = ServiceFactory.sharedInstance.stationService.getDescription(stations: stations, includeStationCodes: true)
            view.displaySectionMenuOptionItems(title: title, message: nil, optionItems: self.sectionMenuOptions)
        }
//        if let groupData = self.groupedData {
//            var title = ""
//            let firstItemInSection = groupData.data(section: section, row: 0).item.longCode
//            let lastItemInSection = groupData.data(section: section, row: groupData.numberOfRowsInSection(section: section) - 1).item.longCode
//
//            if firstItemInSection != lastItemInSection {
//                title = "\(firstItemInSection) - \(lastItemInSection)"
//            } else {
//                title = "\(firstItemInSection)"
//            }
//
//            view.displaySectionMenuOptionItems(title: title, message: nil, optionItems: self.sectionMenuOptions)
//        }
    }
    
    func didSelectSectionMenuOptionItem(title: String) {
        if title == sectionMenuOptionTitle.deleteSection.rawValue {
            if let groupData = self.groupedData {
                groupData.remove(section: self.sectionContext)
                if let _ = self.currentRoute {
                    let stations = groupData.dataItems(selectedOnly: false)
                    self.currentRoute?.stations.removeAll()
                    self.currentRoute?.stations.append(objectsIn: stations)
                }
                view.bindToGroupedTableViewData(groupedData: groupData)
            }
        }
        
        if title == sectionMenuOptionTitle.edit.rawValue {
            let listPickerStationsSetupData = ListPickerSetupData()
            listPickerStationsSetupData.delegate = self
            listPickerStationsSetupData.tag = LISTPICKER_STATIONS
            listPickerStationsSetupData.embedInNavController = true
            listPickerStationsSetupData.enableMultiselect = true
            router.showListPicker(setupData: listPickerStationsSetupData)
        }
        
        if title == sectionMenuOptionTitle.reverseOrder.rawValue {
            
            // get the stations in the section
            if let groupData = self.groupedData {
                
                // reverse order of underlying groupData structure
                let stations = groupData.dataItems(section: self.sectionContext, selectedOnly: false)
                let reorderedStations = ServiceFactory.sharedInstance.stationService.reverseOrder(stations: stations)
                groupData.replace(dataInSection: self.sectionContext, items: reorderedStations)

                // update the order in the Route itself
                if let _ = self.currentRoute {
                    let stations = groupData.dataItems(selectedOnly: false)
                    self.currentRoute?.stations.removeAll()
                    self.currentRoute?.stations.append(objectsIn: stations)
                }
                view.bindToGroupedTableViewData(groupedData: groupData)
            }
            
            
            
        }
    }
    
}

extension RoutePresenter: ListPickerDelegate {
    
    func listPickerTitle(_ listPicker: ListPickerView) -> String {
        switch listPicker.tag {
        case LISTPICKER_TRAPLINE:
            return "Trapline"
        case LISTPICKER_VISITFREQUENCY:
            return "Visit Frequency"
        case LISTPICKER_STATIONS:
            return "Stations"
        default:
            return ""
        }
    }
    
    func listPickerHeaderText(_ listPicker: ListPickerView) -> String {
        switch listPicker.tag {
        case LISTPICKER_TRAPLINE:
            return "Traplines"
        case LISTPICKER_VISITFREQUENCY:
            return "Visit Frequency"
        case LISTPICKER_STATIONS:
            return "Stations"
        default:
            return ""
        }
    }
    
    func listPickerNumberOfRows(_ listPicker: ListPickerView) -> Int {
        switch listPicker.tag {
        case LISTPICKER_TRAPLINE:
            return self.traplines.count
        case LISTPICKER_VISITFREQUENCY:
            return TimePeriod.count
        case LISTPICKER_STATIONS:
            // return the number of stations defined in the trapline this section represents!
            return self.traplineContext?.stations.count ?? 0
        default:
            return 0
        }
    }

    func listPicker(_ listPicker: ListPickerView, didSelectItemAt index: Int) {
        
        if listPicker.tag == LISTPICKER_TRAPLINE {
            
            // we are building a new section for this trapline, so set the context to new section.
            self.sectionContext = -1
            
            // store the traplineContent so we know which stations to list on the next Stations ListPicker
            self.traplineContext = self.traplines[index]
            
        } else if listPicker.tag == LISTPICKER_VISITFREQUENCY {
                self.currentRoute?.visitFrequencyRaw = TimePeriod.all[index].rawValue
                view.displayVisitFrequency(frequency: self.currentRoute?.visitFrequency ?? TimePeriod.defaultValue)
        }
    }
    
    func listPicker(_ listPicker: ListPickerView, didSelectMultipleItemsAt indexes: [Int]) {
        if listPicker.tag == LISTPICKER_STATIONS {
            
            // get the sections that were selected
            let stations = self.orderedStations.filter({
                (station) in
                if let indexOfStation = self.orderedStations.index(of: station) {
                    return indexes.contains(indexOfStation)
                }
                return false
            })
                
            // new section
            if self.sectionContext == -1 {
                
                // add a new section to the end of the route
                self.currentRoute?.stations.append(objectsIn: stations)

            // existing section
            } else {
                
                //replace all the stations in the current section with those selected
                if let groupData = self.groupedData {
                    groupData.replace(dataInSection: self.sectionContext, items: Array(stations))
                
                    if let _ = self.currentRoute {
                        let stations = groupData.dataItems(selectedOnly: false)
                        self.currentRoute?.stations.removeAll()
                        self.currentRoute?.stations.append(objectsIn: stations)
                    }
                }
            }
            
            view.hideSectionsTableView(hide: false)
            view.bindToGroupedTableViewData(groupedData: self.groupedData!)
        }
    }
    
    func listPicker(_ listPicker: ListPickerView, itemTextAt index: Int) -> String {
        if listPicker.tag == LISTPICKER_TRAPLINE {
            return self.traplines[index].code ?? ""
        } else if listPicker.tag == LISTPICKER_VISITFREQUENCY {
            return TimePeriod.all[index].name
        } else if listPicker.tag == LISTPICKER_STATIONS {
            return self.orderedStations[index].longCode
            //return self.traplineContext!.stations[index].longCode
        }
        return ""
    }
    
    func listPicker(_ listPicker: ListPickerView, isSelected index: Int) -> Bool {
        if listPicker.tag == LISTPICKER_STATIONS {
            
            // if we're opening the list picker from a section
            if self.sectionContext >= 0 {
                let stationsInSection = self.groupedData?.dataItems(section: self.sectionContext, selectedOnly: false)
                
                // check if the station at index is in the section
                let currentStation = self.orderedStations[index]
                return stationsInSection?.contains(currentStation) ?? false
                
            } else {
                // always select all for new sections
                return true
            }
        }
        
        if listPicker.tag == LISTPICKER_VISITFREQUENCY {
            if let selectedIndex = self.currentRoute?.visitFrequency.rawValue {
                return index == selectedIndex
            } else {
                return false
            }
        }
        // Don't select anything for
        return false
        
    }
    
    func listPickerInitialMultiselectState(_ listPicker: ListPickerView) -> MultiselectOptions {
        if listPicker.tag == LISTPICKER_STATIONS {
            // since we're going to select all
            return .selectNone
        } else {
            return .none
        }
    }
    
    func listPickerHasChildListPicker(_ listPicker: ListPickerView) -> Bool {
        return listPicker.tag == LISTPICKER_TRAPLINE
    }
    
}

// MARK: - Route Viper Components
private extension RoutePresenter {
    var view: RouteViewApi {
        return _view as! RouteViewApi
    }
    var interactor: RouteInteractorApi {
        return _interactor as! RouteInteractorApi
    }
    var router: RouteRouterApi {
        return _router as! RouteRouterApi
    }
}
