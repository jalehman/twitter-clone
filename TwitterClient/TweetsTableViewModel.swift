//
//  TweetsTableViewModel.swift
//  TwitterClient
//
//  Created by Josh Lehman on 2/19/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import Foundation

class TweetsTableViewModel: NSObject {
    
    // MARK: Properties
    
    dynamic var tweets: [TweetCellViewModel] = []
    
    var executeLogout: RACCommand!
    var executeFetchTweets: RACCommand!
    var executeViewTweetDetails: RACCommand!
    var executeShowComposeTweet: RACCommand!
    
    private let services: ViewModelServices
    
    // MARK: API
    
    init(services: ViewModelServices) {
        self.services = services
        
        super.init()
        
        executeLogout = RACCommand() {
            input -> RACSignal in
            services.popToRootViewModel()
            return services.twitterService.logout()
        }
        
        executeFetchTweets = RACCommand() {
            [unowned self] input -> RACSignal in
            return self.services.twitterService.fetchHomeTimelineTweets()
        }
        
        executeFetchTweets.executionValues().subscribeNext {
            [weak self] any in
            let tweets = any as! [Tweet]
            self!.tweets = tweets.map { (tweet: Tweet) -> TweetCellViewModel in
                let viewModel = TweetCellViewModel(services: self!.services, tweet: tweet)
                return viewModel
            }
        }
        
        RACObserve(self, "tweets").subscribeNext { [weak self] _  in
            let signals: [RACSignal] = self!.tweets.map { (tweet: TweetCellViewModel) -> RACSignal in
                return tweet.executeShowReply.executionValues()
            }
            
            RACSignal.merge(signals).flattenMap { $0 as! RACStream }
                .subscribeNextAs { (tweet: Tweet) in
                    let viewModel = TweetCellViewModel(services: self!.services, tweet: tweet)
                    self!.tweets = [viewModel] + self!.tweets
            }
        }
        
        executeViewTweetDetails = RACCommand() {
            [weak self] input -> RACSignal in
            let tweetCellViewModel = input as! TweetCellViewModel
            let tweetDetailViewModel = TweetDetailViewModel(services: self!.services, tweet: tweetCellViewModel.tweet)
            self!.services.pushViewModel(tweetDetailViewModel)
            
            tweetCellViewModel.executeShowReply.executionValues()
                .flattenMap { $0 as! RACStream }
                .subscribeNextAs { (tweet: Tweet) in
                    let viewModel = TweetCellViewModel(services: self!.services, tweet: tweet)
                    self!.tweets = [viewModel] + self!.tweets
            }
            
            return RACSignal.empty()
        }
        
        executeShowComposeTweet = RACCommand() {
            [weak self] input -> RACSignal in
            
            let composeTweetViewModel = ComposeTweetViewModel(services: self!.services)
            services.pushViewModel(composeTweetViewModel)
            
            let composeTweetCancelledSignal = composeTweetViewModel.executeCancelComposeTweet.executionSignals
            let composeTweetSignal = composeTweetViewModel.executeComposeTweet.executionSignals
            
            let closeComposeTweetSignal = RACSignal.merge([composeTweetCancelledSignal, composeTweetSignal])
            
            closeComposeTweetSignal.subscribeNext {
                _ in
                self!.services.popActiveModal()
            }
            
            composeTweetViewModel.executeComposeTweet.executionValues()
                .doNextAs {
                (tweet: Tweet) in
                self!.tweets = [TweetCellViewModel(services: self!.services, tweet: tweet)] + self!.tweets
                }.flattenMapAs {
                    (tweet: Tweet) -> RACStream in
                    return self!.services.twitterService.updateStatus(tweet)
                }.subscribeNextAs {
                    (tweet: Tweet) in
                    let viewModel = TweetCellViewModel(services: self!.services, tweet: tweet)
                    self!.tweets[0] = viewModel
            }
            return RACSignal.empty()
        }
    }
}