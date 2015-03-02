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
    var executeShowHome: RACCommand!
    var executeShowMentions: RACCommand!
    var executeLogout: RACCommand!
    
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
        
        executeShowCurrentUserProfile = RACCommand() { input -> RACSignal in
            return services.twitterService.userInfo(User.currentUser!)
        }
        
        executeShowHome = RACCommand() { input -> RACSignal in
            services.popToBaseViewModel()
            return RACSignal.empty()
        }
        
        executeShowMentions = RACCommand() { input -> RACSignal in
            services.popToBaseViewModel()
            return RACSignal.empty()
        }
    }
    
}