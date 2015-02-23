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
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
        
    private let viewModel: TweetDetailViewModel
    private var loadingHUD: JGProgressHUD!
    
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
        
        loadingHUD = JGProgressHUD(style: .Dark)
        loadingHUD.textLabel.text = "Loading..."
        
        bindViewModel()
    }
    
    // MARK: Private
    
    func bindViewModel() {
        avatarImage.setImageWithURL(viewModel.avatarImageURL)
        nameLabel.text = viewModel.name
        screenNameLabel.text = "@\(viewModel.screenName)"
        tweetTextLabel.text = viewModel.tweetText
        tweetTimeLabel.text = viewModel.createdAt
        RAC(numRetweetsLabel, "text") << RACObserve(viewModel, "retweetCount")
        RAC(numFavoritesLabel, "text") << RACObserve(viewModel, "favoriteCount")
        
        retweetButton.rac_command = viewModel.executeRetweet
        favoriteButton.rac_command = viewModel.executeFavorite
        replyButton.rac_command = viewModel.executeShowReply
        
        viewModel.executeRetweet.executionValues().subscribeNext {
            _ in
            let successHUD = self.successHUD("Retweeted!")
            successHUD.showInView(self.view)
            successHUD.dismissAfterDelay(1)
        }
        
        viewModel.executeRetweet.errors.subscribeNext {
            _ in
            let errorHUD = self.errorHUD("Error retweeting!")
            errorHUD.showInView(self.view)
            errorHUD.dismissAfterDelay(1.5)
        }
        
        viewModel.executeFavorite.executionValues().subscribeNext {
            _ in
            let successHUD = self.successHUD("Favorited")
            successHUD.showInView(self.view)
            successHUD.dismissAfterDelay(1)
        }
        
        viewModel.executeFavorite.errors.subscribeNext {
            _ in
            let errorHUD = self.errorHUD("Error favoriting!")
            errorHUD.showInView(self.view)
            errorHUD.dismissAfterDelay(1.5)
        }
    }
    
    private func successHUD(text: String) -> JGProgressHUD {
        let hud = JGProgressHUD(style: .Dark)
        hud.textLabel.text = text
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        return hud
    }
    
    private func errorHUD(text: String) -> JGProgressHUD {
        let hud = JGProgressHUD(style: .Dark)
        hud.textLabel.text = text
        hud.indicatorView = JGProgressHUDErrorIndicatorView()
        return hud
    }
}
