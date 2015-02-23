//
//  RACCommand+Extensions.swift
//  TwitterClient
//
//  Created by Josh Lehman on 2/19/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import Foundation

extension RACCommand {
    func executionValues() -> RACSignal {
        return self.executionSignals.flattenMap { $0 as! RACStream }
    }    
}