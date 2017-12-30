//
//  MapInteractor.swift
//  trapr
//
//  Created by Andrew Tokeley on 28/12/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - MapInteractor Class
final class MapInteractor: Interactor {
}

// MARK: - MapInteractor API
extension MapInteractor: MapInteractorApi {
}

// MARK: - Interactor Viper Components Api
private extension MapInteractor {
    var presenter: MapPresenterApi {
        return _presenter as! MapPresenterApi
    }
}
