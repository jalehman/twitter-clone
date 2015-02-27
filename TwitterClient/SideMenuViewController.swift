//
//  SideMenuViewController.swift
//  TwitterClient
//
//  Created by Josh Lehman on 2/26/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    // MARK: Properties
    
    private let viewModel: SideMenuViewModel
    
    // MARK: API
    
    init(viewModel: SideMenuViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SideMenuViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = .None
        
        view.backgroundColor = UIColor(red: 0.361, green: 0.686, blue: 0.925, alpha: 1)
    }

}
