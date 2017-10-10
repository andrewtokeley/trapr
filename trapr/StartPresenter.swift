//
//  StartPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 30/09/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - StartPresenter Class
final class StartPresenter: Presenter {
    
    open override func viewIsAboutToAppear() {
        view.setTitle(title: "Trapr")
        interactor.initialiseHomeModule()
    }

}

// MARK: - NewVisitDelegate
extension StartPresenter: NewVisitDelegate {
    func didSelectTraplines(traplines: [Trapline]) {
        
        let visitSummary = VisitSummary(traplines: traplines, dateOfVisit: Date())
        router.showVisitModule(visitSummary: visitSummary)

    }
}

// MARK: - StartPresenter API
extension StartPresenter: StartPresenterApi {
    
    func didSelectMenu() {
        //menuWireframe.presentView(over: view as! UIViewController)
    }
    
    func didSelectNewVisit() {
        router.showNewVisitModule(delegate: self)
    }
    
    func didSelectVisitSummary(visitSummary: VisitSummary) {
        router.showVisitModule(visitSummary: visitSummary)
    }
    
    func setRecentVisits(visits: [VisitSummary]?) {
        view.displayRecentVisits(visits: visits)
    }

}

// MARK: - Start Viper Components
private extension StartPresenter {
    var view: StartViewApi {
        return _view as! StartViewApi
    }
    var interactor: StartInteractorApi {
        return _interactor as! StartInteractorApi
    }
    var router: StartRouterApi {
        return _router as! StartRouterApi
    }
}
