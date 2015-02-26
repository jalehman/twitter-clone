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
    dynamic var retweetCount: String!
    dynamic var favoriteCount: String!
    let retweetedByUserName: String?
    let tweet: Tweet
    
    var executeRetweet: RACCommand!
    var executeFavorite: RACCommand!
    var executeShowReply: RACCommand!
    
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
        
        executeRetweet = RACCommand() {
            [unowned self] input -> RACSignal in
            return self.services.twitterService.retweet(self.tweet.tweetId!)
        }
        
        executeRetweet.executionValues().subscribeNext {
            [unowned self]  _ in
            self.tweet.retweetCount = (self.tweet.retweetCount ?? 0) + 1
            self.retweetCount = String(stringInterpolationSegment: self.tweet.retweetCount!)
        }
        
        executeFavorite = RACCommand() {
            [unowned self] input -> RACSignal in
            return self.services.twitterService.favorite(self.tweet.tweetId!)
        }
        
        executeFavorite.executionValues().subscribeNext {
            [unowned self]  _ in
            self.tweet.favoriteCount = (self.tweet.favoriteCount ?? 0) + 1
            self.favoriteCount = String(stringInterpolationSegment: self.tweet.favoriteCount!)
        }
        
        executeShowReply = RACCommand() {
            [unowned self] input -> RACSignal in
            
            let composeTweetViewModel = ComposeTweetViewModel(services: self.services, inReplyTo: self.tweet)
            services.pushViewModel(composeTweetViewModel)
            
            let composeTweetCancelledSignal = composeTweetViewModel.executeCancelComposeTweet.executionSignals
            let composeTweetSignal = composeTweetViewModel.executeComposeTweet.executionSignals
            
            let closeComposeTweetSignal = RACSignal.merge([composeTweetCancelledSignal, composeTweetSignal])
            
            closeComposeTweetSignal.subscribeNext {
                _ in
                self.services.popActiveModal()
            }
            
            return composeTweetViewModel.executeComposeTweet.executionValues()
                .flattenMapAs { (tweet: Tweet) -> RACStream in
                    return self.services.twitterService.updateStatus(tweet)
            }            
        }
    }
}