//
//  VisitLogPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 24/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - VisitLogPresenter Class
final class VisitLogPresenter: Presenter {
    fileprivate var currentVisit: Visit?
    fileprivate var species: [Species]?
    fileprivate var lures: [Lure]?
    
    fileprivate let LIST_SPECIES = 0
    fileprivate let LIST_LURE = 1
    fileprivate let LIST_TRAPSTATUS = 2
    
    func saveVisit() {
        if let visit = self.currentVisit {
            interactor.saveVisit(visit: visit)
        }
    }
    
    func updateViewForCurrentVisit() {
        if self.currentVisit != nil {
            view.displayVisit(visit: self.currentVisit!, showCatchSection: self.currentVisit?.trap?.type?.killMethod == .direct)
        }
    }
}

//MARK: - VisitDelegate

extension VisitLogPresenter: VisitDelegate {
    
    func didChangeVisit(visit: Visit, isNew: Bool) {
        
        // take a copy so that visit can be bulk updated
        self.currentVisit = Visit(value: visit)
        
        if !isNew {
            updateViewForCurrentVisit()
        } else {
            view.displayNoVisitState()
        }
        
    }
}

// MARK: - DatePickerDelegate
extension VisitLogPresenter: DatePickerDelegate {
    
    func datePicker(_ datePicker: DatePickerViewApi, textFor element: DatePickerElement) -> String {
        if element == .title {
            return "Visit Time"
        }
        return element.defaultTextValue
    }
    
    func displayMode(_ datePicker: DatePickerViewApi) -> UIDatePickerMode {
        return .time
    }
    
    func datePicker(_ datePicker: DatePickerViewApi, didSelectDate date: Date) {
        self.currentVisit?.visitDateTime = date
        view.displayDateTime(date: date)
        saveVisit()
    }
}

// MARK: - VisitLogPresenterApi
extension VisitLogPresenter: VisitLogPresenterApi {
    
    func didSelectToChangeTime() {
        
        if let _ = self.currentVisit {
            let setupData = DatePickerSetupData()
            setupData.initialDate = self.currentVisit!.visitDateTime
            setupData.delegate = self
            
            router.showDatePicker(setupData: setupData)
        }
    }
    
    func didSelectToTrapStatus() {
        let setupData = ListPickerSetupData()
        setupData.delegate = self
        setupData.tag = LIST_TRAPSTATUS
        setupData.embedInNavController = false
        setupData.includeSelectNone = false
        
        router.showListPicker(setupData: setupData)
    }
    
    func didSelectToChangeSpecies() {
        
        if self.species == nil {
            interactor.retrieveSpeciesList(callback: {
                (species) in
                self.species = species
                self.didSelectToChangeSpecies()
            })
        } else {
            let setupData = ListPickerSetupData()
            setupData.delegate = self
            setupData.tag = LIST_SPECIES
            setupData.embedInNavController = false
            setupData.includeSelectNone = true
            
            router.showListPicker(setupData: setupData)
        }
    }
    
    func didSelectToChangeLure() {
        
        let setupData = ListPickerSetupData()
        setupData.delegate = self
        setupData.tag = LIST_LURE
        setupData.embedInNavController = false
        setupData.includeSelectNone = true
        
        router.showListPicker(setupData: setupData)
    
    }
    
    func didSelectToRecordVisit() {
        saveVisit()
        updateViewForCurrentVisit()
    }
    
    func didUpdateBaitAddedValue(newValue: Int) {
        self.currentVisit?.baitAdded = newValue
        saveVisit()
    }
    func didUpdateBaitEatenValue(newValue: Int) {
        self.currentVisit?.baitEaten = newValue
        saveVisit()
    }
    func didUpdateBaitRemovedValue(newValue: Int) {
        self.currentVisit?.baitRemoved = newValue
        saveVisit()
    }
}

// MARK: - ListPickerDelegate (Species)
extension VisitLogPresenter: ListPickerDelegate {
    
    func listPicker(title listPicker: ListPickerView) -> String {
        switch listPicker.tag {
        case LIST_SPECIES: return "Species"
        case LIST_LURE: return "Lure"
        default: return "Trap Status"
        }
    }
    
    func listPicker(numberOfRows listPicker: ListPickerView) -> Int {
        switch listPicker.tag {
        case LIST_SPECIES: return self.currentVisit?.trap?.type?.catchableSpecies.count ?? 0
        case LIST_LURE: return self.currentVisit?.trap?.type?.availableLures.count ?? 0
        default: return TrapStatus.count
        }
        
    }
    
    func listPicker(headerText listPicker: ListPickerView) -> String {
        switch listPicker.tag {
        case LIST_SPECIES: return "Select Species"
        case LIST_LURE: return "Select Lure"
        default: return "Select Trap Status"
        }
    }
    
    func listPicker(_ listPicker: ListPickerView, itemTextAt index: Int) -> String {
        switch listPicker.tag {
        case LIST_SPECIES: return self.currentVisit?.trap?.type?.catchableSpecies[index].name ?? "-"
        case LIST_LURE: return self.currentVisit?.trap?.type?.availableLures[index].name ?? "-"
        default: return TrapStatus.all[index].name
        }
    }
    
    func listPicker(_ listPicker: ListPickerView, itemDetailAt index: Int) -> String? {
        if listPicker.tag == LIST_TRAPSTATUS {
            return TrapStatus.all[index].statusDescription
        } else {
            return nil
        }
    }
    
    func listPicker(_ listPicker: ListPickerView, didSelectItemAt index: Int) {
        
        if listPicker.tag == LIST_SPECIES {
            if let species = self.currentVisit?.trap?.type?.catchableSpecies[index] {
                if let _ = self.currentVisit {
                    self.currentVisit!.catchSpecies = species
                    updateViewForCurrentVisit()
                    saveVisit()
                }
            }
        } else if listPicker.tag == LIST_LURE {
            if let lure = self.currentVisit?.trap?.type?.availableLures[index] {
                if let _ = self.currentVisit {
                    self.currentVisit!.lure = lure
                    updateViewForCurrentVisit()
                    saveVisit()
                }
            }
        } else if listPicker.tag == LIST_TRAPSTATUS {
            self.currentVisit?.trapStatusRaw = TrapStatus.all[index].rawValue
            updateViewForCurrentVisit()
            saveVisit()
        }
    }
}

// MARK: - VisitLog Viper Components
private extension VisitLogPresenter {
    var view: VisitLogViewApi {
        return _view as! VisitLogViewApi
    }
    var interactor: VisitLogInteractorApi {
        return _interactor as! VisitLogInteractorApi
    }
    var router: VisitLogRouterApi {
        return _router as! VisitLogRouterApi
    }
}
