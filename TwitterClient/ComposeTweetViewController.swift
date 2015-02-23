//
//  ComposeTweetViewController.swift
//  TwitterClient
//
//  Created by Josh Lehman on 2/22/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    
    var cancelButton: UIBarButtonItem!
    var tweetButton: UIBarButtonItem!
    var countdownButton: UIBarButtonItem!
    
    private let viewModel: ComposeTweetViewModel
    private var hairlineImage: UIImageView?
    
    // MARK: API
    
    init(viewModel: ComposeTweetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "ComposeTweetViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = .None
        
        hairlineImage = findHairlineImageViewUnder(navigationController!.navigationBar)
        
        let disabledTextAttributes = [NSForegroundColorAttributeName: UIColor.lightGrayColor()]
        let enabledTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 0.361, green: 0.686, blue: 0.925, alpha: 1)]
        
        cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: nil, action: "")
        cancelButton.setTitleTextAttributes(enabledTextAttributes, forState: .Normal)
        self.navigationItem.leftBarButtonItem = cancelButton
        
        tweetButton = UIBarButtonItem(title: "Tweet", style: .Bordered, target: nil, action: "")
        tweetButton.setTitleTextAttributes(enabledTextAttributes, forState: .Normal)
        tweetButton.setTitleTextAttributes(disabledTextAttributes, forState: .Disabled)
        
        countdownButton = UIBarButtonItem(title: "140", style: .Bordered, target: nil, action: "")
        countdownButton.setTitleTextAttributes(disabledTextAttributes, forState: .Normal)
        countdownButton.setTitleTextAttributes(disabledTextAttributes, forState: .Disabled)
        countdownButton.enabled = false
        
        navigationItem.rightBarButtonItems = [tweetButton, countdownButton]
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 0.996, green: 0.996, blue: 0.996, alpha: 1.0)
        navigationController?.navigationBar.translucent = false
        
        avatarImage.layer.cornerRadius = 5.0
        avatarImage.clipsToBounds = true
        
        navigationController?.navigationBar.titleTextAttributes = enabledTextAttributes
        
        tweetTextView.becomeFirstResponder()
        
        bindViewModel()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        hairlineImage?.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        hairlineImage?.hidden = false
    }
    
    // MARK: Private
    
    private func bindViewModel() {
        avatarImage.setImageWithURL(NSURL(string: User.currentUser!.profileImageUrl!))
        userNameLabel.text = User.currentUser!.name!
        screenNameLabel.text = User.currentUser!.screenname!
        cancelButton.rac_command = viewModel.executeCancelComposeTweet
        tweetButton.rac_command = viewModel.executeComposeTweet
        
        if viewModel.replyToUserScreenname != nil {
            self.title = "R: @\(viewModel.replyToUserScreenname!)"
        }
        
        RAC(viewModel, "tweetText") << tweetTextView.rac_textSignal()
            .doNextAs { (text: NSString) in
                UIView.setAnimationsEnabled(false)
                self.countdownButton.title = String(self.viewModel.characterLimit - text.length)
                UIView.setAnimationsEnabled(true)
            }
    }
    
    private func findHairlineImageViewUnder(view: UIView) -> UIImageView? {
        if (view.isKindOfClass(UIImageView) && view.bounds.size.height <= 1.0) {
            return view as? UIImageView
        }
        
        for subview in view.subviews {
            let imageView = self.findHairlineImageViewUnder(subview as! UIView)
            if imageView != nil {
                return imageView
            }
        }
        return nil
    }
}
