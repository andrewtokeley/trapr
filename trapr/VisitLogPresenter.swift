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
    
    func saveVisit() {
        if let visit = self.currentVisit {
            print("Save visit \(visit.id)")
            interactor.saveVisit(visit: visit)
        }
    }
    
    func updateView() {
        if self.currentVisit != nil {
            view.displayVisit(visit: self.currentVisit!, showCatchSection: self.currentVisit?.trap?.type?.killMethod == .Direct)
        }
    }
}

extension VisitLogPresenter: VisitDelegate {
    
    func didChangeVisit(visit: Visit) {
        
        // take a copy so that visit can be bulk updated
        self.currentVisit = Visit(value: visit)
        
        updateView()
        
    }
    
}

// MARK: - VisitLogPresenter API
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

// MARK: - VisitLogPresenter API
extension VisitLogPresenter: VisitLogPresenterApi {
    
    func didSelectToChangeTime() {
        
        if let _ = self.currentVisit {
            let setupData = DatePickerSetupData()
            setupData.initialDate = self.currentVisit!.visitDateTime
            setupData.delegate = self
            
            router.showDatePicker(setupData: setupData)
        }
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
            router.showListPicker(setupData: setupData)
        }
    }
    
    func didSelectToChangeLure() {
        
        let setupData = ListPickerSetupData()
        setupData.delegate = self
        setupData.tag = LIST_LURE
        setupData.embedInNavController = false
        router.showListPicker(setupData: setupData)
    
    }
}

// MARK: - ListPickerDelegate (Species)
extension VisitLogPresenter: ListPickerDelegate {
    
    func listPicker(title listPicker: ListPickerView) -> String {
        return listPicker.tag == LIST_SPECIES
            ? "Species"
            : "Lure"
    }
    
    func listPicker(numberOfRows listPicker: ListPickerView) -> Int {
        return listPicker.tag == LIST_SPECIES
            ? self.species?.count ?? 0
            : self.currentVisit?.trap?.type?.availableLures.count ?? 0
    }
    
    func listPicker(headerText listPicker: ListPickerView) -> String {
        return listPicker.tag == LIST_SPECIES
            ? "Select Species"
            : "Select Lure"
    }
    
    func listPicker(_ listPicker: ListPickerView, itemTextAt index: Int) -> String {
        return listPicker.tag == LIST_SPECIES
            ? self.species?[index].name ?? "-"
            : self.currentVisit?.trap?.type?.availableLures[index].name ?? "-"
    }
    
    func listPicker(_ listPicker: ListPickerView, didSelectItemAt index: Int) {
        
        if listPicker.tag == LIST_SPECIES {
            if let species = self.species?[index] {
                if let _ = self.currentVisit {
                    self.currentVisit!.catchSpecies = species
                    updateView()
                    saveVisit()
                }
            }
        } else if listPicker.tag == LIST_LURE {
            if let lure = self.currentVisit?.trap?.type?.availableLures[index] {
                if let _ = self.currentVisit {
                    self.currentVisit!.lure = lure
                    updateView()
                    saveVisit()
                }
            }
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
