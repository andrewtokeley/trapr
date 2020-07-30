//
//  TrapStatisticsPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley on 14/07/20.
//Copyright © 2020 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - TrapStatisticsPresenter Class
final class TrapStatisticsPresenter: Presenter {
    
    fileprivate var trapStatistics: TrapStatistics?
    fileprivate var killsByDateOrdered = [Dictionary<Date, String>.Element]()
    fileprivate var stationId: String?
    fileprivate var trapDescription: String?
    
}

extension TrapStatisticsPresenter: VisitDelegate {
    
    func didNavigateToTrap(stationId: String, trapDescription: String) {
        self.stationId = stationId
        self.trapDescription = trapDescription
    }
    
    func didRetrieveTrapStatistics(statistics: TrapStatistics?, trapTypeStatistics: TrapTypeStatistics?, showCatchData: Bool) {
        
        if let statistics = statistics, let trapTypeStatistics = trapTypeStatistics {

            self.trapStatistics = statistics
            
            self.killsByDateOrdered = statistics.killsByDate.sorted( by: {$0.key > $1.key } )
            
            self.view.displayStatistics(statistics: statistics, trapTypeStatistics: trapTypeStatistics, showCatchStats: showCatchData)
        }
    }
}

// MARK: - TrapStatisticsPresenter API
extension TrapStatisticsPresenter: TrapStatisticsPresenterApi {
    
    func didSelectToViewCatchDetails() {
        let setupData = ListPickerSetupData()
        setupData.delegate = self
        //setupData.tag = LIST_SPECIES
        setupData.embedInNavController = false
        setupData.includeSelectNone = false
        
        router.showListPicker(setupData: setupData)
    }
    
}

extension TrapStatisticsPresenter: ListPickerDelegate {
    func listPicker(_ listPicker: ListPickerView, itemTextAt index: Int) -> String {
        
        let dictElement = self.killsByDateOrdered[index]
        return dictElement.key.toString(format: Styles.DATE_FORMAT_LONG)
    }
    
    func listPicker(_ listPicker: ListPickerView, itemDetailAt index: Int) -> String? {
        
        let dictElement = self.killsByDateOrdered[index]
        return dictElement.value
    }
    
    func listPickerTitle(_ listPicker: ListPickerView) -> String {
        if let stationId = self.stationId {
            return "Catch History - \(stationId)"
        }
        return "Catch History"
    }
    
    func listPickerHeaderText(_ listPicker: ListPickerView) -> String {
        if let trapDescription = self.trapDescription {
            return trapDescription
        }
        return "Catches"
    }
    
    func listPickerNumberOfRows(_ listPicker: ListPickerView) -> Int {
        self.trapStatistics?.killsByDate.count ?? 0
    }

    func listPickerCellStyle(_ listPicker: ListPickerView) -> UITableViewCell.CellStyle {
        return .value1
    }
    
}

// MARK: - TrapStatistics Viper Components
private extension TrapStatisticsPresenter {
    var view: TrapStatisticsViewApi {
        return _view as! TrapStatisticsViewApi
    }
    var interactor: TrapStatisticsInteractorApi {
        return _interactor as! TrapStatisticsInteractorApi
    }
    var router: TrapStatisticsRouterApi {
        return _router as! TrapStatisticsRouterApi
    }
}
