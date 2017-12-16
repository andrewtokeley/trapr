//
//  ProfilePresenter.swift
//  trapr
//
//  Created by Andrew Tokeley on 16/12/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - ProfilePresenter Class
final class ProfilePresenter: Presenter {
    
    fileprivate var profile: Profile!
    
    override func setupView(data: Any) {
        // taking a shallow copy like this allows the object's properties to be updated - Realm doesn't allow this outside of realm.write
        self.profile = Profile(value: interactor.getProfile())
    }

}

// MARK: - ProfilePresenter API
extension ProfilePresenter: ProfilePresenterApi {
    
    func didSelectClose() {
        _view.dismiss(animated: true, completion: nil)
    }
    
    func didUpdateTrapperName(name: String?) {
        self.profile.name = name
        interactor.saveProfile(profile: self.profile)
    }
    
}

// MARK: - Profile Viper Components
private extension ProfilePresenter {
    var view: ProfileViewApi {
        return _view as! ProfileViewApi
    }
    var interactor: ProfileInteractorApi {
        return _interactor as! ProfileInteractorApi
    }
    var router: ProfileRouterApi {
        return _router as! ProfileRouterApi
    }
}
