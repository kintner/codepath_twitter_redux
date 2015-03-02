//
//  Twitterclient.swift
//  twitter
//
//  Created by Christopher Kintner on 2/17/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

import UIKit

let twitterConsumerKey = "qBOrqNOEw20imfVBtFM6TVJ3q"
let twitterConsumerSecret = "MUv4ngpZgSyQ0R1Y0IkSgEzX1cCI5sZLwuXVfORQfNZZjWijMZ"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
   
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey:twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        requestSerializer.removeAccessToken()
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL (string: "cptwitterdemo://oauth"), scope: nil, success: {(requestToken: BDBOAuth1Credential!) -> Void in
            println("Got the token")
            var authURL = "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)"
            println(authURL)
            UIApplication.sharedApplication().openURL(NSURL(string: authURL)!)
        }) { (error: NSError!) -> Void in
            self.loginCompletion?(user:nil, error: error)
            println("Failed to get token")
            
        }
        
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation:AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("tweets: \(response)")
            var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            
            completion(tweets: tweets, error: nil)
            
            }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                completion(tweets: nil, error: error)
        })
        
        
    }
    
    
    func mentions(completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        TwitterClient.sharedInstance.GET("1.1/statuses/mentions_timeline.json", parameters: NSDictionary(), success: { (operation:AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("tweets: \(response)")
            var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            
            completion(tweets: tweets, error: nil)
            
            }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                completion(tweets: nil, error: error)
        })
        
        
    }
    
    func simplePost(url: String, completion: (response: NSDictionary?, error: NSError?) -> ()) {
        
        let success = { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(response: response as? NSDictionary, error: nil)
        }
        
        let failure = { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            NSLog("error URL: %@,  dets: %@", url, error)
            completion(response: nil, error: error)
        }
        
        TwitterClient.sharedInstance.POST(url, parameters: nil, success: success, failure: failure)
        
    }
   
    func retweet(tweet: Tweet, completion: (response: NSDictionary?, error: NSError?) -> ()) {
        var url = "1.1/statuses/retweet/\(tweet.id!).json"
        simplePost(url, completion: completion)
    }
    
    
    func undoretweet(tweet: Tweet, completion: (response: NSDictionary?, error: NSError?) -> ()) {
        var url = "1.1/statuses/destroy/\(tweet.id!).json"
        simplePost(url, completion: completion)
    }
    
    func favorite(tweet: Tweet, completion: (response: NSDictionary?, error: NSError?) -> ()) {
        var url = "1.1/favorites/create.json?id=\(tweet.id!)"
        simplePost(url, completion: completion)
    }

    
    func unfavorite(tweet: Tweet, completion: (response: NSDictionary?, error: NSError?) -> ()) {
        var url = "1.1/favorites/destroy.json?id=\(tweet.id!)"
        simplePost(url, completion: completion)
    }
    
    
    func tweet(text: String, params: NSDictionary, inReplyTo: Tweet?, completion: (tweet: Tweet?, error: NSError?) -> ()) {

        let p = params.mutableCopy() as NSMutableDictionary
        p.setValue(text, forKey: "status")
        
        if (inReplyTo != nil) {
            p.setValue(inReplyTo!.id, forKey: "in_reply_to_status_id")
        }
        
        TwitterClient.sharedInstance.POST("1.1/statuses/update.json", parameters: p, success: { (operation:AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("tweet: \(response)")
            var tweet = Tweet(dictionary: response as NSDictionary)
            
            completion(tweet: tweet, error: nil)
            
            }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                completion(tweet: nil, error: error)
        })
    }


    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation:AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println("user: \(response)")
                var user = User(dict: response as NSDictionary)
                println("user: \(user.name)")
                User.currentUser = user
                self.loginCompletion?(user: user, error: nil)
                
                }, failure: { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                    self.loginCompletion?(user:nil, error: error)
                    println("afiled: ")
            })
            
            }) { (error: NSError!) -> Void in
                println("error!")
        }
    }
}
 