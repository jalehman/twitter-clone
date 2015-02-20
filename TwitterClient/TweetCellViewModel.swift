//
//  TweetCellViewModel.swift
//  TwitterClient
//
//  Created by Josh Lehman on 2/19/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import Foundation

class TweetCellViewModel: NSObject {
    
    // MARK: Properties
    
    let name: String!
    let screenName: String!
    let tweetText: String!
    let createdAt: NSDate!
    let avatarImageURL: NSURL!
    
    private let services: ViewModelServices
    
    // MARK: API
    
    init(services: ViewModelServices, tweet: Tweet) {
        self.services = services
        self.name = tweet.user!.name
        self.screenName = tweet.user!.screenname
        self.tweetText = tweet.text
        self.createdAt = tweet.createdAt
        self.avatarImageURL = NSURL(string: tweet.user!.profileImageUrl!)
        
        super.init()
    }
}