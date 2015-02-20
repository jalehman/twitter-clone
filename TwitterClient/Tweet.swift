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
    let createdAtString: String?
    let createdAt: NSDate?
    let dictionary: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.user = User(dictionary: dictionary["user"] as NSDictionary)
        self.text = dictionary["text"] as? String
        self.createdAtString = dictionary["created_at"] as? String
        self.dictionary = dictionary
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(self.createdAtString!)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        return array.map { Tweet(dictionary: $0) }        
    }
}