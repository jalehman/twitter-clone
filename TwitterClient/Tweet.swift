//
//  Tweet.swift
//  TwitterClient
//
//  Created by Josh Lehman on 2/19/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import Foundation

class Tweet: NSObject {
    // TODO: Make createdAt lazy
    // TODO: Static date formatter?
    let user: User?
    let text: String?
    var createdAtString: String?
    let createdAt: NSDate?
    let favoriteCount: Int?
    let retweetCount: Int?
    var retweetedBy: User? = nil
    
    let dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        if let retweet = dictionary["retweeted_status"] as? NSDictionary {
            self.retweetedBy = User(dictionary: dictionary["user"] as! NSDictionary)
            self.user = User(dictionary: retweet["user"] as! NSDictionary)
            self.text = retweet["text"] as? String
            self.createdAtString = retweet["created_at"] as? String
            self.favoriteCount = retweet["favorite_count"] as? Int
            self.retweetCount = retweet["retweet_count"] as? Int
        } else {
            self.user = User(dictionary: dictionary["user"] as! NSDictionary)
            self.text = dictionary["text"] as? String
            self.createdAtString = dictionary["created_at"] as? String
            self.favoriteCount = dictionary["favorite_count"] as? Int
            self.retweetCount = dictionary["retweet_count"] as? Int
        }
        
        self.dictionary = dictionary
        
        let dateService = DateService.sharedInstance
        createdAt = dateService.formatter.dateFromString(self.createdAtString!)
        super.init()
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        return array.map { Tweet(dictionary: $0) }        
    }
}