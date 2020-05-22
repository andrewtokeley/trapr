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
    
    fileprivate var currentVisit: Visit?
    fileprivate var balanceOfCurrentTrap: Int?
    
    fileprivate var species: [Species]?
    fileprivate var catchableSpecies: [Species]?
    
    fileprivate var lures: [Lure]?
    fileprivate var availableLures: [Lure]?
    
    fileprivate var trapTypes = [TrapType]()
    
    fileprivate let LIST_SPECIES = 0
    fileprivate let LIST_LURE = 1
    fileprivate let LIST_TRAP_OPERATING_STATUS = 2
    fileprivate let LIST_TRAP_SET_STATUS = 3
    
    var currentTrapType: TrapType? {
        return self.trapTypes.filter({ $0.id ==  self.currentVisit!.trapTypeId }).first
    }
    
    func initialisePresenter(completion: (() -> Void)?) {
        // make sure we have a reference to the traptypes - needed for display etc.
        if self.trapTypes.count == 0 {
            
            interactor.retrieveLookups { (trapTypes, lures, species) in
                self.trapTypes = trapTypes
                self.lures = lures
                self.species = species
                completion?()
            }
        } else {
            completion?()
        }
    }

    //MARK: - Stepper functions
    
    func  updateStepperMaximumValues() {
        
        // make sure the total of eaten and removed doesn't exceed the balance
        if let visit = self.currentVisit {
            if let trap = self.trapTypes.first(where: { $0.id == visit.trapTypeId }) {
                if let balance = self.balanceOfCurrentTrap {
                    
                    let totalRemoved = visit.baitEaten + visit.baitRemoved
                    
                    // can't remove more than was in there to begin with
                    if totalRemoved >= balance {
                        self.view.setMaxSteppers(eaten: visit.baitEaten, removed: visit.baitRemoved, added: trap.maxLures - ( balance - totalRemoved))
                    } else {
                        // default
                        self.view.setMaxSteppers(eaten: balance, removed: balance, added: trap.maxLures - ( balance - totalRemoved))
                    }
                    
                    if visit.baitAdded > trap.maxLures - ( balance - totalRemoved) {
                        visit.baitAdded = trap.maxLures - ( balance - totalRemoved)
                        
                    }
                    
                    let newBalance = balance + visit.baitAdded - (visit.baitEaten + visit.baitRemoved)
                    view.displayLureOpeningBalance(balance: balance)
                    view.displayLureClosingBalance(balance: newBalance, isOutOfRange: newBalance > trap.maxLures || newBalance < 0)
                }
            }
        }
    }
    
    //MARK: - Other
    
    func saveVisit() {
        if let visit = self.currentVisit {
            interactor.saveVisit(visit: visit)
        }
    }
    
    
    
    func updateViewForCurrentVisit() {
        
        if let visit = self.currentVisit {
            
            // Create a VM from the visit, with lure and species names
            let visitViewModel = VisitViewModel(visit: visit)
            
            // Get the lureId defined on the visit or the default for the trapType
            let lureId = visitViewModel.lureId ?? self.trapTypes.first( where: { $0.id == visitViewModel.trapTypeId })?.defaultLure
            visitViewModel.lureName = self.lures?.first(where: { $0.id == lureId })?.name
            
            // Based on the traptype define the availableLures
            if let availableLuresIds = self.currentTrapType?.availableLures {
                self.availableLures = self.lures?.filter( { availableLuresIds.contains($0.id!) })
            }
            if let catchableSpeciesIds = self.currentTrapType?.catchableSpecies {
                self.catchableSpecies = self.species?.filter( { catchableSpeciesIds.contains($0.id!) })
            }
            
            visitViewModel.speciesName = self.species?.first(where: { $0.id == visitViewModel.speciesId })?.name
                
            if let trap = self.trapTypes.first(where: { $0.id == visit.trapTypeId }) {
                
                // if this is a poison trap then display balance of lures
                if trap.id == TrapTypeCode.pellibait.rawValue {
                    
                    // get the balance from the day before the visit (assumes only one visit per day)
                    self.interactor.getLureBalance(stationId: visit.stationId, trapTypeId: visit.trapTypeId, asAtDate: visit.visitDateTime.add(-1, 0, 0)) { (balance) in
                        
                        self.balanceOfCurrentTrap = balance
                        self.view.displayLureOpeningBalance(balance: balance)
                        
                        self.view.displayVisit(visit: visitViewModel, showCatchSection: trap.killMethod == .direct)
                        
                        self.updateStepperMaximumValues()
                    }
                    
                } else {
                    // assume there's always 1 in there for now
                    self.balanceOfCurrentTrap = 1
                    self.view.displayLureOpeningBalance(balance: 0)
                    self.view.displayVisit(visit: visitViewModel, showCatchSection: trap.killMethod == .direct)
                    self.updateStepperMaximumValues()
                }
            }
        }
    }
}

