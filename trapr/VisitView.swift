//
//  VisitView.swift
//  trapr
//
//  Created by Andrew Tokeley  on 2/10/17.
//Copyright © 2017 Andrew Tokeley . All rights reserved.
//

import UIKit
import Viperit
import iCarousel

//MARK: VisitView Class
final class VisitView: UserInterface {
    
    fileprivate var CAROUSEL_TRAPS_HEIGHT: CGFloat = 125
    fileprivate var trapCarouselViews = [UIView]()
    fileprivate let CAROUSEL_STATIONS_TAG = 0
    fileprivate let CAROUSEL_STATIONS_LABEL_TAG = 1
    
    fileprivate let CAROUSEL_TRAPS_TAG = 1
    fileprivate let CAROUSEL_TRAPS_IMAGE_TAG = 20
    fileprivate let CAROUSEL_TRAPS_LABEL_TAG = 30
    
    fileprivate let TAG_TRAP_IMAGE = 0
    fileprivate let TAG_TRAP_LABEL = 1
    
    fileprivate var currentTraps: [Trap]?
    fileprivate var stations: [Station]?
    
    fileprivate var lastSelectedStation: Int = -1
    fileprivate var lastSelectedTrap: Int = -1
    
    fileprivate var totalScrollOffset: CGFloat = 0
    fileprivate var previousScrollOffset: CGFloat = 0
    
    let INFINITE_SCROLL_MULTIPLIER = 4
    let TRAPTYPE_REUSE_ID = "cell"
    
    //MARK: - Subviews
    
    lazy var stationsCarousel: iCarousel = {
        let carousel = iCarousel()
        carousel.type = .linear
        carousel.delegate = self
        carousel.dataSource = self
        carousel.bounces = false
        carousel.tag = self.CAROUSEL_STATIONS_TAG
        return carousel
    }()
    
