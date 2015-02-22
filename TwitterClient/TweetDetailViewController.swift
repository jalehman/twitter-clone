//
//  TweetDetailViewController.swift
//  TwitterClient
//
//  Created by Josh Lehman on 2/20/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetTimeLabel: UILabel!
    @IBOutlet weak var numRetweetsLabel: UILabel!
    @IBOutlet weak var numFavoritesLabel: UILabel!
        
    private let viewModel: TweetDetailViewModel
    
    // MARK: API
    
    init(viewModel: TweetDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "TweetDetailViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .None
        
        navigationItem.title = "Tweet"
        
        avatarImage.layer.cornerRadius = 5.0
        avatarImage.clipsToBounds = true
        
        bindViewModel()
    }
    
    // MARK: Private
    
    func bindViewModel() {
        avatarImage.setImageWithURL(viewModel.avatarImageURL)
        nameLabel.text = viewModel.name
        screenNameLabel.text = "@\(viewModel.screenName)"
        tweetTextLabel.text = viewModel.tweetText
        tweetTimeLabel.text = viewModel.createdAt
        numRetweetsLabel.text = viewModel.retweetCount
        numFavoritesLabel.text = viewModel.favoriteCount
    }

}