//MARK: - VisitDelegate

extension VisitLogPresenter: VisitDelegate {

    func editVisit(visit: Visit) {
        
    }
    
    func didChangeVisit(visit: Visit?) {
        
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
    
    func displayMode(_ datePicker: DatePickerViewApi) -> UIDatePicker.Mode {
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
        self.updateStepperMaximumValues()
    }
    
    func didUpdateBaitEatenValue(newValue: Int) {
        self.currentVisit?.baitEaten = newValue
        saveVisit()
        self.updateStepperMaximumValues()
        
    }
    
    func didUpdateBaitRemovedValue(newValue: Int) {
        self.currentVisit?.baitRemoved = newValue
        saveVisit()
        self.updateStepperMaximumValues()
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
            case LIST_SPECIES: return self.catchableSpecies?.count ?? 0
            case LIST_LURE: return self.availableLures?.count ?? 0
            case LIST_TRAP_SET_STATUS: return TrapSetStatus.count
            default: return TrapOperatingStatus.count
        }
    }
    
    func listPickerHeaderText(_ listPicker: ListPickerView) -> String {
        switch listPicker.tag {
            case LIST_SPECIES: return "Species"
            case LIST_LURE: return "Lure"
            case LIST_TRAP_SET_STATUS: return "Set Status"
            default: return "Operating Status"
        }
    }
    
    func listPicker(_ listPicker: ListPickerView, itemTextAt index: Int) -> String {
        
        // TODO need a way of getting from speciesId to name
        switch listPicker.tag {
            //case LIST_SPECIES: return self.currentTrapType?.catchableSpecies?[index] ?? "-"
            case LIST_SPECIES: return self.catchableSpecies?[index].name ?? "-"
            //case LIST_LURE: return self.currentTrapType?.availableLures?[index] ?? "-"
            case LIST_LURE: return self.availableLures?[index].name ?? "-"
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
                self.currentVisit?.trapSetStatusId = TrapSetStatus.stillSet.rawValue
            } else if listPicker.tag == LIST_LURE {
                self.currentVisit?.lureId = nil
            }
            updateViewForCurrentVisit()
            saveVisit()
        }
    }
    
    func listPicker(_ listPicker: ListPickerView, isSelected index: Int) -> Bool {
        if listPicker.tag == LIST_SPECIES {
            return self.catchableSpecies?[index].id == self.currentVisit?.speciesId
        }
        if listPicker.tag == LIST_LURE {
            return self.availableLures?[index].id == self.currentVisit?.lureId
        }
        if listPicker.tag == LIST_TRAP_SET_STATUS {
            return TrapSetStatus.all[index].rawValue == self.currentVisit?.trapSetStatusId
        }
        if listPicker.tag == LIST_TRAP_OPERATING_STATUS {
            return TrapOperatingStatus.all[index].rawValue == self.currentVisit?.trapOperatingStatusId
        }
        return false
    }
    
    func listPicker(_ listPicker: ListPickerView, didSelectItemAt index: Int) {
        
        if listPicker.tag == LIST_SPECIES {
            if let speciesId = self.catchableSpecies?[index].id {
                self.currentVisit?.speciesId = speciesId
                self.currentVisit?.trapSetStatusId = nil
                updateViewForCurrentVisit()
                saveVisit()
            }
        } else if listPicker.tag == LIST_LURE {
            if let lureId = self.availableLures?[index].id {
                self.currentVisit!.lureId = lureId
                updateViewForCurrentVisit()
                saveVisit()
            }
        } else if listPicker.tag == LIST_TRAP_OPERATING_STATUS {
            self.currentVisit?.trapOperatingStatusId = TrapOperatingStatus.all[index].rawValue
            updateViewForCurrentVisit()
            saveVisit()
        } else if listPicker.tag == LIST_TRAP_SET_STATUS {
            self.currentVisit?.trapSetStatusId = TrapSetStatus.all[index].rawValue
            self.currentVisit?.speciesId = nil
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
