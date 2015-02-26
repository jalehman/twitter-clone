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
    let retweetedByUserName: String?
    var tweet: Tweet
    
    dynamic var retweeted: Bool
    dynamic var favorited: Bool
    
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
        self.createdAt = tweet.createdAt
        self.avatarImageURL = NSURL(string: tweet.user!.profileImageUrl!)
        self.retweetedByUserName = tweet.retweetedBy?.name
        self.tweet = tweet
        self.retweeted = tweet.retweeted
        self.favorited = tweet.favorited
        
        super.init()
        
        executeRetweet = RACCommand() {
            [unowned self] input -> RACSignal in
            return self.services.twitterService.retweet(self.tweet.tweetId!)
        }
        
        executeRetweet.executionValues().subscribeNextAs {
            [unowned self] (tweet: Tweet) in
            self.retweeted = true
            self.tweet = tweet
        }
        
        executeFavorite = RACCommand() {
            [unowned self] input -> RACSignal in
            return self.services.twitterService.favorite(self.tweet.tweetId!)
        }
        
        executeFavorite.executionValues().subscribeNextAs {
            [unowned self] (tweet: Tweet) in
            self.favorited = true
            self.tweet = tweet
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
                .mapAs {
                    (tweet: Tweet) -> RACStream in
                    return self.services.twitterService.updateStatus(tweet)
                }
        }
    }
}