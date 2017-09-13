//
//  HomePresenter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class VisitPresenter: VisitInteractorOutput, VisitModuleInterface {
    
    var view: VisitViewInterface?
    var interactor: VisitInteractorInput?
    
    var dateOfVisit: Date!
    
    //MARK: - VisitInteractorOutput
    
    //MARK: - VisitModuleInterface
    
    func viewWillAppear() {
        
        interactor?.initialiseVisitModule(dateOfVisit: self.dateOfVisit)
        
        // Date for title
        let date = dateOfVisit ?? Date()
        let title = date.string(from: Styles.DATE_FORMAT_LONG)
        view?.setTitle(title: title)
    }
}
