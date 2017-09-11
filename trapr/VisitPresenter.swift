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
    var visit: Visit?
    
    //MARK: - VisitInteractorOutput
    
    //MARK: - VisitModuleInterface
    
    func viewWillAppear() {
        
        interactor?.initialiseVisitModule(visit: visit)
        
        // Date for title
        let title = visit?.date?.string(from: Styles.DATE_FORMAT_LONG) ?? "new"
        view?.setTitle(title: title)
    }
}
