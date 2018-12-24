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
    
    var delegate: VisitLogDelegate?
    
    fileprivate var currentVisit: _Visit?
    
    fileprivate var species: [_Species]?
    fileprivate var lures: [_Lure]?
    fileprivate var trapTypes = [_TrapType]()
    
    fileprivate let LIST_SPECIES = 0
    fileprivate let LIST_LURE = 1
    fileprivate let LIST_TRAP_OPERATING_STATUS = 2
    fileprivate let LIST_TRAP_SET_STATUS = 3
    
    var currentTrapType: _TrapType? {
        return self.trapTypes.filter({ $0.id ==  self.currentVisit!.trapTypeId }).first
    }
    
    func initialisePresenter(completion: (() -> Void)?) {
        // make sure we have a reference to the traptypes - needed for display etc.
        if self.trapTypes.count == 0 {
            interactor.retrieveTrapTypes { (trapTypes) in
                self.trapTypes = trapTypes
                completion?()
            }
        } else {
            completion?()
        }
    }

    func saveVisit() {
        if let visit = self.currentVisit {
            interactor.saveVisit(visit: visit)
        }
    }
    
    func updateViewForCurrentVisit() {
        
        if let visit = self.currentVisit {
            if let trap = self.trapTypes.first(where: { $0.id == visit.trapTypeId }) {
                
                // if this is a poison trap then display balance of lures
                if trap.id == TrapTypeCode.pellibait.rawValue {
                    
                    // get the balance from the day before the visit (assumes only one visit per day)
                    interactor.getLureBalance(stationId: visit.stationId, trapTypeId: visit.trapTypeId, asAtDate: visit.visitDateTime.add(-1, 0, 0)) { (balance) in
                        
                        let message = "Balance at last visit, \(balance)."
                        self.view.displayLureBalanceMessage(message: message)
                        self.view.displayVisit(visit: visit, showCatchSection: trap.killMethod == .direct)
                    }
                    
                } else {
                    self.view.displayLureBalanceMessage(message: "")
                    self.view.displayVisit(visit: visit, showCatchSection: trap.killMethod == .direct)
                }
                
                
                
            }
            
        }
    }
    
}

//MARK: - VisitDelegate

extension VisitLogPresenter: VisitDelegate {

    func editVisit(visit: _Visit) {
        
    }
    
