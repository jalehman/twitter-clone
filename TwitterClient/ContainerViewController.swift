//
//  ContainerViewController.swift
//  TwitterClient
//
//  Created by Josh Lehman on 2/26/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import UIKit

// TODO: Remove or use
extension NSLayoutConstraint {
    class func addMultipleConstraints(views: [String: AnyObject], view: UIView, vflConstraints: [String], options: NSLayoutFormatOptions = nil, metrics: [NSObject:AnyObject]? = nil) {
        for vfl in vflConstraints {
            let constraint = NSLayoutConstraint.constraintsWithVisualFormat(vfl, options: options, metrics: metrics, views: views)
            view.addConstraints(constraint)
        }
    }
}

class ContainerViewController: UIViewController {
    
    // MARK: Properties

    var panGR: UIPanGestureRecognizer!
    var tapGR: UITapGestureRecognizer!
    
    let centerPanelExpandedOffset: CGFloat = 60
    let containedNavigationController: UINavigationController
    
    private let viewModel: ContainerViewModel
    private let tweetsTableViewController: TweetsTableViewController
    private var sideMenuViewController: SideMenuViewController?
    
    private var startingCenterX: CGFloat!
    
    private var containerExpanded: Bool = false {
        didSet {
            showShadowForCenterViewController(containerExpanded)
        }
    }
    
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
        
        // TODO: Do this with constraints
        containedNavigationController.view.frame = view.frame
        
        panGR = UIPanGestureRecognizer()
        containedNavigationController.view.addGestureRecognizer(panGR)
        
        tapGR = UITapGestureRecognizer()
        containedNavigationController.view.addGestureRecognizer(tapGR)
        tapGR.enabled = false                
        
        panGR.rac_gestureSignal().subscribeNextAs { [weak self] (sender: UIPanGestureRecognizer) in
            self!.handlePanGesture(sender)
        }
        
        tapGR.rac_gestureSignal().subscribeNextAs { [weak self] (sender: UITapGestureRecognizer) in
            self!.animateSidePanel(false)
        }
        
        bindViewModel()
    }
    
    override func viewDidAppear(animated: Bool) {
        startingCenterX = containedNavigationController.view.center.x
    }
    
    // MARK: Private
    
    private func bindViewModel() {
        viewModel.shouldCloseSideMenuSignal.subscribeNext { [weak self] _ in
            self!.animateSidePanel(false)
        }
    }
    
    private func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = recognizer.velocityInView(view).x > 0 && recognizer.translationInView(view).x > 0
        
        switch(recognizer.state) {
        case .Began:
            if !containerExpanded {
                if (gestureIsDraggingFromLeftToRight) {
                    addSideMenuViewController()
                    showShadowForCenterViewController(true)
                }
            }
        case .Changed:
            if recognizer.view!.center.x > startingCenterX || gestureIsDraggingFromLeftToRight {
                // The user might start dragging from right to left, then change direction -- in this case the side menu view controller will never be instantiated and added to the view.
                if !containerExpanded {
                    addSideMenuViewController()
                    showShadowForCenterViewController(true)
                }
                recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translationInView(view).x
                recognizer.setTranslation(CGPointZero, inView: view)
            }
        case .Ended:
            if (sideMenuViewController != nil) {
                // animate the side panel open or closed based on whether the view has moved more or less than halfway
                let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
                animateSidePanel(hasMovedGreaterThanHalfway)
            }
        default:
            break
        }
    }
    
    private func addSideMenuViewController() {
        if sideMenuViewController == nil {
            sideMenuViewController = SideMenuViewController(viewModel: viewModel.sideMenuViewModel)
            view.insertSubview(sideMenuViewController!.view, atIndex: 0)
            addChildViewController(sideMenuViewController!)
            sideMenuViewController!.didMoveToParentViewController(self)
            
            sideMenuViewController!.view.frame = view.frame
        }
    }
    
    private func animateSidePanel(shouldExpand: Bool) {
        if (shouldExpand) {
            containerExpanded = true
            tapGR.enabled = true
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(tweetsTableViewController.view.frame) - centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { [weak self] finished in
                self!.containerExpanded = false
                self!.sideMenuViewController?.view.removeFromSuperview()
                self!.sideMenuViewController = nil
                self!.tapGR.enabled = false
            }
        }
    }
    
    private func animateCenterPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.containedNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    private func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            containedNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            containedNavigationController.view.layer.shadowOpacity = 0.0
        }
    }

}
