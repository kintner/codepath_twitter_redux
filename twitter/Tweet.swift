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
    var id: Int?
    var retweeted: Bool?
    var favorited: Bool?
    
    
    init(dictionary: NSDictionary) {
        updateFromDict(dictionary)
    }
    
    func updateFromDict(dictionary: NSDictionary) {
        self.dictionary = dictionary
        user = User(dict: dictionary["user"] as NSDictionary)
        text = dictionary["text"] as String?
        
        id = dictionary["id"] as? Int
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(dictionary["created_at"]! as String)
        
        formatter = NSDateFormatter()
        formatter.dateFormat = "M/dd/yyy h:mm a"
        createdAtString = formatter.stringFromDate(createdAt!)
        
        
        let r = dictionary["retweeted"] as? Int
        retweeted =  r != nil && r == 1
        
        let f = dictionary["favorited"] as? Int
        favorited =  f != nil && f == 1
    }

    func retweet(completion: (error: NSError?) -> ()) {
        
        TwitterClient.sharedInstance.retweet(self, completion: { (response, error) -> () in
            println(response)
            completion(error: error)
            if (error == nil) {
                self.updateFromDict(response as NSDictionary!)
            }
        })
    }
    
    
    func undoretweet(completion: (error: NSError?) -> ()) {
        
        TwitterClient.sharedInstance.undoretweet(self, completion: { (response, error) -> () in
            println(response)
            completion(error: error)
            if (error == nil) {
                self.updateFromDict(response as NSDictionary!)
            }
        })
    }
    
    
    func favorite(completion: (error: NSError?) -> ()) {
        
        TwitterClient.sharedInstance.favorite(self, completion: { (response, error) -> () in
            println(response)
            completion(error: error)
            if (error == nil) {
                self.updateFromDict(response as NSDictionary!)
            }
        })
    }
    
    
    func undofavorite(completion: (error: NSError?) -> ()) {
        
        TwitterClient.sharedInstance.unfavorite(self, completion: { (response, error) -> () in
            println(response)
            completion(error: error)
            if (error == nil) {
                self.updateFromDict(response as NSDictionary!)
            }
        })
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        return array.map({Tweet(dictionary: $0)})
    }
    
    
}