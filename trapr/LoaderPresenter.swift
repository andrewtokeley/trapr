//
//  LoaderPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley on 15/01/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - LoaderPresenter Class
final class LoaderPresenter: Presenter {

    fileprivate var delegate: LoaderDelegate?
    
    override func setupView(data: Any) {
        if let setupData = data as? LoaderPresenterSetupData {
            self.delegate = setupData.delegate
        }
    }
    
    override func viewHasAppeared() {
        
        if interactor.needsDataUpdate() {
            view.updateProgressMessage(message: "Just setting a few things up...")
            interactor.checkForDataUpdates()
        } else {
            fade()
        }
    }
    
    fileprivate func fade() {
        view.fade(completion: {
            self._view.dismiss(animated: true, completion: {
                
                self.delegate?.loaderAboutToClose()
                
                self._view.dismiss(animated: true, completion: nil)
            })
        })
    }
}

// MARK: - LoaderPresenter API
extension LoaderPresenter: LoaderPresenterApi {
    
    func importProgressReceived(progress: Float) {
        // the importer stops reporting progress once all the data is read, but there's more work to do to update the database, so
        view.updateProgress(progress: progress * 0.8)
    }
    
    func importCompleted() {
        view.updateProgress(progress: 1)
        fade()
    }
    
}

// MARK: - Loader Viper Components
private extension LoaderPresenter {
    var view: LoaderViewApi {
        return _view as! LoaderViewApi
    }
    var interactor: LoaderInteractorApi {
        return _interactor as! LoaderInteractorApi
    }
    var router: LoaderRouterApi {
        return _router as! LoaderRouterApi
    }
}
