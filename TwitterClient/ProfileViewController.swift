//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Josh Lehman on 3/1/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var profileBackgroundImage: UIImageView!
    @IBOutlet weak var profileAvatarImage: UIImageView!
    
    private let viewModel: ProfileViewModel
    
    // MARK: API
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ProfileViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.translucent = true
        navigationController?.view.backgroundColor = UIColor.clearColor()
        navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
    }
    
    // MARK: Private
    
    private func bindViewModel() {
        self.profileAvatarImage.setImageWithURL(viewModel.avatarImageURL!)
        
        if viewModel.bannerImageURL != nil {
            profileBackgroundImage.setImageWithURL(viewModel.bannerImageURL!)
        }
    }
}
