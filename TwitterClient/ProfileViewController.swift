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
    @IBOutlet weak var avatarImageContainer: UIView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var bioTopSpaceConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationLabelScreenNameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationLabelBioTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var numFollowingLabel: UILabel!
    @IBOutlet weak var numFollowersLabel: UILabel!
    @IBOutlet weak var numTweetsLabel: UILabel!
    
    
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
        
        profileBackgroundImage.backgroundColor = UIColor(red: 0.361, green: 0.686, blue: 0.925, alpha: 1)

        avatarImageContainer.layer.cornerRadius = 5.0
        avatarImageContainer.clipsToBounds = true
        
        profileAvatarImage.layer.cornerRadius = 5.0
        profileAvatarImage.clipsToBounds = true
        
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
        profileAvatarImage.setImageWithURL(viewModel.avatarImageURL!)
        
        if viewModel.bannerImageURL != nil {
            profileBackgroundImage.setImageWithURL(viewModel.bannerImageURL!)
        }
        userNameLabel.text = viewModel.userName
        screenNameLabel.text = "@\(viewModel.screenName)"
        
        bioLabel.text = viewModel.bio
        locationLabel.text = viewModel.location
        
        numFollowingLabel.text = viewModel.numFollowing.jl_abbreviatedFormat() as String
        numFollowersLabel.text = viewModel.numFollowers.jl_abbreviatedFormat() as String
        numTweetsLabel.text = viewModel.numTweets.jl_abbreviatedFormat() as String
    }
}
