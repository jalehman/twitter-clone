//
//  MasterViewController.swift
//  TwitterClient
//
//  Created by Josh Lehman on 2/19/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var loginWithTwitterButton: UIButton!
    
    private let viewModel: MasterViewModel
    
    // MARK: API
    
    init(viewModel: MasterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "MasterViewController", bundle: nil)
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
        
        viewModel.executeTwitterLogin.executionErrors()
            .subscribeNextAs {
                (error: NSError) in
                println(error)
        }
    }

}
