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
    private var containerViewModel: ContainerViewModel
    
    // MARK: API
    
    init(services: ViewModelServices) {
        self.services = services
        self.containerViewModel = ContainerViewModel(services: self.services)
        super.init()
        
        executeTwitterLogin = RACCommand() {
            input -> RACSignal in
            return self.services.twitterService.twitterLogin()
        }
        
        services.twitterService.executeOpenURL.executionValues()
            .deliverOn(RACScheduler.mainThreadScheduler())
            .subscribeNext { _ in
            services.pushViewModel(self.containerViewModel)
        }

    }
    
    func checkCurrentUser() {
        if User.currentUser != nil {
            services.pushViewModel(containerViewModel)
        }
    }
}