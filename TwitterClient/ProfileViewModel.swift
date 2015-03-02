//
//  ProfileViewModel.swift
//  TwitterClient
//
//  Created by Josh Lehman on 3/1/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import UIKit

class ProfileViewModel: NSObject {
   
    // MARK: Properties
    
    let userName: String
    let screenName: String
    let avatarImageURL: NSURL?
    var bannerImageURL: NSURL? = nil
    let numFollowing: Int
    let numFollowers: Int
    let numTweets: Int
    var bio: String?
    var location: String?
    
    private let services: ViewModelServices
    
    // MARK: API
    
    init(services: ViewModelServices, profile: Profile) {
        self.services = services
        self.avatarImageURL = NSURL(string: profile.user.profileImageUrl!)
        self.userName = profile.user.name!
        self.screenName = profile.user.screenname!
        self.bio = profile.bio
        self.location = profile.location
        self.numFollowing = profile.numFollowing
        self.numFollowers = profile.numFollowers
        self.numTweets = profile.numTweets
        
        if profile.profileBannerImageURL != nil {
            bannerImageURL = NSURL(string: profile.profileBannerImageURL!)
        }

        super.init()
    }
}
