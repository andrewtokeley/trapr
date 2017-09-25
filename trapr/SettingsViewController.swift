//
//  SettingsViewController.swift
//  trapr
//
//  Created by Andrew Tokeley  on 25/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, SettingsViewInterface {
    
    @IBAction func resetData(_ sender: Any) {
        presenter?.didSelectResetData()
    }
    
    var presenter: SettingsPresenter?
    
    func setTitle(title: String) {
        self.title = title
    }
    
    //MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.viewWillAppear()
        
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.trpBackground
        self.navigationController?.navigationBar.isHidden = false
        
        let rightBarButton = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SettingsViewController.backButtonClicked(sender:)))
        self.navigationItem.rightBarButtonItem = rightBarButton

    }
    
    func backButtonClicked(sender: UIBarButtonItem) {
        presenter?.didSelectClose()
    }
}