    fileprivate var stationCarouselView: UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 110, height: 30))
        
        let label = UILabel()
        label.font = UIFont.trpLabelLarge
        label.textColor = UIColor.trpTextDark
        label.textAlignment = .center
        label.tag = self.CAROUSEL_STATIONS_LABEL_TAG
        
        view.addSubview(label)
        
        label.autoPinEdgesToSuperviewEdges()

        return view
    }
    
    lazy var dividingLineBetweenStationsAndTraps: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.trpDividerLine
        return view
    }()
    
    lazy var trapsCarousel: iCarousel = {
        let carousel = iCarousel()
        carousel.type = .linear
        carousel.delegate = self
        carousel.bounces = false
        carousel.dataSource = self
        carousel.tag = self.CAROUSEL_TRAPS_TAG
        
        //carousel.backgroundColor = UIColor.red
        return carousel
    }()
    
    fileprivate var trapCarouselView: UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: CAROUSEL_TRAPS_HEIGHT))
        
        let image = UIImageView()
        image.tag = self.CAROUSEL_TRAPS_IMAGE_TAG
        
        let label = UILabel()
        label.font = UIFont.trpTextSmall
        label.textAlignment = .center
        label.numberOfLines = 0
        label.tag = self.CAROUSEL_TRAPS_LABEL_TAG
        
        view.addSubview(image)
        view.addSubview(label)
        
        image.autoPinEdge(toSuperviewEdge: .top, withInset: 0)//LayoutDimensions.smallSpacingMargin)
        image.autoAlignAxis(.vertical, toSameAxisOf: view)
        image.autoSetDimension(.height, toSize: CAROUSEL_TRAPS_HEIGHT/2)
        image.autoMatch(.width, to: .height, of: image)
        
        label.autoPinEdge(.top, to: .bottom, of: image, withOffset: LayoutDimensions.smallSpacingMargin)
        label.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.textIndentMargin)
        label.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.textIndentMargin)
        label.autoSetDimension(.height, toSize: LayoutDimensions.inputHeight)
        label.autoAlignAxis(.vertical, toSameAxisOf: view)
        
        return view
    }
    
    lazy var dividingLineAfterTrapSelector: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.trpBackground
        
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 1
        
        return view
    }()
    
    lazy var visitContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var showMenuButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(named:"show"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(showMoreMenu(sender:)))
        return button
    }()
    
    lazy var titleView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        view.backgroundColor = UIColor.clear
        
        view.addSubview(self.titleLabel)
        view.addSubview(self.subTitleLabel)

        self.titleLabel.autoPinEdge(toSuperviewEdge: .left)
        self.titleLabel.autoPinEdge(toSuperviewEdge: .right)

        self.subTitleLabel.autoPinEdge(toSuperviewEdge: .left)
        self.subTitleLabel.autoPinEdge(toSuperviewEdge: .right)
        self.subTitleLabel.autoPinEdge(.top, to: .bottom, of: self.titleLabel, withOffset: 0)
        
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.trpNavigationBarTint
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        label.font = UIFont.trpText
        
        return label
    }()
    
    lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.trpNavigationBarTint
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        label.font = UIFont.trpTextSmall
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dateTap(sender:)))
        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    //MARK: - Events
    
    func dateTap(sender: UILabel) {
        presenter.didSelectDate()
    }
    
    func showMoreMenu(sender: UIBarButtonItem) {
        presenter.didSelectMenuButton()
    }
    
    // TODO: need a way to navigate to the stations navigation
    func didSelectStation(sender: UILabel) {
        //presenter.didSelectStation()
    }

    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.trpBackground
        self.navigationController?.navigationBar.isHidden = false
        
        self.view.addSubview(self.stationsCarousel)
        self.view.addSubview(self.dividingLineBetweenStationsAndTraps)
        self.view.addSubview(self.trapsCarousel)
        self.view.addSubview(self.visitContainerView)
        self.view.addSubview(self.dividingLineAfterTrapSelector)
        
        self.navigationItem.rightBarButtonItem = self.showMenuButton
        
        self.navigationItem.titleView = titleView

    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        setConstraints()
    }
    
    func setConstraints() {
        
        self.stationsCarousel.autoPin(toTopLayoutGuideOf: self, withInset: LayoutDimensions.spacingMargin)
        self.stationsCarousel.autoPinEdge(toSuperviewEdge: .left, withInset: LayoutDimensions.spacingMargin)
        self.stationsCarousel.autoPinEdge(toSuperviewEdge: .right, withInset: LayoutDimensions.spacingMargin)
        self.stationsCarousel.autoSetDimension(.height, toSize: 50)
        
        self.dividingLineBetweenStationsAndTraps.autoPinEdge(toSuperviewEdge: .left)
        self.dividingLineBetweenStationsAndTraps.autoPinEdge(toSuperviewEdge: .right)
        self.dividingLineBetweenStationsAndTraps.autoPinEdge(.top, to: .bottom, of: self.stationsCarousel, withOffset: 0)
        self.dividingLineBetweenStationsAndTraps.autoSetDimension(.height, toSize: 1)
        
        self.trapsCarousel.autoPinEdge(.top, to: .bottom, of: self.stationsCarousel, withOffset: LayoutDimensions.spacingMargin)
        self.trapsCarousel.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
        self.trapsCarousel.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
        self.trapsCarousel.autoSetDimension(.height, toSize: CAROUSEL_TRAPS_HEIGHT)
        
        self.dividingLineAfterTrapSelector.autoPinEdge(toSuperviewEdge: .left)
        self.dividingLineAfterTrapSelector.autoPinEdge(toSuperviewEdge: .right)
        self.dividingLineAfterTrapSelector.autoPinEdge(.top, to: .bottom, of: self.trapsCarousel, withOffset: 0)
        self.dividingLineAfterTrapSelector.autoSetDimension(.height, toSize: LayoutDimensions.spacingMargin)
        
        self.visitContainerView.autoPinEdge(.top, to: .top, of: self.dividingLineAfterTrapSelector, withOffset: 0)
        self.visitContainerView.autoPinEdge(toSuperviewEdge: .left)
        self.visitContainerView.autoPinEdge(toSuperviewEdge: .right)
        self.visitContainerView.autoPinEdge(toSuperviewEdge: .bottom)
    }
}

// MARK: - UIScrollViewDelegate (for VisitLogView)
extension VisitView: VisitLogDelegate {
    
    func visitLogViewDidScroll(_ visitLogView: VisitLogView, scrollView: UIScrollView) {

        let MIN_HEADER: CGFloat = 62
        let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
        self.totalScrollOffset += scrollDiff
//        let isScrollingDown = scrollDiff > 0
//        let isScrollingUp = scrollDiff < 0
        
        // Keep track of how far the visitLog tableview has scrolled down
        //self.totalScrollOffset +=
        let offSet = self.totalScrollOffset
        
        if (offSet > 0 && offSet <= MIN_HEADER) {
            
            // stop the tableview from moving
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
            
            for view in self.trapCarouselViews {
                
                view.frame = CGRect(x: 0, y: 0 + offSet/2, width: 100, height: CAROUSEL_TRAPS_HEIGHT - offSet)
                
                if let label = view.viewWithTag(self.CAROUSEL_TRAPS_LABEL_TAG) as? UILabel {
                    label.alpha = 1 - min(offSet/MIN_HEADER * 3, 1)
                }
                
            }
            self.trapsCarousel.frame.size.height = CAROUSEL_TRAPS_HEIGHT - offSet
            
            self.dividingLineAfterTrapSelector.frame.origin.y = self.trapsCarousel.frame.origin.y + self.trapsCarousel.frame.size.height
            
            self.visitContainerView.frame.origin.y = self.dividingLineAfterTrapSelector.frame.origin.y
            
            scrollView.frame.size.height = self.view.frame.height - self.dividingLineAfterTrapSelector.frame.origin.y
            
        }
        self.previousScrollOffset = scrollView.contentOffset.y
    }
}

