//
//  SideMenuViewController.swift
//  TwitterClient
//
//  Created by Josh Lehman on 2/26/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import UIKit


class SideMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var linksTableView: UITableView!

    private var homeCell: UITableViewCell!
    private var mentionsCell: UITableViewCell!
    private var profileCell: UITableViewCell!
    private var logoutCell: UITableViewCell!
    
    private let viewModel: SideMenuViewModel
    
    // MARK: API
    
    init(viewModel: SideMenuViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SideMenuViewController", bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController Overrides        

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.361, green: 0.686, blue: 0.925, alpha: 1)
        linksTableView.backgroundColor = UIColor(red: 0.361, green: 0.686, blue: 0.925, alpha: 1)
        
        linksTableView.dataSource = self
        linksTableView.delegate = self

        homeCell = linkCell("Home")
        mentionsCell = linkCell("Mentions")
        profileCell = linkCell("Profile")
        logoutCell = linkCell("Log Out")
    }
    
    // MARK: UITableViewDataSource Impl
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: return homeCell
        case 1: return mentionsCell
        case 2: return profileCell
        case 3: return logoutCell
        default: fatalError("Unknown row \(indexPath.row)")
        }
    }

    // MARK: UITableViewDelegate Impl

    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.361, green: 0.686, blue: 0.925, alpha: 1)
        return view
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell == profileCell {
            viewModel.executeShowCurrentUserProfile.execute(nil)
        } else if cell == homeCell {
            viewModel.executeShowHome.execute(nil)
        } else if cell == mentionsCell {
            viewModel.executeShowMentions.execute(nil)
        } else if cell == logoutCell {
            viewModel.executeLogout.execute(nil)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK Private
    
    private func linkCell(text: String) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel!.text = text
        cell.backgroundColor = UIColor(red: 0.361, green: 0.686, blue: 0.925, alpha: 1)
        return cell
    }

}
