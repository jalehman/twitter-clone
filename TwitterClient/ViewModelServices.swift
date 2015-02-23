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
    private var appNavigationController: UINavigationController!
    private var modalNavigationStack: [UINavigationController] = []
    
    // MARK: API
    
    init(navigationController: UINavigationController) {
        self.rootNavigationController = navigationController
        self.twitterService = TwitterService()
    }
    
    // MARK: ViewModelServices Implementation
    
    func pushViewModel(viewModel: AnyObject) {
        if let tweetsTableViewModel = viewModel as? TweetsTableViewModel {
            appNavigationController = wrapNavigationController(TweetsTableViewController(viewModel: tweetsTableViewModel))
            rootNavigationController.presentViewController(appNavigationController, animated: false, completion: nil)
        } else if let tweetDetailViewModel = viewModel as? TweetDetailViewModel {
            appNavigationController.pushViewController(TweetDetailViewController(viewModel: tweetDetailViewModel), animated: true)
        } else if let composeTweetViewModel = viewModel as? ComposeTweetViewModel {
            let composeTweetViewController: UINavigationController = wrapNavigationController(ComposeTweetViewController(viewModel: composeTweetViewModel))
            modalNavigationStack.push(composeTweetViewController)
            appNavigationController.presentViewController(modalNavigationStack.peekAtStack()!, animated: true, completion: nil)
        }
    }
    
    func popToRootViewModel() {
        appNavigationController.dismissViewControllerAnimated(true, completion: nil)
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