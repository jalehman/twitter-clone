//
//  ViewModelServices.swift
//  TwitterClient
//
//  Created by Josh Lehman on 2/19/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import Foundation
import UIKit

class ViewModelServices: NSObject {
    
    // MARK: Properties
    
    let twitterService: TwitterService
    
    private let authNavigationController: UINavigationController
    private var containerViewController: ContainerViewController!
    private var masterNavigationController: UINavigationController!
    private var modalNavigationStack: [UINavigationController] = []
    
    // MARK: API
    
    init(navigationController: UINavigationController) {
        self.authNavigationController = navigationController
        self.twitterService = TwitterService()
    }
    
    // MARK: ViewModelServices Implementation
    
    func pushViewModel(viewModel: AnyObject) {
        if let containerViewModel = viewModel as? ContainerViewModel {
            containerViewController = ContainerViewController(viewModel: containerViewModel)
            masterNavigationController = containerViewController.containedNavigationController
            authNavigationController.presentViewController(containerViewController, animated: false, completion: nil)
        } else if let tweetDetailViewModel = viewModel as? TweetDetailViewModel {
            masterNavigationController.pushViewController(TweetDetailViewController(viewModel: tweetDetailViewModel), animated: true)
        } else if let composeTweetViewModel = viewModel as? ComposeTweetViewModel {
            let composeTweetViewController: UINavigationController = wrapNavigationController(ComposeTweetViewController(viewModel: composeTweetViewModel))
            modalNavigationStack.push(composeTweetViewController)
            masterNavigationController.presentViewController(modalNavigationStack.peekAtStack()!, animated: true, completion: nil)
        } else if let profileViewModel = viewModel as? ProfileViewModel {
            masterNavigationController.pushViewController(ProfileViewController(viewModel: profileViewModel), animated: true)
        }
    }
    
    func popToRootViewModel() {
        masterNavigationController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func popActiveModal() {
        let activeModal: UIViewController = modalNavigationStack.pop()!
        activeModal.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Private
    
    private func wrapNavigationController(vc: UIViewController) -> UINavigationController {
        let navC: UINavigationController = UINavigationController(rootViewController: vc)
        return navC
    }
}