//MARK: - iCarouselDelegate, iCarouselDataSource
extension VisitView: iCarouselDelegate, iCarouselDataSource {

    func numberOfStations() -> Int {
        return self.stations?.count ?? 0
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        if (carousel.tag == CAROUSEL_STATIONS_TAG) {
            return numberOfStations() * INFINITE_SCROLL_MULTIPLIER
        } else {
            return self.currentTraps?.count ?? 0
        }
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        var usableView: UIView
        
        if view != nil {
            
            usableView = view!
            
        } else {
            
            // Create view
            usableView = carousel.tag == CAROUSEL_STATIONS_TAG ? self.stationCarouselView : self.trapCarouselView
            usableView.tag = index
        }
        
        // set properties on view
        if carousel.tag == CAROUSEL_STATIONS_TAG {
            if let label = usableView.viewWithTag(self.CAROUSEL_STATIONS_LABEL_TAG) as? UILabel {
                
                let adjustedIndex = index % numberOfStations()
                label.text = self.stations?[adjustedIndex].longCode
            }
        } else {
            print("getting trap at index \(index)")
            if let imageView = usableView.viewWithTag(self.CAROUSEL_TRAPS_IMAGE_TAG) as? UIImageView {
                print("found imageView")
                if let imageName = self.currentTraps?[index].type?.imageName {
                    print("found image name \(imageName)")
                    imageView.image = UIImage(named: imageName)?.changeColor(UIColor.black)
                }
                if let label = usableView.viewWithTag(self.CAROUSEL_TRAPS_LABEL_TAG) as? UILabel {
                    label.text = self.currentTraps?[index].type?.name?.uppercased()
                }
            }
            if !self.trapCarouselViews.contains(usableView) {
                self.trapCarouselViews.append(usableView)
            }
        }
        
        return usableView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {

        let isTrapType = (carousel == self.trapsCarousel)
        
        switch option
        {
        case .fadeMin:
            return -0.2
        case .fadeMax:
            return 0.2
        case .fadeRange:
            return isTrapType ? 2.0 : 1.0
        default:
            return value
        }
    }
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        var adjIndex = carousel.currentItemIndex
 
        if (carousel.tag == CAROUSEL_STATIONS_TAG) {
            adjIndex = carousel.currentItemIndex % numberOfStations()
            if adjIndex != self.lastSelectedStation {
                
                if self.lastSelectedStation != -1 {
                    self.lastSelectedTrap = -1
                }
                
                self.lastSelectedStation = adjIndex
                presenter.didSelectStation(index: adjIndex)
                
            }
        } else {
            if adjIndex != self.lastSelectedTrap {
                presenter.didSelectTrap(index: adjIndex)
                self.lastSelectedTrap = adjIndex
            }
        }
        
    }
}

//MARK: - VisitViewApi
extension VisitView: VisitViewApi {
    
    var getVisitContainerView: UIView {
        return self.visitContainerView
    }
    
    func setTitle(title: String, subTitle: String) {
        self.titleLabel.text = title
        self.titleLabel.sizeToFit()
        
        self.subTitleLabel.text = subTitle
        self.subTitleLabel.sizeToFit()
    }
    
//    func setStationText(text: String) {
//        //self.stationLabel.text = text
//    }
    
    func setStations(stations: [Station], current: Station) {
        self.stations = stations
        
        if let index = stations.index(of: current) {
            // start in the middle of the "infinite" list of stations.
            self.stationsCarousel.currentItemIndex = index * INFINITE_SCROLL_MULTIPLIER/2
        }
        self.stationsCarousel.reloadData()
    }
    
    func setTraps(traps: [Trap]) {
        currentTraps = traps
        //trapTypeCollectionView.reloadData()
        self.trapsCarousel.reloadData()
    }
    
    func updateDisplayFor(visit: Visit) {
        //print("Update for visit to \(visit.trap?.station?.longCode ?? "?"), trap \(visit.trap?.type?.name ?? "?")")
    }
    
    func updateCurrentStation(index: Int, repeatedGroup: Int) {
        self.stationsCarousel.currentItemIndex = index + (numberOfStations() * repeatedGroup)
    }
    
    func displayMenuOptions(options: [OptionItem]) {
        let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        for option in options {
            let action = UIAlertAction(title: option.title, style: option.isDestructive ? .destructive : .default, handler: {
                (action) in
                self.presenter.didSelectMenuItem(title: action.title!)
            })
            action.isEnabled = option.isEnabled
            //action.
            menu.addAction(action)
        }
        
        // always add a cancel
        menu.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(menu, animated: true, completion: nil)
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
