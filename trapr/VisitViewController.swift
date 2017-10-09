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

//class VisitViewController: UIViewController, VisitViewInterface, UICollectionViewDelegate, UICollectionViewDataSource {
//
//    @IBOutlet weak var stationLabel: UILabel!
//    @IBOutlet weak var trapTypeCollectionView: UICollectionView!
//
//    @IBOutlet weak var previousStation: UIImageView!
//    @IBOutlet weak var nextStation: UIImageView!
//
//    var presenter: VisitPresenter?
//    var currentTraps: [Trap]?
//
//    let TRAPTYPE_REUSE_ID = "cell"
//
//    //MARK: - VisitViewInterface
//
//    func setTitle(title: String) {
//        self.title = title
//    }
//
//    func setStationText(text: String) {
//        self.stationLabel.text = text
//    }
//
//    func setTraps(traps: [Trap]) {
//        currentTraps = traps
//        trapTypeCollectionView.reloadData()
//    }
//
//    func enableNavigation(previous: Bool, next: Bool) {
//
//    }
//    //MARK: - Events
//    func didSelectPreviousStation(sender: UIImageView) {
//        presenter?.didSelectPreviousStation()
//    }
//
//    func didSelectNextStation(sender: UIImageView) {
//        presenter?.didSelectNextStation()
//    }
//
//    //MARK: - UICollectionView
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return currentTraps?.count ?? 0
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.TRAPTYPE_REUSE_ID, for: indexPath) as! ImageCollectionViewCell
//
//        if let trap = self.currentTraps?[indexPath.row] {
//            cell.image.image = UIImage(named: "menu")
//            cell.image.highlightedImage = UIImage(named: "plus")
//            cell.label.text = trap.type?.name
//        }
//        return cell
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//    }
//
//    //MARK: - SubViews
//
//    //MARK: - UIViewController
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        presenter?.viewWillAppear()
//    }
//
//    override func loadView() {
//        super.loadView()
//
//        self.view.backgroundColor = UIColor.trpBackground
//        self.navigationController?.navigationBar.isHidden = false
//
//        let previous = UITapGestureRecognizer(target: self, action: #selector(didSelectPreviousStation(sender:)))
//        self.previousStation.addGestureRecognizer(previous)
//        self.previousStation.isUserInteractionEnabled = true
//
//        let next = UITapGestureRecognizer(target: self, action: #selector(didSelectNextStation(sender:)))
//        self.nextStation.addGestureRecognizer(next)
//        self.nextStation.isUserInteractionEnabled = true
//
//        self.trapTypeCollectionView.register(UINib(nibName:"ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: self.TRAPTYPE_REUSE_ID)
//
//        self.setConstraints()
//    }
//
//    func setConstraints() {
//    }
//
//}
