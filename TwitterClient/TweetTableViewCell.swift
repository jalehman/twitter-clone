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
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var timeSinceTweetLabel: UILabel!
    @IBOutlet weak var retweetedByLabel: UILabel!
    
    @IBOutlet weak var userNameLabelVerticalSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var retweetedByLabelTopSpaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var retweetLabelHeightConstraint: NSLayoutConstraint!
    
    // MARK: UITableViewCell Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImage.layer.cornerRadius = 3.0
        avatarImage.clipsToBounds = true
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
        avatarImage.setImageWithURL(tweetCellViewModel.avatarImageURL)
        tweetTextLabel.text = tweetCellViewModel.tweetText
        timeSinceTweetLabel.text = tweetCellViewModel.createdAt.shortTimeAgoSinceNow()
        
        if tweetCellViewModel.retweetedByUserName != nil {
            retweetedByLabel.text = "\(tweetCellViewModel.retweetedByUserName!) retweeted"
            retweetLabelHeightConstraint.constant = 10
            userNameLabelVerticalSpaceConstraint.constant = 4
            retweetedByLabelTopSpaceConstraint.constant = 4
            retweetedByLabel.hidden = false
            self.setNeedsUpdateConstraints()
        } else {
            retweetedByLabel.hidden = true
            retweetLabelHeightConstraint.constant = 0
            userNameLabelVerticalSpaceConstraint.constant = 0
            retweetedByLabelTopSpaceConstraint.constant = 0
            self.setNeedsUpdateConstraints()
        }

    }
}
