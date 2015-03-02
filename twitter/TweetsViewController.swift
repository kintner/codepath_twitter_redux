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
    var isMentions = false
    
    var menuDelegate: MenuControllerDelegate?
    
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var composeButton: UIBarButtonItem!
    
    @IBAction func onCompose(sender: AnyObject) {

        
    }
    
    
    @IBAction func onMenuTap(sender: UIButton) {
        menuDelegate?.toggleLeftPanel()
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 125
        automaticallyAdjustsScrollViewInsets = false
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "doRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "newTweetTweeted:", name: "newTweetTweetedNotification", object: nil)
        
        if isMentions {
            navigationItem.title = "Mentions"
        } else {
            navigationItem.title = "Profile"
        }
        
        
        doRefresh()

    }
    
    func doRefresh() {
        refreshControl.endRefreshing()
        SVProgressHUD.show()
        
        var completion = {(tweets: [Tweet]?, error: NSError?) -> () in
            SVProgressHUD.dismiss()
            if (tweets != nil) {
                self.tweets = tweets
                self.tableView.reloadData()
            }
            
            if (error != nil) {
                self.handleError(error)
            }
            
        }
        
        if isMentions {
                TwitterClient.sharedInstance.mentions(completion)
        
        } else {
            TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion:completion )
        }
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
        if segue.identifier! == "detail-segue" {
            let path = self.tableView.indexPathForSelectedRow()!
            var vc = segue.destinationViewController as TweetDetailController
            vc.setTweet(tweets![path.row])
        } else if segue.identifier! == "compose-segue" {
            var vc = segue.destinationViewController as TweetComposeController
        } else if segue.identifier! == "reply-segue" {
            var vc = segue.destinationViewController as TweetComposeController
            var button = sender as UIButton
            vc.inReplyTo = (button.superview!.superview as TweetCell).tweet
        }

    }
    
   
    func retweet(cell: TweetCell) {
        var tweet = cell.tweet
        
        if (tweet.retweeted!) {
            cell.retweetButton.selected = false
            cell.tweet.undoretweet(handleError)
        } else {
            cell.retweetButton.selected = true
            cell.tweet.retweet(handleError)
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
    
    func displayProfile(cell: TweetCell) {
        var board = UIStoryboard(name: "Main", bundle: nil)
        var vc = board.instantiateViewControllerWithIdentifier("profile-view-controller") as ProfileViewController
        vc.user = cell.tweet!.user!
        vc.viewWillAppear(true)
        
        
        navigationController?.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    func handleError(error: NSError?) {
        if error != nil {
            let alert = UIAlertController(title: "API Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            
        }
        
    }
    
    func newTweetTweeted(notification: NSNotification) {
        
        var dict = notification.userInfo! as [NSObject:AnyObject]
        var tweet = dict["tweet"] as Tweet
        
        tweets?.insert(tweet, atIndex: 0)
        var firstRow = NSIndexPath(forRow: 0, inSection: 0)
        tableView.insertRowsAtIndexPaths([firstRow], withRowAnimation: UITableViewRowAnimation.Automatic)
        tableView.scrollToRowAtIndexPath(firstRow, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    
    }
}
