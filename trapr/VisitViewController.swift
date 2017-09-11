//
//  HomeViewController.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit
import PureLayout

class VisitViewController: UIViewController, VisitViewInterface {
    
    var presenter: VisitPresenter?
    
    //MARK: - VisitViewInterface
    func setTitle(title: String) {
        self.title = title
    }
    
    //MARK: - Events
    
    //MARK: - SubViews
    
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
        
        self.setConstraints()
    }
    
    func setConstraints() {
    }
    
}