    func didChangeVisit(visit: _Visit?) {
        
        // this is the first entry point to the presenter, so let's make sure we have things set up
        self.initialisePresenter {
            
            // before navigating to another visit, make sure active textfields stop editing (like comments)
            self.view.endEditing()
            
            if let _ = visit {
                self.currentVisit = visit
                self.updateViewForCurrentVisit()
            } else {
                self.view.displayNoVisitState()
            }
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
    
    func didSelectToChangeTrapOperatingStatus() {
        let setupData = ListPickerSetupData()
        setupData.delegate = self
        setupData.tag = LIST_TRAP_OPERATING_STATUS
        setupData.embedInNavController = false
        setupData.includeSelectNone = false
        
        router.showListPicker(setupData: setupData)
    }
    
    func didSelectToChangeTrapSetStatus() {
        let setupData = ListPickerSetupData()
        setupData.delegate = self
        setupData.tag = LIST_TRAP_SET_STATUS
        setupData.embedInNavController = false
        setupData.includeSelectNone = false
        
        router.showListPicker(setupData: setupData)
    }
    
    func didSelectToChangeSpecies() {
        
        if self.species == nil {
            interactor.retrieveSpeciesList {
                (species) in
                self.species = species
                self.didSelectToChangeSpecies()
            }
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
        delegate?.didSelectToCreateNewVisit()
    }
    
    func didSelectToRemoveVisit() {
        
        // the delegate (Visit module) is responsible for managing the current visit
        self.delegate?.didSelectToRemoveVisit()
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
    
    func didUpdateComment(text: String?) {
        self.currentVisit?.notes = text
        saveVisit()
    }
}

// MARK: - ListPickerDelegate (Species)
extension VisitLogPresenter: ListPickerDelegate {
    
    func listPickerTitle(_ listPicker: ListPickerView) -> String {
        switch listPicker.tag {
            case LIST_SPECIES: return "Species"
            case LIST_LURE: return "Lure"
            case LIST_TRAP_SET_STATUS: return "Set status"
            default: return "Trap operating status"
        }
    }
    
    func listPickerNumberOfRows(_ listPicker: ListPickerView) -> Int {
        switch listPicker.tag {
            case LIST_SPECIES: return currentTrapType?.catchableSpecies?.count ?? 0
            case LIST_LURE: return currentTrapType?.availableLures?.count ?? 0
            case LIST_TRAP_SET_STATUS: return TrapSetStatus.count
            default: return TrapOperatingStatus.count
        }
    }
    
    func listPickerHeaderText(_ listPicker: ListPickerView) -> String {
        switch listPicker.tag {
            case LIST_SPECIES: return "Select Species"
            case LIST_LURE: return "Select Lure"
            case LIST_TRAP_SET_STATUS: return "Set Status"
            default: return "Select Operating Status"
        }
    }
    
    func listPicker(_ listPicker: ListPickerView, itemTextAt index: Int) -> String {
        
        // TODO need a way of getting from speciesId to name
        switch listPicker.tag {
            case LIST_SPECIES: return self.currentTrapType?.catchableSpecies?[index] ?? "-"
            case LIST_LURE: return self.currentTrapType?.availableLures?[index] ?? "-"
            case LIST_TRAP_SET_STATUS: return TrapSetStatus.all[index].name
            default: return TrapOperatingStatus.all[index].name
        }
    }
    
    func listPicker(_ listPicker: ListPickerView, itemDetailAt index: Int) -> String? {
        if listPicker.tag == LIST_TRAP_OPERATING_STATUS {
            return TrapOperatingStatus.all[index].statusDescription
        } else {
            return nil
        }
    }
    
    func listPickerDidSelectNoSelection(_ listPicker: ListPickerView) {
        
        if let _ = self.currentVisit {
            if listPicker.tag == LIST_SPECIES {
                self.currentVisit?.speciesId = nil
            } else if listPicker.tag == LIST_LURE {
                self.currentVisit?.lureId = nil
            }
            updateViewForCurrentVisit()
            saveVisit()
        }
    }
    
    func listPicker(_ listPicker: ListPickerView, isSelected index: Int) -> Bool {
        if listPicker.tag == LIST_SPECIES {
            return self.currentTrapType?.catchableSpecies?[index] == self.currentVisit?.speciesId
        }
        if listPicker.tag == LIST_LURE {
            return self.currentTrapType?.availableLures?[index] == self.currentVisit?.lureId
        }
        if listPicker.tag == LIST_TRAP_SET_STATUS {
            // TODO - model trapsetstatus
            //return TrapSetStatus.all[index] == self.currentVisit?.trapSetStatusId
        }
        if listPicker.tag == LIST_TRAP_OPERATING_STATUS {
            // TODO - model trapoperatingstatus
            //return TrapOperatingStatus.all[index] == self.currentVisit?.trapOperatingStatus
        }
        return false
    }
    
    func listPicker(_ listPicker: ListPickerView, didSelectItemAt index: Int) {
        
        if listPicker.tag == LIST_SPECIES {
            if let speciesId = self.currentTrapType?.catchableSpecies?[index] {
                if let _ = self.currentVisit {
                    self.currentVisit?.speciesId = speciesId
                    updateViewForCurrentVisit()
                    saveVisit()
                }
            }
        } else if listPicker.tag == LIST_LURE {
            if let lureId = self.currentTrapType?.availableLures?[index] {
                if let _ = self.currentVisit {
                    self.currentVisit!.lureId = lureId
                    updateViewForCurrentVisit()
                    saveVisit()
                }
            }
        } else if listPicker.tag == LIST_TRAP_OPERATING_STATUS {
//            self.currentVisit?.trapOperatingStatusRaw = TrapOperatingStatus.all[index].rawValue
//            updateViewForCurrentVisit()
//            saveVisit()
        } else if listPicker.tag == LIST_TRAP_SET_STATUS {
//            self.currentVisit?.trapSetStatusRaw = TrapSetStatus.all[index].rawValue
//            updateViewForCurrentVisit()
//            saveVisit()
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
