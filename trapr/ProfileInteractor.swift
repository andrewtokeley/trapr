//
//  ProfileInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley on 16/12/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - ProfileInteractor Class
final class ProfileInteractor: Interactor {
}

// MARK: - ProfileInteractor API
extension ProfileInteractor: ProfileInteractorApi {
    
    func saveProfile(profile: Profile) {
        
    }
    
    func getProfile() -> Profile {
        //ServiceFactory.sharedInstance.pr
        return Profile()
    }
}

// MARK: - Interactor Viper Components Api
private extension ProfileInteractor {
    var presenter: ProfilePresenterApi {
        return _presenter as! ProfilePresenterApi
    }
}
