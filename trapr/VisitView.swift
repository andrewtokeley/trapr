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
import MessageUI

//MARK: VisitView Class
final class VisitView: UserInterface {
    
    fileprivate let htmlService = ServiceFactory.sharedInstance.htmlService
    fileprivate let excelService = ServiceFactory.sharedInstance.excelService
    
    fileprivate var CAROUSEL_TRAPS_HEIGHT: CGFloat = 100
    fileprivate var CAROUSEL_STATIONS_HEIGHT: CGFloat = 50
    
    fileprivate var trapCarouselViews = [UIView]()
    fileprivate let CAROUSEL_STATIONS_TAG = 0
    fileprivate let CAROUSEL_STATIONS_LABEL_TAG = 10
    
    fileprivate let CAROUSEL_TRAPS_TAG = 1
    fileprivate let CAROUSEL_TRAPS_IMAGE_TAG = 20
    fileprivate let CAROUSEL_TRAPS_LABEL_TAG = 30
    
    fileprivate let TAG_TRAP_IMAGE = 0
    fileprivate let TAG_TRAP_LABEL = 1
    
    fileprivate var currentTraps: [TrapType]?
    fileprivate var stations: [Station]?
    
    fileprivate var lastSelectedStation: Int = -1
    fileprivate var lastSelectedTrap: Int = -1
    
    fileprivate var totalScrollOffset: CGFloat = 0
    fileprivate var previousScrollOffset: CGFloat = 0
    fileprivate var trapsCarouselCollapsed: Bool = false
    
    fileprivate var heightConstraintForTrapsCarousel: NSLayoutConstraint?
    
    fileprivate var repeatCount: Int = 1
    
    let TRAPTYPE_REUSE_ID = "cell"
    
    //MARK: - Subviews
    lazy var navigationSection: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.trpBackground
        view.dropShadow(color: UIColor.darkGray, opacity: 0.5, offSet: CGSize(width: 0, height: 6), radius: 3.0, scale: true)
        
        view.addSubview(self.stationsCarousel)
        view.addSubview(self.trapsCarousel)
        
        return view
    }()
    
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
        label.font = UIFont.trpLabelBoldLarge
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

        return carousel
    }()
    
    fileprivate var trapCarouselView: UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: CAROUSEL_TRAPS_HEIGHT))
        
        let image = UIImageView()
        image.tag = self.CAROUSEL_TRAPS_IMAGE_TAG
        
        let label = UILabel()
        label.font = UIFont.trpLabelSmall
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
        //label.autoSetDimension(.height, toSize: LayoutDimensions.inputHeight)
        label.autoAlignAxis(.vertical, toSameAxisOf: view)
        
        return view
    }
    
    lazy var dividingLineAfterTrapSelector: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.trpDividerLine
        
//        view.layer.shadowColor = UIColor.lightGray.cgColor
//        view.layer.shadowOffset = CGSize(width: 0, height: 0)
//        view.layer.shadowRadius = 5
//        view.layer.shadowOpacity = 1
        
        return view
    }()
    
    lazy var visitContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var showMenuButton: UIBarButtonItem = {
        var buttonItem = UIBarButtonItem(image: UIImage(named: "show"), style: .plain, target: self, action: #selector(showMoreMenu(sender:)))
        
//        return view
//        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 22, height: 22))
//        button.setImage(UIImage(named: "show"), for: .normal)
//        button.addTarget(self, action: #selector(showMoreMenu(sender:)), for: .touchUpInside)
//        let buttonItem = UIBarButtonItem(customView: button)
        return buttonItem
    }()
    
//    lazy var infoButton: UIBarButtonItem = {
//        let button = UIButton()
//        let image = UIImage(named: "info")?.changeColor(UIColor.white)
//        button.setImage(image, for: .normal)
//        button.addTarget(self, action: #selector(infoMenu(sender:)), for: .touchUpInside)
//        let buttonItem = UIBarButtonItem(customView: button)
//
//        buttonItem.customView?.autoSetDimension(.width, toSize: 22)
//        buttonItem.customView?.autoSetDimension(.height, toSize: 22)
//        return buttonItem
//    }()
    
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
        label.font = UIFont.trpLabelNormal
        
        return label
    }()
    
//    lazy var subTitleLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = UIColor.trpNavigationBarTint
//        label.isUserInteractionEnabled = true
//        label.textAlignment = .center
//        label.font = UIFont.trpLabelSmall
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dateTap(sender:)))
//        label.addGestureRecognizer(tapGesture)
//        return label
//    }()
//
    lazy var datePicker: UIDatePicker = {
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // leave it
        }
        
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    lazy var subTitleLabel: UITextField = {
        let label = UITextField()
        label.textColor = UIColor.trpNavigationBarTint
        //label.isUserInteractionEnabled = true
        label.textAlignment = .center
        label.font = UIFont.trpLabelSmall
        label.inputView = self.datePicker
        
        // Create Done action for the DatePicker
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dateTap(sender:)))

        // if you remove the space element, the "done" button will be left aligned
        // you can add more items if you want
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()

        label.inputAccessoryView = toolBar
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dateTap(sender:)))
//        label.addGestureRecognizer(tapGesture)
        return label
    }()
    
    //MARK: - Events
    
    @objc func dateTap(sender: UIBarButtonItem) {
        // dismiss the datepicker by ending the editing of the textfield
        self.subTitleLabel.endEditing(true)
        presenter.didSelectNewDate(date: datePicker.date)
    }
    
    @objc func showMoreMenu(sender: UIBarButtonItem) {
        presenter.didSelectMenuButton()
    }
    
