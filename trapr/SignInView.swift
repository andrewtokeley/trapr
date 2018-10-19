//
//  SignInView.swift
//  trapr
//
//  Created by Andrew Tokeley on 17/10/18.
//Copyright © 2018 Andrew Tokeley . All rights reserved.
//

import UIKit
import Viperit
import Firebase
import GoogleSignIn

//MARK: SignInView Class
final class SignInView: UserInterface {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        //GIDSignIn.sharedInstance().signIn()
    }
    
    lazy var googleSignInButton: GIDSignInButton = {
        let googleSignInButton = GIDSignInButton()
        return googleSignInButton
    }()
    
    lazy var signOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign out", for: .normal)
        button.addTarget(self, action: #selector(signOutButtonClick(sender:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var message: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.trpHighlightColor
        self.view.addSubview(googleSignInButton)
        self.view.addSubview(message)
        self.view.addSubview(signOutButton)
        
        refreshContent()
        setConstraints()
    }
    
    private func refreshContent() {
        if let user = Auth.auth().currentUser {
            self.message.text = "\(user.displayName ?? "unknown"), \(user.email ?? "unknown email")"
        } else {
            self.message.text = "Not logged in"
        }
    }
    
    private func setConstraints() {
        self.googleSignInButton.autoCenterInSuperview()
        
        self.message.autoPinEdge(.top, to: .bottom, of: self.googleSignInButton, withOffset: 20)
        self.message.autoPinEdge(toSuperviewEdge: .left)
        self.message.autoPinEdge(toSuperviewEdge: .right)
        
        self.signOutButton.autoPinEdge(.top, to: .bottom, of: self.message, withOffset: 30)
        self.signOutButton.autoAlignAxis(toSuperviewAxis: .vertical)
        
    }
    
    @objc func signOutButtonClick(sender: UIButton) {
        do {
            let firebaseAuth = Auth.auth()
            try firebaseAuth.signOut()
            GIDSignIn.sharedInstance().signOut()
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        refreshContent()
    }
}

//MARK: - SignInView API
extension SignInView: GIDSignInUIDelegate {
    
}

//MARK: - SignInView API
extension SignInView: SignInViewApi {
}

// MARK: - SignInView Viper Components API
private extension SignInView {
    var presenter: SignInPresenterApi {
        return _presenter as! SignInPresenterApi
    }
    var displayData: SignInDisplayData {
        return _displayData as! SignInDisplayData
    }
}
