//
//  LoaderView.swift
//  trapr
//
//  Created by Andrew Tokeley on 15/01/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import UIKit
import Viperit

//MARK: LoaderView Class
final class LoaderView: UserInterface {
    
    lazy var appIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "tree"))
        return imageView
    }()
    
    lazy var appName: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.trpAppNameFont
        label.text = "Trapr"
        return label
    }()
    
    lazy var progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.trackTintColor = UIColor.trpProgressBarBackground
        progressBar.progressTintColor = UIColor.trpProgressBarForeground
        progressBar.alpha = 0
        return progressBar
    }()
    
    lazy var progressMessage: UILabel = {
        let progressMessage = UILabel()
        progressMessage.textColor = UIColor.white
        progressMessage.font = UIFont.trpLabelSmall
        progressMessage.alpha = 0
        return progressMessage
    }()
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.trpNavigationBar
        self.view.addSubview(self.appIcon)
        self.view.addSubview(self.appName)
        self.view.addSubview(self.progressBar)
        self.view.addSubview(self.progressMessage)
        
        setConstraints()
    }
    
    private func setConstraints() {
        
        self.appName.autoCenterInSuperview()
        
        self.appIcon.autoAlignAxis(toSuperviewAxis: .vertical)
        self.appIcon.autoPinEdge(.bottom, to: .top, of: self.appName, withOffset: -0.5)
        self.appIcon.autoSetDimension(.width, toSize: 60)
        self.appIcon.autoSetDimension(.height, toSize: 60)
        
        self.progressBar.autoPinEdge(.top, to: .bottom, of: self.appName, withOffset: LayoutDimensions.spacingMargin)
        self.progressBar.autoSetDimension(.width, toSize: self.view.frame.width/2)
        self.progressBar.autoSetDimension(.height, toSize: LayoutDimensions.smallSpacingMargin/2)
        self.progressBar.autoAlignAxis(toSuperviewAxis: .vertical)
        
        self.progressMessage.autoPinEdge(.top, to: .bottom, of: self.progressBar, withOffset: LayoutDimensions.spacingMargin)
        self.progressMessage.autoAlignAxis(toSuperviewAxis: .vertical)
    }
}

//MARK: - LoaderView API
extension LoaderView: LoaderViewApi {
    
    func fade(completion: (() -> Void)?) {
        UIView.animate(withDuration: 1,
                       animations: {
                        self.appIcon.alpha = 0
                        self.appName.alpha = 0
                        self.progressBar.alpha = 0
                        self.progressMessage.alpha = 0
        },
                       completion: {
                        (result) in
                        completion?()
        })
    }
    
    func updateProgress(progress: Float) {
        self.progressBar.setProgress(progress, animated: true)
    }
    
    func updateProgressMessage(message: String?) {
        if self.progressMessage.alpha == 0 {
            self.progressMessage.alpha = 1
        }
        self.progressMessage.text = message
    }
}

// MARK: - LoaderView Viper Components API
private extension LoaderView {
    var presenter: LoaderPresenterApi {
        return _presenter as! LoaderPresenterApi
    }
    var displayData: LoaderDisplayData {
        return _displayData as! LoaderDisplayData
    }
}
