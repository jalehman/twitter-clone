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
            [unowned self] any in
            let tweets = any as! [Tweet]
            self.tweets = tweets.map { TweetCellViewModel(services: self.services, tweet: $0) }
        }
        
        executeViewTweetDetails = RACCommand() {
            [unowned self] input -> RACSignal in
            let tweetCellViewModel = input as! TweetCellViewModel
            self.services.pushViewModel(TweetDetailViewModel(services: self.services, tweet: tweetCellViewModel.tweet))
            return RACSignal.empty()
        }        
    }

}