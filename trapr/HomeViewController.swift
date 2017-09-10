//
//  HomeViewController.swift
//  trapr
//
//  Created by Andrew Tokeley  on 5/09/17.
//  Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController, HomeViewInterface, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let VISITS_CELL_IDENTIFIER = "visits_cell"
    
    var presenter: HomePresenter?
    var visitSummaries: [VisitSummary]?
    
    //MARK: - HomeViewInterface
    
    func displayRecentVisits(visits: [VisitSummary]?) {
        visitSummaries = visits
    }
    
    func setTitle(title: String) {
        self.title = title
    }

    //MARK: - Events
    
    func menuButtonAction(sender: UIBarButtonItem) {
        presenter?.didSelectMenu()
    }

    //MARK: - SubViews
    lazy var closeButtonItem: UIBarButtonItem = {
        
        var view = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(menuButtonAction(sender:)))
        
        return view
    }()
    
    lazy var visitsCollectionView: UICollectionView = {
        
        var view = UICollectionView()
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    //MARK: - UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visitSummaries?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VISITS_CELL_IDENTIFIER, for: indexPath) as! VisitCollectionViewCell
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        if let visitSummary = visitSummaries?[indexPath.row] {
            
            cell.dateOfVisitDescription.text = dateFormatterPrint.string(from: visitSummary.dateOfVisit)
            cell.trapLinesDescription.text = visitSummary.trapLinesDescription
        }
        
        return VisitCollectionViewCell()
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
        
        self.navigationItem.leftBarButtonItem = self.closeButtonItem
        //self.view.addSubview(...)
        
        self.setConstraints()
        
        //presenter?.viewDidLoad()
    }
    
    func setConstraints() {
        
    }
}
