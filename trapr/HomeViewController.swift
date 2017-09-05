//
//  HomeViewController.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController, HomeViewInterface {
    
    var presenter: HomePresenter?
    
    //MARK: - HomeViewInterface
    
    func displayRecentVisits() {
        
    }
    
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
        
        self.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.isHidden = false
        
        //self.view.addSubview(...)
        
        self.setConstraints()
        
        //presenter?.viewDidLoad()
    }
    
    func setConstraints() {
        
    }
}
