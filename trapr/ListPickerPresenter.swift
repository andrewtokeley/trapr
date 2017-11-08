//
//  ListPickerPresenter.swift
//  trapr
//
//  Created by Andrew Tokeley  on 3/11/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import Viperit

// MARK: - ListPickerPresenter Class
final class ListPickerPresenter: Presenter {
    
    var setupData: ListPickerSetupData?
    
    open override func setupView(data: Any) {
        
        setupData = data as? ListPickerSetupData
        
        if let _ = setupData {
            view.setTag(tag: setupData!.tag)
            
            // pass the delegate on to the view
            let displayData = view._displayData as? ListPickerDisplayData
            displayData?.delegate = setupData!.delegate
        }
        
    }
    
}

// MARK: - ListPickerPresenter API
extension ListPickerPresenter: ListPickerPresenterApi {
    
    func didSelectItem(row: Int) {
        
        setupData?.delegate?.listPicker(_view as! ListPickerView, didSelectItemAtRow: row)
        
        // close the view
        _view.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - ListPicker Viper Components
private extension ListPickerPresenter {
    var view: ListPickerViewApi {
        return _view as! ListPickerViewApi
    }
    var interactor: ListPickerInteractorApi {
        return _interactor as! ListPickerInteractorApi
    }
    var router: ListPickerRouterApi {
        return _router as! ListPickerRouterApi
    }
}
