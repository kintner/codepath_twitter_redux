//
//  TweetsViewController.swift
//  twitter
//
//  Created by Christopher Kintner on 2/19/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//
import UIKit

class TweetsViewController: UIViewController {
    var tweets: [Tweet]?

    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    override func viewDidLoad() {
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: {(tweets: [Tweet]?, error: NSError?) -> () in
            self.tweets = tweets
        })
        
    }
}
