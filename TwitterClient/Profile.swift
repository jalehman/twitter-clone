//
//  Profile.swift
//  TwitterClient
//
//  Created by Josh Lehman on 3/1/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import UIKit

class Profile: NSObject {
    
    let user: User
    let numFollowing: Int
    let numFollowers: Int
    let numTweets: Int
    let bio: String?
    let location: String?
    let profileBannerImageURL: String?
   
    init(user: User, dictionary: NSDictionary) {
        self.user = user
        self.numFollowing = dictionary["friends_count"] as! Int
        self.numFollowers = dictionary["followers_count"] as! Int
        self.numTweets = dictionary["statuses_count"] as! Int
        self.bio = dictionary["description"] as? String
        self.location = dictionary["location"] as? String
        self.profileBannerImageURL = dictionary["profile_banner_url"] as? String
        
        super.init()
    }

}
