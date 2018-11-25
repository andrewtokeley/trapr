//
//  LoaderView.swift
//  trapr
//
//  Created by Andrew Tokeley on 15/01/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import UIKit
import Viperit
import Firebase
import GoogleSignIn

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
    
    lazy var googleSignInButton: GIDSignInButton = {
        let googleSignInButton = GIDSignInButton()
        googleSignInButton.alpha = 0
        return googleSignInButton
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
        
        #if DEVELOPMENT
            self.view.backgroundColor = UIColor.red
        #else
            self.view.backgroundColor = UIColor.trpHighlightColor
        #endif
        
        self.view.addSubview(self.appIcon)
        self.view.addSubview(self.appName)
        self.view.addSubview(self.progressBar)
        self.view.addSubview(self.progressMessage)
        self.view.addSubview(self.googleSignInButton)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        
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
        
        self.googleSignInButton.autoPinEdge(.top, to: .bottom, of: self.progressMessage, withOffset: LayoutDimensions.spacingMargin)
        self.googleSignInButton.autoAlignAxis(toSuperviewAxis: .vertical)
        
    }
}

extension LoaderView: GIDSignInUIDelegate {
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        self.presenter.signInStarted()
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
    
    func showSignInButton(show: Bool) {
        self.googleSignInButton.alpha = show ? 1 : 0
    }
    
    func updateProgress(progress: Float) {
        if self.progressBar.alpha == 0 {
            self.progressBar.alpha = 1
        }
        self.progressBar.setProgress(progress, animated: true)
    }
    
    func updateProgressMessage(message: String?) {
        if self.progressMessage.alpha == 0 {
            self.progressMessage.alpha = 1
        }
        self.progressMessage.text = message
    }
}

extension LoaderView: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            
            // Handle the error
            self.presenter.signInFailed(error: error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                self.presenter.signInFailed(error: error)
                return
            }
            //let z = user.profile.imageURL(withDimension: 40)
            self.presenter.signInComplete()
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
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
