//
//  TweetDetailViewModel.swift
//  TwitterClient
//
//  Created by Josh Lehman on 2/20/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import Foundation

class TweetDetailViewModel: NSObject {
    
    // MARK: Properties
    
    let name: String!
    let screenName: String!
    let tweetText: String!
    let createdAt: String!
    let avatarImageURL: NSURL!
    let retweetCount: String!
    let favoriteCount: String!
    let retweetedByUserName: String?
    let tweet: Tweet
    
    private let services: ViewModelServices
    
    // MARK: API
    
    init(services: ViewModelServices, tweet: Tweet) {
        self.services = services
        self.name = tweet.user!.name
        self.screenName = tweet.user!.screenname
        self.tweetText = tweet.text
        self.createdAt = DateService.sharedInstance.pretty(tweet.createdAt!)
        self.avatarImageURL = NSURL(string: tweet.user!.profileImageUrl!)
        self.retweetCount = String(stringInterpolationSegment: tweet.retweetCount ?? 0)
        self.favoriteCount = String(stringInterpolationSegment: tweet.favoriteCount ?? 0)
        self.retweetedByUserName = tweet.retweetedBy?.name
        self.tweet = tweet
        
        super.init()
    }

}