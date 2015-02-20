//
//  TwitterService.swift
//  TwitterClient
//
//  Created by Josh Lehman on 2/19/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import Foundation

class TwitterService: BDBOAuth1RequestOperationManager {
    
    // MARK: Properties
    
    let AUTH_URL_BASE = "https://api.twitter.com/oauth/authorize?oauth_token="
    let twitterBaseURL = NSURL(string: "https://api.twitter.com")
    let twitterConsumerKey = "C30J8TCseNs9Pdz4q3FFHJSAn"
    let twitterConsumerSecret = "q4kXNeiOaaSPg2t0EmR3uhz50ylebz55JgHxgQ0uXZ1zOIKseN"
    
    let executeOpenURL: RACCommand!
    
    override init() {
        super.init(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        
        executeOpenURL = RACCommand() {
            input -> RACSignal in
            let url = input as NSURL
            return self.openURL(url)
        }
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: API
    
    func twitterLogin() -> RACSignal {
        return RACSignal.createSignal {
            subscriber -> RACDisposable! in
            self.requestSerializer.removeAccessToken()
            self.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: {
                (requestToken: BDBOAuthToken!) in
                let authURL = NSURL(string: "\(self.AUTH_URL_BASE)\(requestToken.token)")
                subscriber.sendNext(authURL)
                subscriber.sendCompleted()
            }, failure: { (error: NSError!) in
                subscriber.sendError(error)
            })
            
            return nil
        }
    }
    
    func logout() -> RACSignal {
        User.currentUser = nil
        requestSerializer.removeAccessToken()
        return RACSignal.empty()
    }
    
    func fetchHomeTimelineTweets() -> RACSignal {
        return RACSignal.createSignal {
            subscriber -> RACDisposable! in
            self.GET("1.1/statuses/home_timeline.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) in
                let tweets = Tweet.tweetsWithArray(response as [NSDictionary])
                subscriber.sendNext(tweets)
                subscriber.sendCompleted()
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                    subscriber.sendError(error)
            })
            return nil
        }
    }

    // MARK: Private
    
    private func openURL(url: NSURL) -> RACSignal {
        return openURLSignal(url).flattenMap { _ -> RACStream in self.fetchUserSignal() }
    }
    
    private func openURLSignal(url: NSURL) -> RACSignal {
        return RACSignal.createSignal {
            subscriber -> RACDisposable! in
            self.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuthToken(queryString: url.query), success: {
                (accessToken: BDBOAuthToken!) in
                let success = self.requestSerializer.saveAccessToken(accessToken)
                subscriber.sendNext(success)
                subscriber.sendCompleted()
                }, failure: { (error: NSError!) in
                    subscriber.sendError(error)
                    
            })
            return nil
        }
    }
    
    private func fetchUserSignal() -> RACSignal {
        return RACSignal.createSignal {
            subscriber -> RACDisposable! in
            
            self.GET("1.1/account/verify_credentials.json", parameters: nil, success: {
                (operation: AFHTTPRequestOperation!, response: AnyObject!) in
                let user = User(dictionary: response as NSDictionary)
                User.currentUser = user
                subscriber.sendNext(user)
                subscriber.sendCompleted()
                }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                    subscriber.sendError(error)
            })
            
            return nil
        }
    }
}