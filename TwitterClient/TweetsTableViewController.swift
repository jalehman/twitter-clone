//
//  TweetsTableViewController.swift
//  TwitterClient
//
//  Created by Josh Lehman on 2/19/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import UIKit

class TweetsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties

    var refreshControl: UIRefreshControl!
    var loadingHUD: JGProgressHUD!
    @IBOutlet weak var tweetsTable: UITableView!
    
    private let viewModel: TweetsTableViewModel
    private var logoutButton: UIBarButtonItem!
    private var composeButton: UIBarButtonItem!
    
    // MARK: API
    
    init(viewModel: TweetsTableViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "TweetsTableViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = viewModel.tweets[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell") as! TweetTableViewCell
        cell.bindViewModel(item)
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = viewModel.tweets[indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        viewModel.executeViewTweetDetails.execute(item)
    }
    
    // MARK: UIViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = .None
        
        tweetsTable.dataSource = self
        tweetsTable.delegate = self
        
        refreshControl = UIRefreshControl()
        
        tweetsTable.registerNib(UINib(nibName: "TweetTableViewCell", bundle: nil), forCellReuseIdentifier: "tweetCell")
        tweetsTable.estimatedRowHeight = 88.0
        tweetsTable.rowHeight = UITableViewAutomaticDimension
        tweetsTable.insertSubview(refreshControl, atIndex: 0)

        loadingHUD = JGProgressHUD(style: .Dark)
        loadingHUD.textLabel.text = "Loading..."
        
        logoutButton = UIBarButtonItem(title: "Logout", style: .Bordered, target: nil, action: "")
        composeButton = UIBarButtonItem(barButtonSystemItem: .Compose, target: nil, action: "")
        
        bindViewModel()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        view.setNeedsUpdateConstraints()
        tweetsTable.reloadData()
        
        navigationController?.topViewController.navigationItem.leftBarButtonItem = logoutButton
        navigationController?.topViewController.navigationItem.rightBarButtonItem = composeButton
        navigationController?.topViewController.navigationItem.title = "Home"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        view.setNeedsUpdateConstraints()
        tweetsTable.reloadData()
    }
    
    // MARK: Private
    
    private func bindViewModel() {
        logoutButton.rac_command = viewModel.executeLogout
        composeButton.rac_command = viewModel.executeShowComposeTweet
        refreshControl.rac_command = viewModel.executeFetchTweets
        
        viewModel.executeFetchTweets.execute(nil)
        
        let fetchTweetsExecutingSignal = viewModel.executeFetchTweets.executing
        
        fetchTweetsExecutingSignal.subscribeNext { _ in
            self.loadingHUD.showInView(self.view)
        }
        
        fetchTweetsExecutingSignal.not().subscribeNext { _ in
            self.loadingHUD.dismiss()
        }
        
        RACObserve(viewModel, "tweets").subscribeNext {
            _ in
            self.tweetsTable.reloadData()
        }
        
    }

}
