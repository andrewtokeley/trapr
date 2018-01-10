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
    fileprivate var species: [Species]?
    fileprivate var lures: [Lure]?
    
    fileprivate let LIST_SPECIES = 0
    fileprivate let LIST_LURE = 1
    fileprivate let LIST_TRAP_OPERATING_STATUS = 2
    fileprivate let LIST_TRAP_SET_STATUS = 3
    
    func saveVisit() {
        if let visit = self.currentVisit {
            let _ = interactor.saveVisit(visit: visit)
        }
    }
    
    func updateViewForCurrentVisit() {
        if let visit = self.currentVisit {
            
            if let trap = visit.trap {
                if let killMethod = trap.type?.killMethod {
                
                    view.displayVisit(visit: visit, showCatchSection: killMethod == .direct)
                    
                    // if this is a poison trap then display balance of lures
                    if trap.type!.code == TrapTypeCode.pellibait.rawValue {
                        
                        // get the balance from the day before the visit (assumes only one visit per day)
                        let balance = ServiceFactory.sharedInstance.trapService.getLureBalance(trap: trap, asAtDate: visit.visitDateTime.add(-1, 0, 0))
                        
                        let message = "Balance at last visit, \(balance)."
                        view.displayLureBalanceMessage(message: message)
                    } else {
                        view.displayLureBalanceMessage(message: "")
                    }
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
        
        // before navigating to another visit, make sure active textfields stop editing (like comments)
        view.endEditing()
        
        // take a copy so that visit properties can be bulk updated outside realm.write
        if let _ = visit {
            self.currentVisit = Visit(value: visit!)
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
//            if let species = self.currentVisit?.catchSpecies  {
//                if let selected = self.species?.index(of: species) {
//                    setupData.selectedIndicies.append(selected)
//                }
//            } else {
//                // select the None selected option
//                setupData.selectedIndicies.append(0)
//            }
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
        case LIST_SPECIES: return self.currentVisit?.trap?.type?.catchableSpecies.count ?? 0
        case LIST_LURE: return self.currentVisit?.trap?.type?.availableLures.count ?? 0
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
        switch listPicker.tag {
        case LIST_SPECIES: return self.currentVisit?.trap?.type?.catchableSpecies[index].name ?? "-"
        case LIST_LURE: return self.currentVisit?.trap?.type?.availableLures[index].name ?? "-"
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
                self.currentVisit!.catchSpecies = nil
            } else if listPicker.tag == LIST_LURE {
                self.currentVisit!.lure = nil
            }
            updateViewForCurrentVisit()
            saveVisit()
        }
    }
    
    func listPicker(_ listPicker: ListPickerView, isSelected index: Int) -> Bool {
        if listPicker.tag == LIST_SPECIES {
            return self.currentVisit?.trap?.type?.catchableSpecies[index] == self.currentVisit?.catchSpecies
        }
        if listPicker.tag == LIST_LURE {
            return self.currentVisit?.trap?.type?.availableLures[index] == self.currentVisit?.lure
        }
        if listPicker.tag == LIST_TRAP_SET_STATUS {
            return TrapSetStatus.all[index] == self.currentVisit?.trapSetStatus
        }
        if listPicker.tag == LIST_TRAP_OPERATING_STATUS {
            return TrapOperatingStatus.all[index] == self.currentVisit?.trapOperatingStatus
        }
        return false
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
        } else if listPicker.tag == LIST_TRAP_OPERATING_STATUS {
            self.currentVisit?.trapOperatingStatusRaw = TrapOperatingStatus.all[index].rawValue
            updateViewForCurrentVisit()
            saveVisit()
        } else if listPicker.tag == LIST_TRAP_SET_STATUS {
            self.currentVisit?.trapSetStatusRaw = TrapSetStatus.all[index].rawValue
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
