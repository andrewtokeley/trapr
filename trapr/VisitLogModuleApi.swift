//
//  VisitLogModuleApi.swift
//  trapr
//
//  Created by Andrew Tokeley  on 24/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Viperit

//MARK: - VisitLogRouter API
protocol VisitLogRouterApi: RouterProtocol {
    func showDatePicker(setupData: DatePickerSetupData)
    func showListPicker(setupData: ListPickerSetupData)
    //func showLuresListPicker(setupData: ListPickerSetupData)
}

//MARK: - VisitLogView API
protocol VisitLogViewApi: UserInterfaceProtocol {
    func highlightTrapSetStatusInconsistency(_ isInconsistent: Bool)
    func displayVisit(visit: VisitViewModel, showCatchSection: Bool)
    func displayDateTime(date: Date)
    func displaySpecies(name: String)
    func displayNoVisitState()
    func displayLureOpeningBalance(balance: Int)
    func displayLureClosingBalance(balance: Int, isOutOfRange: Bool)
    func endEditing()
    func setMaxSteppers(eaten: Int, removed: Int, added: Int)
}

//MARK: - VisitLogPresenter API
protocol VisitLogPresenterApi: PresenterProtocol {
    func didSelectToChangeTime()
    func didSelectToChangeSpecies()
    func didSelectToChangeLure()
    func didSelectToChangeTrapOperatingStatus()
    func didSelectToChangeTrapSetStatus()
    func didSelectToRecordVisit()
    func didSelectToRemoveVisit()
    func didUpdateBaitAddedValue(newValue: Int)
    func didUpdateBaitEatenValue(newValue: Int)
    func didUpdateBaitRemovedValue(newValue: Int)
    func didUpdateComment(text: String?)
}

//MARK: - VisitLogInteractor API
protocol VisitLogInteractorApi: InteractorProtocol {
    func retrieveViewModel(visit: Visit, completion: ((VisitViewModel) -> Void)?)
    func getDefaultLureDescription(trapTypeId: String, completion: ((String) -> Void)?)
    func getLureDescription(lureId: String, completion: ((String) -> Void)?)
    func retrieveLookups(completion: (([TrapType], [Lure], [Species]) -> Void)? )
    func retrieveSpeciesList(completion: (([Species]) -> Void)? )
    func retrieveLuresList(completion: (([Lure]) -> Void)? )
    func saveVisit(visit: Visit)
    func getLureBalance(stationId: String, trapTypeId: String, asAtDate: Date, completion: ((Int) -> Void)?)
}
