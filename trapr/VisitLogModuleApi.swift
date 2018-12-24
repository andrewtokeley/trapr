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
    func displayVisit(visit: _Visit, showCatchSection: Bool)
    func displayDateTime(date: Date)
    func displaySpecies(name: String)
    func displayNoVisitState()
    func displayLureBalanceMessage(message: String)
    func endEditing()
    //func setVisitLogScrollViewDelegate(delegate: VisitLogDelegate)
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
    func retrieveTrapTypes(completion: (([_TrapType]) -> Void)? )
    func retrieveSpeciesList(completion: (([_Species]) -> Void)? )
    func retrieveLuresList(completion: (([_Lure]) -> Void)? )
    func saveVisit(visit: _Visit)
    func getLureBalance(stationId: String, trapTypeId: String, asAtDate: Date, completion: ((Int) -> Void)?)
}
