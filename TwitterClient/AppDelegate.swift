//
//  AppDelegate.swift
//  TwitterClient
//
//  Created by Josh Lehman on 2/19/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController!
    
    var viewModel: AuthViewModel!
    var viewModelServices: ViewModelServices!
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        navigationController = UINavigationController()
        viewModelServices = ViewModelServices(navigationController: navigationController)
        viewModel = AuthViewModel(services: viewModelServices)
        let viewController = AuthViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: false)
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window!.makeKeyAndVisible()
        window!.rootViewController = navigationController
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 0.361, green: 0.686, blue: 0.925, alpha: 1)
        
        let titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        UINavigationBar.appearance().titleTextAttributes = titleTextAttributes
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().tintColor = UIColor.whiteColor()
        UIBarButtonItem.appearance().setTitleTextAttributes(titleTextAttributes, forState: UIControlState.Normal)
        
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        viewModelServices.twitterService.executeOpenURL.execute(url)                
        
        return true
    }
    
}

