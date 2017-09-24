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
    
    @IBOutlet weak var stationLabel: UILabel!
    
    @IBOutlet weak var previousStation: UIImageView!
    @IBOutlet weak var nextStation: UIImageView!
    
    var presenter: VisitPresenter?
    
    //MARK: - VisitViewInterface
    
    func setTitle(title: String) {
        self.title = title
    }
    
    func setStationText(text: String) {
        self.stationLabel.text = text
    }
    
    func enableNavigation(previous: Bool, next: Bool) {
        
    }
    //MARK: - Events
    func didSelectPreviousStation(sender: UIImageView) {
        presenter?.didSelectPreviousStation()
    }
    
    func didSelectNextStation(sender: UIImageView) {
        presenter?.didSelectNextStation()
    }
    
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
        
        let previous = UITapGestureRecognizer(target: self, action: #selector(didSelectPreviousStation(sender:)))
        self.previousStation.addGestureRecognizer(previous)
        self.previousStation.isUserInteractionEnabled = true
        
        let next = UITapGestureRecognizer(target: self, action: #selector(didSelectNextStation(sender:)))
        self.nextStation.addGestureRecognizer(next)
        self.nextStation.isUserInteractionEnabled = true
        
        self.setConstraints()
    }
    
    func setConstraints() {
    }
    
}
