//
//  TweetsViewController.swift
//  twitter
//
//  Created by Christopher Kintner on 2/19/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//
import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tweets: [Tweet]?
    var refreshControl: UIRefreshControl!
    
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 125
        
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "doRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        doRefresh()
        

        
    }
    
    func doRefresh() {
        refreshControl.endRefreshing()
        SVProgressHUD.show()
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: {(tweets: [Tweet]?, error: NSError?) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
        })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("tweet-cell") as TweetCell
        cell.updateFromTweet(tweets![indexPath.row])
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }
    
  

}
