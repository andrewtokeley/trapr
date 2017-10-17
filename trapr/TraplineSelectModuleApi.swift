//
//  TraplineSelectModuleApi.swift
//  trapr
//
//  Created by Andrew Tokeley  on 2/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Viperit

//MARK: - TraplineSelectRouter API
protocol TraplineSelectRouterApi: RouterProtocol {
    func showStationSelect(traplines: [Trapline])
}

//MARK: - TraplineSelectView API
protocol TraplineSelectViewApi: UserInterfaceProtocol {
    
    func setTitle(title: String)
    func setSelectedTraplinesDescription(description: String)
    func updateDisplay(traplines: [Trapline])
    func setNextButtonState(enabled: Bool)
    
}

//MARK: - TraplineSelectPresenter API
protocol TraplineSelectPresenterApi: PresenterProtocol {
    
    func didSelectTrapline(trapline: Trapline)
    func didDeselectTrapline(trapline: Trapline)
    func didSelectNext()
    
}

//MARK: - TraplineSelectInteractor API
protocol TraplineSelectInteractorApi: InteractorProtocol {

    func getAllTraplines() -> [Trapline]?
}
