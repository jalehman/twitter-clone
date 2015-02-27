//
//  AuthViewController.swift
//  TwitterClient
//
//  Created by Josh Lehman on 2/19/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var loginWithTwitterButton: UIButton!
    
    private let viewModel: AuthViewModel
    
    // MARK: API
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "AuthViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
    }    
    
    func bindViewModel() {
        viewModel.checkCurrentUser()
        
        loginWithTwitterButton.rac_command = viewModel.executeTwitterLogin
        
        viewModel.executeTwitterLogin.executionValues()
            .subscribeNextAs {
                (authURL: NSURL) in
                UIApplication.sharedApplication().openURL(authURL)
                return
        }
        
        viewModel.executeTwitterLogin.errors
            .subscribeNextAs {
                (error: NSError) in
                println(error)
        }
    }

}
