//
//  VisitView.swift
//  trapr
//
//  Created by Andrew Tokeley  on 2/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import UIKit
import Viperit

//MARK: VisitView Class
final class VisitView: UserInterface, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var trapTypeCollectionView: UICollectionView!
    
    @IBOutlet weak var previousStation: UIImageView!
    @IBOutlet weak var nextStation: UIImageView!
    
    var currentTraps: [Trap]?
    
    let TRAPTYPE_REUSE_ID = "cell"
    
    //MARK: - Events
    func didSelectPreviousStation(sender: UIImageView) {
        presenter.didSelectPreviousStation()
    }
    
    func didSelectNextStation(sender: UIImageView) {
        presenter.didSelectNextStation()
    }
    
    func didSelectStation(sender: UILabel) {
        presenter.didSelectStation()
    }
    
    //MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentTraps?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.TRAPTYPE_REUSE_ID, for: indexPath) as! ImageCollectionViewCell
        
        if let trap = self.currentTraps?[indexPath.row] {
            cell.image.image = UIImage(named: "menu")
            cell.image.highlightedImage = UIImage(named: "plus")
            cell.label.text = trap.type?.name
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.trpBackground
        self.navigationController?.navigationBar.isHidden = false
        
        let previous = UITapGestureRecognizer(target: self, action: #selector(didSelectPreviousStation(sender:)))
        self.previousStation.addGestureRecognizer(previous)
        self.previousStation.isUserInteractionEnabled = true
        self.previousStation.backgroundColor = UIColor.trpBackground
        
        let next = UITapGestureRecognizer(target: self, action: #selector(didSelectNextStation(sender:)))
        self.nextStation.addGestureRecognizer(next)
        self.nextStation.isUserInteractionEnabled = true
        self.nextStation.backgroundColor = UIColor.trpBackground
        
        let stationLabelTap = UITapGestureRecognizer(target: self, action: #selector(didSelectStation(sender:)))
        self.stationLabel.addGestureRecognizer(stationLabelTap)
        self.stationLabel.isUserInteractionEnabled = true
        
        self.trapTypeCollectionView.register(UINib(nibName:"ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.TRAPTYPE_REUSE_ID)
        
        self.setConstraints()
    }
    
    func setConstraints() {
        
    }
}

//MARK: - VisitView API
extension VisitView: VisitViewApi {
    
    func setTitle(title: String) {
        self.title = title
    }
    
    func setStationText(text: String) {
        self.stationLabel.text = text
    }
    
    func setTraps(traps: [Trap]) {
        currentTraps = traps
        trapTypeCollectionView.reloadData()
    }
    
    func enableNavigation(previous: Bool, next: Bool) {
        
    }
}

// MARK: - VisitView Viper Components API
private extension VisitView {
    var presenter: VisitPresenterApi {
        return _presenter as! VisitPresenterApi
    }
    var displayData: VisitDisplayData {
        return _displayData as! VisitDisplayData
    }
}