//    @objc func infoMenu(sender: UIBarButtonItem) {
//        presenter.didSelectInfoButton()
//    }
    
//    func didSelectStation(sender: UILabel) {
//        //presenter.didSelectStation()
//    }

    //MARK: - UIViewController
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.trpBackground
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.prefersLargeTitles = false
        
        self.view.addSubview(self.visitContainerView)
        self.view.addSubview(self.navigationSection)
        
        self.navigationItem.rightBarButtonItem = self.showMenuButton
        
        self.navigationItem.titleView = titleView

    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        setConstraints()
    }
    
    func setConstraints() {
        
        //self.navigationSection.autoPin(toTopLayoutGuideOf: self, withInset: 0)
        self.navigationSection.autoPinEdge(toSuperviewSafeArea: .top, withInset: 0)
        self.navigationSection.autoPinEdge(toSuperviewEdge: .left)
        self.navigationSection.autoPinEdge(toSuperviewEdge: .right)
        self.navigationSection.autoSetDimension(.height, toSize: CAROUSEL_STATIONS_HEIGHT + CAROUSEL_TRAPS_HEIGHT + LayoutDimensions.spacingMargin)
        
        self.stationsCarousel.autoPinEdge(toSuperviewEdge: .top)
        self.stationsCarousel.autoPinEdge(toSuperviewEdge: .left)
        self.stationsCarousel.autoPinEdge(toSuperviewEdge: .right)
        self.stationsCarousel.autoSetDimension(.height, toSize: self.CAROUSEL_STATIONS_HEIGHT)
        
        self.trapsCarousel.autoPinEdge(.top, to: .bottom, of: self.stationsCarousel, withOffset:LayoutDimensions.spacingMargin)
        self.trapsCarousel.autoPinEdge(toSuperviewEdge: .left)
        self.trapsCarousel.autoPinEdge(toSuperviewEdge: .right)
        self.trapsCarousel.autoPinEdge(toSuperviewEdge: .bottom)
        
        self.visitContainerView.autoPinEdge(.top, to: .bottom, of: self.navigationSection, withOffset: 0)
        self.visitContainerView.autoPinEdge(toSuperviewEdge: .left)
        self.visitContainerView.autoPinEdge(toSuperviewEdge: .right)
        self.visitContainerView.autoPinEdge(toSuperviewEdge: .bottom)
    }
}

// MARK: - VisitLogDelegate
extension VisitView: VisitLogViewDelegate {
    
