//
//  ComposeTweetViewModel.swift
//  TwitterClient
//
//  Created by Josh Lehman on 2/22/15.
//  Copyright (c) 2015 Josh Lehman. All rights reserved.
//

import Foundation

class ComposeTweetViewModel: NSObject {
    
    // MARK: Properties
    dynamic var tweetText: String = ""
    var replyToUserScreenname: String?
    var characterLimit: Int = 140
    
    var executeComposeTweet: RACCommand!
    var executeCancelComposeTweet: RACCommand!
    
    private let services: ViewModelServices
    private var inReplyTo: Tweet?
    
    // MARK: API
    
    init(services: ViewModelServices, inReplyTo: Tweet? = nil) {
        self.services = services
        self.inReplyTo = inReplyTo
        
        if inReplyTo != nil {
            let userScreenName = inReplyTo!.user!.screenname!
            self.replyToUserScreenname = userScreenName
            self.characterLimit = 140 - (count(userScreenName) + 2) // the 2 is for the "@" character and space after the tweet text
        }
        
        super.init()
        
        let tweetTextAllowedSignal = RACObserve(self, "tweetText").mapAs {
            (text: NSString) -> NSNumber in
            return text.length <= self.characterLimit && text.length > 0
        }
        
        executeCancelComposeTweet = RACCommand() {
            input -> RACSignal in
            return RACSignal.empty()
        }
        
        executeComposeTweet = RACCommand(enabled: tweetTextAllowedSignal) {
            [unowned self] input -> RACSignal in
            return self.constructTweet()
        }
    }
    
    // MARK: Private

    private func constructTweet() -> RACSignal {
        var text: String = ""
        if inReplyTo != nil {
            text = "@\(inReplyTo!.user!.screenname!) "
        }
        text = text + tweetText
        return RACSignal.rac_return(Tweet(text: text))
    }
}