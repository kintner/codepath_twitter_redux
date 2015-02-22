//
//  Tweet.swift
//  twitter
//
//  Created by Christopher Kintner on 2/19/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

import Foundation

class Tweet {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var dictionary: NSDictionary?
    
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        user = User(dict: dictionary["user"] as NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
    
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"

        createdAt = formatter.dateFromString(createdAtString!)
    }
    
    
    
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        return array.map({Tweet(dictionary: $0)})
    }
    
    
}