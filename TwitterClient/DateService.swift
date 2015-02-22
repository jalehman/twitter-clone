//
//  DateService.swift
//  TwitterClient
//
//  Created by Josh Lehman on 2/19/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import Foundation

class DateService: NSObject {
    
    class var sharedInstance: DateService {
        struct Static {
            static let instance = DateService()
        }
        return Static.instance
    }
    
    let formatter = NSDateFormatter()
    let prettyFormatter = NSDateFormatter()
    
    override init() {
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        prettyFormatter.dateStyle = .ShortStyle
        prettyFormatter.timeStyle = .ShortStyle
        super.init()
    }
    
    func pretty(date: NSDate) -> String {
        return prettyFormatter.stringFromDate(date)
    }
    
}