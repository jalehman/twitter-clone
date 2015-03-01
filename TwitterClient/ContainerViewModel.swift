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
        
        sideMenuViewModel.executeShowCurrentUserProfile.executionValues()
            .subscribeNextAs { [weak self] (profile: Profile) in
                let viewModel = ProfileViewModel(services: services, profile: profile)
                self!.services.pushViewModel(viewModel)
        }

        shouldCloseSideMenuSignal = profileClickedSignal
        
    }
   
}
