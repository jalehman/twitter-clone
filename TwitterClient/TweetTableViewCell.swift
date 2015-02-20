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
        let tweetCellViewModel = viewModel as TweetCellViewModel
        println(tweetCellViewModel.tweetText)
        nameLabel.text = tweetCellViewModel.name
        screenNameLabel.text = "@\(tweetCellViewModel.screenName)"
        avatarImage.setImageWithURL(tweetCellViewModel.avatarImageURL)
        tweetTextLabel.text = tweetCellViewModel.tweetText
    }
}
