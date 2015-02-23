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
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var favoriteCount: Int?
    var retweetCount: Int?
    var retweetedBy: User? = nil
    var tweetId: Int?
    var retweeted: Bool = false
    var favorited: Bool = false
    var inReplyToStatusId: Int?
    
    var dictionary: NSDictionary?
    
    init(text: String, inReplyToStatusId: Int? = nil) {
        self.text = text
        self.user = User.currentUser
        self.createdAt = NSDate()
        self.createdAtString = DateService.sharedInstance.formatter.stringFromDate(self.createdAt!)
        self.inReplyToStatusId = inReplyToStatusId
        super.init()
    }
    
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
        
        self.retweeted = dictionary["retweeted"] as! Bool
        self.favorited = dictionary["favorited"] as! Bool
        
        self.tweetId = dictionary["id"] as? Int
        self.dictionary = dictionary
        
        let dateService = DateService.sharedInstance
        createdAt = dateService.formatter.dateFromString(self.createdAtString!)
        super.init()
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        return array.map { Tweet(dictionary: $0) }        
    }
}