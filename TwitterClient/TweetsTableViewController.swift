//
//  TweetsTableViewController.swift
//  TwitterClient
//
//  Created by Josh Lehman on 2/19/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import UIKit

class TweetsTableViewController: UIViewController, UITableViewDataSource {
    
    // MARK: Properties
    
    @IBOutlet weak var tweetsTable: UITableView!
    
    private let viewModel: TweetsTableViewModel
    private var logoutButton: UIBarButtonItem!
    
    // MARK: API
    
    init(viewModel: TweetsTableViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "TweetsTableViewController", bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = .None
        
        tweetsTable.dataSource = self
        
        tweetsTable.registerNib(UINib(nibName: "TweetTableViewCell", bundle: nil), forCellReuseIdentifier: "tweetCell")
        tweetsTable.rowHeight = UITableViewAutomaticDimension
        
        logoutButton = UIBarButtonItem(title: "Logout", style: .Bordered, target: nil, action: "")
        navigationItem.leftBarButtonItem = logoutButton
        
        navigationItem.title = "Home"
        
        bindViewModel()
    }
    
    func bindViewModel() {
        logoutButton.rac_command = viewModel.executeLogout
        viewModel.executeFetchTweets.execute(nil)
        
        RACObserve(viewModel, "tweets").subscribeNext {
            _ in
            self.tweetsTable.reloadData()
        }
        
    }
    
    // MARK: UITableViewController Overrides
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = viewModel.tweets[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell") as TweetTableViewCell
        cell.bindViewModel(item)
        return cell
    }
}
