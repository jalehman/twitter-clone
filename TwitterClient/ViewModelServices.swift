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
    
    private let rootNavigationController: UINavigationController
    private var authNavigationController: UINavigationController!
    private var modalNavigationStack: [UINavigationController] = []
    
    // MARK: API
    
    init(navigationController: UINavigationController) {
        self.rootNavigationController = navigationController
        self.twitterService = TwitterService()
    }
    
    // MARK: ViewModelServices Implementation
    
    func pushViewModel(viewModel: AnyObject) {
        if let tweetsTableViewModel = viewModel as? TweetsTableViewModel {
            authNavigationController = wrapNavigationController(TweetsTableViewController(viewModel: tweetsTableViewModel))
            rootNavigationController.presentViewController(authNavigationController, animated: false, completion: nil)
        } else if let tweetDetailViewModel = viewModel as? TweetDetailViewModel {
            authNavigationController.pushViewController(TweetDetailViewController(viewModel: tweetDetailViewModel), animated: true)
        }
    }
    
    func popToRootViewModel() {
        authNavigationController.dismissViewControllerAnimated(true, completion: nil)
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