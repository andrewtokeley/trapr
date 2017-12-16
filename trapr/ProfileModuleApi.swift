//
//  ProfileModuleApi.swift
//  trapr
//
//  Created by Andrew Tokeley on 16/12/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Viperit

//MARK: - ProfileRouter API
protocol ProfileRouterApi: RouterProtocol {
}

//MARK: - ProfileView API
protocol ProfileViewApi: UserInterfaceProtocol {
    func setTitle(title: String?)
    func displayTrapperName(name: String)
    func setFocusToRouteName()
}

//MARK: - ProfilePresenter API
protocol ProfilePresenterApi: PresenterProtocol {
    func didSelectClose()
    func didUpdateTrapperName(name: String?)
}

//MARK: - ProfileInteractor API
protocol ProfileInteractorApi: InteractorProtocol {
    func saveProfile(profile: Profile)
    func getProfile() -> Profile
}