    func visitLogViewDidScroll(_ visitLogView: VisitLogView, scrollView: UIScrollView) {
        
        let MIN_HEADER: CGFloat = 37
        let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
        self.totalScrollOffset += scrollDiff

        // Keep track of how far the visitLog tableview has scrolled down
        //self.totalScrollOffset +=
        let offSet = self.totalScrollOffset
        print (self.totalScrollOffset)
        if (offSet > 0 && offSet <= MIN_HEADER) {
            
            trapsCarouselCollapsed = true
            
            // stop the tableview from moving
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
            
            self.heightConstraintForTrapsCarousel?.constant = CAROUSEL_TRAPS_HEIGHT - offSet
            
            for view in self.trapCarouselViews {

                view.frame = CGRect(x: 0, y: 0 + offSet/2, width: 100, height: CAROUSEL_TRAPS_HEIGHT - offSet)

                if let label = view.viewWithTag(self.CAROUSEL_TRAPS_LABEL_TAG) as? UILabel {
                    label.alpha = 1 - min(offSet/MIN_HEADER * 3, 1)
                }
            }
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
            return numberOfStations() * self.repeatCount
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
            //print("\(index) for stations carousel")
            if let label = usableView.viewWithTag(self.CAROUSEL_STATIONS_LABEL_TAG) as? UILabel {
                
                let adjustedIndex = index % numberOfStations()
                label.text = self.stations?[adjustedIndex].longCode
                //print("label text \(label.text)")
            }
        } else {
            
            if let imageView = usableView.viewWithTag(self.CAROUSEL_TRAPS_IMAGE_TAG) as? UIImageView {
                
                if let imageName = self.currentTraps?[index].imageName {
            
                    imageView.image = UIImage(named: imageName)?.changeColor(UIColor.black)
                }
                if let label = usableView.viewWithTag(self.CAROUSEL_TRAPS_LABEL_TAG) as? UILabel {
                    label.text = self.currentTraps?[index].name.uppercased()
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
    
    /**
     Have to use this rather than the selected method as this is the only one called when a user scrolls to a new item rather than clicking on it.
     */
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        var adjIndex = carousel.currentItemIndex
 
        if (carousel.tag == CAROUSEL_STATIONS_TAG) {
            adjIndex = carousel.currentItemIndex % numberOfStations()
            if adjIndex != self.lastSelectedStation {
                
                if self.lastSelectedStation != -1 {
                    self.lastSelectedTrap = -1
                }
                
                self.lastSelectedStation = adjIndex
                print("view: presenter.didSelectStation")
                presenter.didSelectStation(index: adjIndex, trapIndex: 0)
                
            }
        } else {
            if adjIndex != self.lastSelectedTrap {
                print("view: presenter.didSelectTrap")
                presenter.didSelectTrap(index: adjIndex)
//                if let imageCollectionViewCell = carousel.currentItemView as? ImageCollectionViewCell {
//                    imageCollectionViewCell
//                }
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
        //self.titleLabel.sizeToFit()
        
        self.subTitleLabel.text = subTitle
        //self.subTitleLabel.sizeToFit()
    }
    
//    func setStationText(text: String) {
//        //self.stationLabel.text = text
//    }
    
    func setStations(stations: [Station], current: Station, repeatCount: Int) {
        self.stations = stations
        self.repeatCount = repeatCount
        
        if let index = stations.firstIndex(of: current) {
            // start in the middle of the "infinite" list of stations.
            self.stationsCarousel.currentItemIndex = index * self.repeatCount/2
            print("POSITION \(index * self.repeatCount/2)")
        }
        self.stationsCarousel.reloadData()
    }
    
    func setTraps(trapTypes: [TrapType]) {
        currentTraps = trapTypes
        self.trapsCarousel.reloadData()
    }
    
    func selectTrap(index: Int) {
        trapsCarousel.currentItemIndex = index
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
    
    func showVisitEmail(subject: String, message: String, attachmentFilename: String, attachmentData: Data, attachmentMimeType: String, recipient: String) {

        if MFMailComposeViewController.canSendMail() {
            
            let controller = MFMailComposeViewController()
            controller.mailComposeDelegate = self
            
            controller.setSubject(subject)
            controller.setToRecipients([recipient])
            controller.setMessageBody(message, isHTML: true)
            controller.addAttachmentData(attachmentData, mimeType: attachmentMimeType, fileName:  attachmentFilename)
            self.present(controller, animated: true, completion: nil)
        }
        
        self.presenter.didSendEmailSuccessfully()
    }
    
    func showVisitEmail(subject: String, html: String, recipient: String) {
        
        
        
        if MFMailComposeViewController.canSendMail() {

            let controller = MFMailComposeViewController()
            controller.mailComposeDelegate = self

            controller.setSubject(subject)
            controller.setToRecipients([recipient])
            controller.setMessageBody(html, isHTML: true)

            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func showVisitEmail(visitSummary: VisitSummary, recipient: String?) {
        
        
        if MFMailComposeViewController.canSendMail() {

            let controller = MFMailComposeViewController()
            controller.mailComposeDelegate = self

            controller.setSubject("Data for \(visitSummary.routeId!)")

            if let recipient = recipient {
                controller.setToRecipients([recipient])
            }

            //controller.addAttachmentData(Data, mimeType: , fileName: <#T##String#>)
            htmlService.getVisitsAsHtml(recordedOn: visitSummary.dateOfVisit, route: visitSummary.route!, completion: { (html) in
                if let html = html {
                    controller.setMessageBody(html, isHTML: true)
                }
            })

            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func confirmDeleteStationMethod() {
        let alert = UIAlertController(title: "Remove Station", message: "Do you want to remove the station from this route, or permanently delete the station from your phone?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Remove from Route", style: .default, handler: { (action) in self.presenter.didSelectRemoveStation() })
        let removeAction = UIAlertAction(title: "Delete from Phone", style: .destructive, handler: { (action) in self.presenter.didSelectDeleteStation() })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(removeAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showConfirmation(title: String, message: String, yes: (() -> Void)?, no: (() -> Void)?) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in yes?() })
        let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler:  { (action) in no?() })
        alert.addAction(yesAction)
        alert.addAction(noAction)

        self.present(alert, animated: true, completion: nil)
        
    }
}

extension VisitView: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        if result == MFMailComposeResult.sent {
            // add a VisitSync record
            presenter.didSendEmailSuccessfully()
        }
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - VisitView Viper Components API
private extension VisitView {
    var presenter: VisitPresenterApi {
        return _presenter as! VisitPresenterApi
    }
//    var displayData: VisitDisplayData {
//        return _displayData as! VisitDisplayData
//    }
}
