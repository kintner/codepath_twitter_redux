//
//  TweetsViewController.swift
//  twitter
//
//  Created by Christopher Kintner on 2/19/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//
import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellDelegate {
    var tweets: [Tweet]?
    var refreshControl: UIRefreshControl!
    
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser!.logout()
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
        cell.delegate = self
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let path = self.tableView.indexPathForSelectedRow()!
        var vc = segue.destinationViewController as TweetDetailController
        
        vc.setTweet(tweets![path.row])
    }
    
   
    
    func retweet(cell: TweetCell) {
        var tweet = cell.tweet
        
        if (tweet.retweeted!) {
            cell.retweetButton.selected = false
            cell.tweet.undoretweet(handleError)
        } else {
            cell.retweetButton.selected = true
            cell.tweet.undoretweet(handleError)
        }
        
    }
    
    func favorite(cell: TweetCell) {
        var tweet = cell.tweet
        
        if (tweet.favorited!) {
            cell.starButton.selected = false
            cell.tweet.undofavorite(handleError)
        } else {
            cell.starButton.selected = true
            cell.tweet.favorite(handleError)
        }
        
    }
    
    func handleError(error: NSError?) {
        if error != nil {
            let alert = UIAlertController(title: "API Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            
        }
        
    }


}
