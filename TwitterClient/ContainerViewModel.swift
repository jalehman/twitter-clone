//
//  ContainerViewModel.swift
//  TwitterClient
//
//  Created by Josh Lehman on 2/26/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import UIKit

class ContainerViewModel: NSObject {
    
    // MARK: Properties
    
    let tweetsTableViewModel: TweetsTableViewModel
    let sideMenuViewModel: SideMenuViewModel
    
    var shouldCloseSideMenuSignal: RACSignal!
    
    private let services: ViewModelServices
    
    // MARK: API
    
    init(services: ViewModelServices) {
        self.services = services
        self.tweetsTableViewModel = TweetsTableViewModel(services: services)
        self.sideMenuViewModel = SideMenuViewModel(services: services)
        super.init()
        
        let profileClickedSignal = sideMenuViewModel.executeShowCurrentUserProfile.executionSignals
        let homeClickedSignal = sideMenuViewModel.executeShowHome.executionSignals
        let mentionsClickedSignal = sideMenuViewModel.executeShowMentions.executionSignals
        
        sideMenuViewModel.executeShowCurrentUserProfile.executionValues()
            .subscribeNextAs { (profile: Profile) in
                let viewModel = ProfileViewModel(services: services, profile: profile)
                services.pushViewModel(viewModel)
        }
        
        homeClickedSignal.subscribeNext { _ in
            self.tweetsTableViewModel.executeFetchTweets.execute("home")
        }
        
        mentionsClickedSignal.subscribeNext { _ in
            self.tweetsTableViewModel.executeFetchTweets.execute("mentions")
        }

        shouldCloseSideMenuSignal = RACSignal.merge([profileClickedSignal, homeClickedSignal, mentionsClickedSignal])
        
    }
   
}
