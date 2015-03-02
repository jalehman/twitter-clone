//
//  Int+Extensions.swift
//  TwitterClient
//
//  Created by Josh Lehman on 3/1/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

// from http://stackoverflow.com/questions/18267211/ios-convert-large-numbers-to-smaller-format

import Foundation

extension Int {
    func jl_abbreviatedFormat() -> NSString {
        var abbrevNum: NSString = ""
        var num = self
        var number = Double(num)
        
        func doubleToString(val: Double) -> NSString {
            var ret = NSString(format: "%.1f", val)
            var c = ret.characterAtIndex(ret.length - 1)
            
            while c == 48 { // 0
                ret = ret.substringToIndex(ret.length - 1)
                c = ret.characterAtIndex(ret.length - 1)
                
                //After finding the "." we know that everything left is the decimal number, so get a substring excluding the "."
                if(c == 46) { // .
                    ret = ret.substringToIndex(ret.length - 1)
                }
            }
            
            return ret
        }
        
        if (num > 1000) {
            let abbreviations = ["K", "M", "B"]
            for (var i = abbreviations.count - 1; i >= 0; i--) {
                let size: Double = pow(10.0, (Double(i)+1.0)*3.0)
                if size <= number {
                    // Removed the round and dec to make sure small numbers are included like: 1.1K instead of 1K
                    number = number/size
                    let numberString = doubleToString(number)
                    abbrevNum = NSString(format: "%@%@", numberString, abbreviations[i])
                }
            }
        } else {
            abbrevNum = NSString(format: "%d", Int(number))
        }
        
        return abbrevNum
    }
}