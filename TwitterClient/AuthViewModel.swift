//
//  AuthViewModel.swift
//  TwitterClient
//
//  Created by Josh Lehman on 2/19/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import Foundation

class AuthViewModel: NSObject {
    
    // MARK: Properties
    
    var executeTwitterLogin: RACCommand!
    
    private let services: ViewModelServices
    private var tweetsViewModel: TweetsTableViewModel
    
    // MARK: API
    
    init(services: ViewModelServices) {
        self.services = services
        self.tweetsViewModel = TweetsTableViewModel(services: self.services)
        super.init()
        
        executeTwitterLogin = RACCommand() {
            input -> RACSignal in
            return self.services.twitterService.twitterLogin()
        }
        
        services.twitterService.executeOpenURL.executionValues()
            .deliverOn(RACScheduler.mainThreadScheduler())
            .subscribeNext { _ in
            services.pushViewModel(self.tweetsViewModel)
        }

    }
    
    func checkCurrentUser() {
        if User.currentUser != nil {
            services.pushViewModel(tweetsViewModel)
        }
    }
}