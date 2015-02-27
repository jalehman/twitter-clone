//
//  ContainerViewController.swift
//  TwitterClient
//
//  Created by Josh Lehman on 2/26/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet var panGR: UIPanGestureRecognizer!
    @IBOutlet var tapGR: UITapGestureRecognizer!
    
    let centerPanelExpandedOffset: CGFloat = 60
    let containedNavigationController: UINavigationController
    
    private let viewModel: ContainerViewModel
    private let tweetsTableViewController: TweetsTableViewController
    private var sideMenuViewController: SideMenuViewController?
    
    private var shouldExpandDebug: Bool = true

    // MARK: API
    
    init(viewModel: ContainerViewModel) {
        self.viewModel = viewModel
        self.tweetsTableViewController = TweetsTableViewController(viewModel: viewModel.tweetsTableViewModel)
        self.containedNavigationController = UINavigationController(rootViewController: self.tweetsTableViewController)
        super.init(nibName: "ContainerViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add the tweets table vc as a subview, and a child vc
        view.addSubview(containedNavigationController.view)
        addChildViewController(containedNavigationController)
        containedNavigationController.didMoveToParentViewController(self)
        
        containedNavigationController.view.frame = view.frame
        
        // Twitter style back button with back arrow only
        let newBackButton = UIBarButtonItem(title: "", style: .Bordered, target: nil, action: nil)
        newBackButton.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState: .Normal)
        self.navigationItem.backBarButtonItem = newBackButton
        
        /*panGR.rac_gestureSignal().subscribeNextAs { [weak self] (sender: UIPanGestureRecognizer) in
            self!.animateSidePanel(self!.shouldExpandDebug)
        self!.shouldExpandDebug = false
        }*/
        tapGR.rac_gestureSignal().subscribeNextAs { [weak self] (sender: UITapGestureRecognizer) in
            self!.animateSidePanel(self!.shouldExpandDebug)
            self!.shouldExpandDebug = !self!.shouldExpandDebug
        }
    }
    
    // MARK: Private
    
    private func animateSidePanel(shouldExpand: Bool) {
        if (shouldExpand) {
            sideMenuViewController = SideMenuViewController(viewModel: viewModel.sideMenuViewModel)
            
            view.insertSubview(sideMenuViewController!.view, atIndex: 0)
            addChildViewController(sideMenuViewController!)
            sideMenuViewController!.didMoveToParentViewController(self)
            
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(tweetsTableViewController.view.frame) - centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { [weak self] finished in
                
                self!.sideMenuViewController?.view.removeFromSuperview()
                self!.sideMenuViewController = nil
            }
        }
    }
    
    private func animateCenterPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.containedNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
}
