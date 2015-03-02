//
//  User.swift
//  twitter
//
//  Created by Christopher Kintner on 2/19/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

import Foundation

var _currentUser: User?
let currentUserKey = "twitter_current_user_key"
let userDidLoginNotifiction = "userDidLoginNotification"
let userDidLogoutNotifiction = "userDidLogoutNotification"

class User {
    
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var tagline: String?
    var dict: NSDictionary?
    var tweetCount: Int!
    var followersCount: Int!
    var followingCount: Int!
    
    init(dict: NSDictionary) {
        self.dict = dict
        name = dict["name"] as? String
        screenname = dict["screen_name"] as? String
        profileImageUrl = dict["profile_image_url"] as? String
        tagline = dict["description"] as? String
        
        tweetCount = dict["statuses_count"] as Int
        followersCount = dict["followers_count"] as Int
        followingCount = dict["friends_count"] as Int
    }
    
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotifiction, object: self)
    }
    
    func largeProfileImage() -> String {
        let s = profileImageUrl!.stringByReplacingOccurrencesOfString("_normal", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        return s
    }

    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    var dict = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
                    _currentUser = User(dict: dict)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            if _currentUser != nil {
                var data = NSJSONSerialization.dataWithJSONObject(user!.dict!, options: nil, error: nil);
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            
            NSUserDefaults.standardUserDefaults().synchronize()
            
            
        }
    }

    
    
    
}