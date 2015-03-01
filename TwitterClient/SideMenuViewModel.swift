//
//  SideMenuViewModel.swift
//  TwitterClient
//
//  Created by Josh Lehman on 2/26/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import UIKit

class SideMenuViewModel: NSObject {
   
    // MARK: Properties
    
    var executeShowCurrentUserProfile: RACCommand!
    
    private let services: ViewModelServices
    
    // MARK: API
    
    init(services: ViewModelServices) {
        self.services = services
        super.init()
        
        executeShowCurrentUserProfile = RACCommand() { input -> RACSignal in
            return services.twitterService.userInfo(User.currentUser!)
        }
    }
    
}