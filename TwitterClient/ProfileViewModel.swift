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
    
    let avatarImageURL: NSURL?
    var bannerImageURL: NSURL? = nil
    
    private let services: ViewModelServices
    
    // MARK: API
    
    init(services: ViewModelServices, profile: Profile) {
        self.services = services
        avatarImageURL = NSURL(string: profile.user.profileImageUrl!)
        if profile.profileBannerImageURL != nil {
            bannerImageURL = NSURL(string: profile.profileBannerImageURL!)
        }

        super.init()
    }
}
