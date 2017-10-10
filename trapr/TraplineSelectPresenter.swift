//
//  TraplineSelectPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 2/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - TraplineSelectPresenter Class
final class TraplineSelectPresenter: Presenter {
    
    fileprivate var delegate: TraplineSelectDelegate?
    fileprivate var selectedTraplines = [Trapline]()
    fileprivate var selectedTraplinesText: String {
        return selectedTraplines.map({ (trapline) -> String in return trapline.code! }).joined(separator: ", ")
    }
    
    private let DELIMMTER = ", "
    
    override func viewIsAboutToAppear() {
        //let recentTraplines = interactor.getRecentTraplines()
        if let traplines = interactor.getAllTraplines() {
            view.updateDisplay(traplines: traplines)
        }
        view.setTitle(title: "New Visit")
        view.setSelectedTraplinesDescription(description: "")
        view.setVisitButtonState(enabled: false)
    }
    
    override func setupView(data: Any) {
        if let data = data as? TraplineSelectDelegate {
            self.delegate = data
        }
    }
}

// MARK: - TraplineSelectPresenter API
extension TraplineSelectPresenter: TraplineSelectPresenterApi {
    
    func didSelectTrapline(trapline: Trapline) {
        self.selectedTraplines.append(trapline)
        view.setSelectedTraplinesDescription(description: selectedTraplinesText)
        view.setVisitButtonState(enabled: true)
    }
    
    func didDeselectTrapline(trapline: Trapline) {
        if let index = selectedTraplines.index(of: trapline) {
            selectedTraplines.remove(at: index)
            if selectedTraplines.count == 0 {
                view.setVisitButtonState(enabled: false)
            }
            view.setSelectedTraplinesDescription(description: selectedTraplinesText)
        }
    }
    
    func didSelectVisitButton() {
        self.delegate?.didSelectTraplines(traplines: selectedTraplines)
        _view.navigationController?.popViewController(animated: true)
    }
}

// MARK: - TraplineSelect Viper Components
private extension TraplineSelectPresenter {
    var view: TraplineSelectViewApi {
        return _view as! TraplineSelectViewApi
    }
    var interactor: TraplineSelectInteractorApi {
        return _interactor as! TraplineSelectInteractorApi
    }
    var router: TraplineSelectRouterApi {
        return _router as! TraplineSelectRouterApi
    }
}
