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
    
    var setupData: ListPickerSetupData!
    var selectedIndices = [Int]()
    
    open override func setupView(data: Any) {
        
        setupData = data as? ListPickerSetupData
        
        if let _ = setupData {
            view.setTag(tag: setupData!.tag)
            view.showDoneButton(show: setupData.allowMultiselect)
            view.showCloseButton(show: setupData.embedInNavController)
            view.setTitle(title: setupData!.delegate?.listPicker(title: _view as! ListPickerView) ?? "")
            
            // pass the delegate on to the view
            let displayData = view._displayData as? ListPickerDisplayData
            displayData?.delegate = setupData!.delegate
        }
        
    }
    
    private func isRootListPicker(viewController: UIViewController) -> Bool {
        
        if viewController.isModal {
            return true // must be the Root since only root listpickers can be presented modally, child listpickers are always on the navigation stack
        } else {
           
            // it's the root if it's parent on the stack is not a ListPicker
            // get the view controller that pushed this listpicker
            if let indexOfViewController = viewController.navigationController?.viewControllers.index(of: viewController) {
                if indexOfViewController == 0 {
                    // this is the only viewcontroller on the navigation stack, so is the root
                    return true
                } else {
                    let previousViewController = viewController.navigationController?.viewControllers[indexOfViewController - 1]
                    
                    return (previousViewController as? ListPickerView) == nil
                }
            } else {
                // I don't think this is possible. If the viewcontroller isn't modal then it must be somewhere on the navigation stack
                return false
            }
            
        }
    }
    
    private func closeRootListPickerViewController(root: UIViewController) {
        if root.isModal {
            root.navigationController?.dismiss(animated: false, completion: nil)
        } else {
            root.navigationController?.popViewController(animated: true)
        }
    }
    
    private func closeAllListPickerViewControllers() {
        
        var keepGoing = true
        
        let nc = _view.navigationController
        
        while keepGoing {
            
            if let vc = nc?.viewControllers.last as? ListPickerView {
                if isRootListPicker(viewController: vc) {
                    closeRootListPickerViewController(root: vc)
                    keepGoing = false
                } else {
                    // must be a child listpicker
                    nc?.popViewController(animated: false)
                }
            } else {
                keepGoing = false
            }
        }
        
    }
    
    fileprivate func processFinalSelection() {
        
        if let childSetup = setupData.childSetupData {
            
            // navigate to the next child listPicker
            router.showChildListPicker(setupData: childSetup)
            
        } else {
            closeAllListPickerViewControllers()
        }
    }
    
    
}

// MARK: - ListPickerPresenter API
extension ListPickerPresenter: ListPickerPresenterApi {
    
    func didSelectItem(row: Int) {
        
        // if selected already, remove it (it's being deselected from view)
        if let index = selectedIndices.index(of: row) {
            selectedIndices.remove(at: index)
        } else {
            selectedIndices.append(row)
            setupData.delegate?.listPicker(_view as! ListPickerView, didSelectItemAt: row)
        }
        
        view.setSelectedIndices(indices: selectedIndices)
        
        // close the view, if we're in single select mode
        if !setupData.allowMultiselect {
            processFinalSelection()
        }
    }
    
    func didSelectDone() {
        // for multiselect only
        setupData.delegate?.listPicker(_view as! ListPickerView, didSelectMultipleItemsAt: self.selectedIndices)
        processFinalSelection()
    }
    
    func didSelectClose() {
        
        _view.navigationController?.dismiss(animated: false, completion: nil)
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

// TESTING
extension UIViewController {
    var isModal: Bool {
        if let index = navigationController?.viewControllers.index(of: self), index > 0 {
            return false
        } else if presentingViewController != nil {
            return true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController  {
            return true
        } else if tabBarController?.presentingViewController is UITabBarController {
            return true
        } else {
            return false
        }
    }
}