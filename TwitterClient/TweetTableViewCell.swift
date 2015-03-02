//
//  TweetTableViewCell.swift
//  TwitterClient
//
//  Created by Josh Lehman on 2/19/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
    // MARK: Properties

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var avatarImageButton: UIButton!
    @IBOutlet weak var timeSinceTweetLabel: UILabel!
    @IBOutlet weak var retweetedByLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var userNameLabelVerticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var retweetedByLabelTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var retweetedByLabelHeightConstraint: NSLayoutConstraint!
    
    // MARK: UITableViewCell Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImageButton.imageView?.layer.cornerRadius = 3.0
        avatarImageButton.imageView?.clipsToBounds = true
        avatarImageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Fill
        avatarImageButton.contentVerticalAlignment = UIControlContentVerticalAlignment.Fill
        tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
    }
    
    func bindViewModel(viewModel: AnyObject) {
        let tweetCellViewModel = viewModel as! TweetCellViewModel
        let dateService = DateService.sharedInstance
        nameLabel.text = tweetCellViewModel.name
        screenNameLabel.text = "@\(tweetCellViewModel.screenName)"
        avatarImageButton.setImageForState(.Normal, withURL: tweetCellViewModel.avatarImageURL)
        tweetTextLabel.text = tweetCellViewModel.tweetText
        timeSinceTweetLabel.text = tweetCellViewModel.createdAt.shortTimeAgoSinceNow()
        
        if tweetCellViewModel.retweetedByUserName != nil {
            retweetedByLabel.text = "\(tweetCellViewModel.retweetedByUserName!) retweeted"
            retweetedByLabelHeightConstraint.constant = 10
            userNameLabelVerticalSpaceConstraint.constant = 6
            retweetedByLabelTopSpaceConstraint.constant = 4
            retweetedByLabel.hidden = false
            self.setNeedsUpdateConstraints()
        } else {
            retweetedByLabel.hidden = true
            retweetedByLabelHeightConstraint.constant = 0
            userNameLabelVerticalSpaceConstraint.constant = 0
            retweetedByLabelTopSpaceConstraint.constant = 0
            self.setNeedsUpdateConstraints()
        }
        
        retweetButton.rac_command = tweetCellViewModel.executeRetweet
        favoriteButton.rac_command = tweetCellViewModel.executeFavorite
        replyButton.rac_command = tweetCellViewModel.executeShowReply
        avatarImageButton.rac_command = tweetCellViewModel.executeShowUserProfile
        
        RACObserve(tweetCellViewModel, "retweeted").subscribeNextAs {
            [unowned self] (retweeted: NSNumber) in
            if retweeted.boolValue {
                self.retweetButton.setImage(UIImage(named: "retweet_on")!, forState: .Normal)
            } else {
                self.retweetButton.setImage(UIImage(named: "retweet_dark")!, forState: .Normal)
            }
        }
        
        RACObserve(tweetCellViewModel, "favorited").subscribeNextAs {
            [unowned self] (favorited: NSNumber) in
            if favorited.boolValue {
                self.favoriteButton.setImage(UIImage(named: "favorite_on")!, forState: .Normal)
            } else {
                self.favoriteButton.setImage(UIImage(named: "favorite_dark")!, forState: .Normal)
            }
        }

    }
}
