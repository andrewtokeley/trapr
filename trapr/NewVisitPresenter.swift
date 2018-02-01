//
//  NewVisitPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 7/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - NewVisitPresenter Class
final class NewVisitPresenter: Presenter {
    
    fileprivate var delegate: NewVisitDelegate?
    
    override func setupView(data: Any) {
        if let delegate = data as? NewVisitDelegate {
            self.delegate = delegate
        }
    }
    
    override func viewHasLoaded() {
        _view.setTitle(title: "New Visit")
        interactor.fetchRecentRoutes()
    }

}

// MARK: - NewVisitPresenter API
extension NewVisitPresenter: TraplineSelectDelegate {
    
//    func didSelectTraplines(traplines: [Trapline]) {
//        
//        _view.dismiss(animated: true, completion: nil)
//    }
//
    
    func didUpdateRoute(route: Route) {
        // can ignore - may be getting rid of NewVisitModule
    }
    
    func didCreateRoute(route: Route) {
        delegate?.didSelectRoute(route: route)
        _view.dismiss(animated: true, completion: nil)
    }
}

// MARK: - NewVisitPresenter API
extension NewVisitPresenter: NewVisitPresenterApi {
    
//    func didFetchRecentVisits(visitSummaries: [VisitSummary]?) {
//        view.displayRecentVisits(visitSummaries: visitSummaries)
//    }
//
    func didFetchRecentRoutes(routes: [Route]?) {
        view.displayRecentRoutes(routes: routes)
    }

    func didSelectRecentRoute(route: Route) {
        
        //tell the delegate and close module
        delegate?.didSelectRoute(route: route)
        _view.dismiss(animated: true, completion: nil)
    }
    
    func didSelectOther() {
        router.showTrapLineSelectModule(delegate: self)
    }
    
    func didSelectCloseButton() {
        _view.dismiss(animated: true, completion: nil)
    }

    func didSelectDeleteRoute(route: Route) {
        ServiceFactory.sharedInstance.routeService.delete(route: route)
        interactor.fetchRecentRoutes()
    }
}

// MARK: - NewVisit Viper Components
private extension NewVisitPresenter {
    var view: NewVisitViewApi {
        return _view as! NewVisitViewApi
    }
    var interactor: NewVisitInteractorApi {
        return _interactor as! NewVisitInteractorApi
    }
    var router: NewVisitRouterApi {
        return _router as! NewVisitRouterApi
    }
}

protocol NewVisitDelegate {
    func didSelectRoute(route: Route)
}

