//
//  TweetDetailController.swift
//  twitter
//
//  Created by Christopher Kintner on 2/22/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

import UIKit

class TweetDetailController: UIViewController {
    var tweet: Tweet!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    @IBAction func favoriteTapped(sender: UIButton) {
        
        if (tweet.favorited!) {
            favoriteButton.selected = false
            tweet.undofavorite(handleError)
        } else {
            favoriteButton.selected = true
            tweet.favorite(handleError)
        }
        
    }
    
    @IBAction func retweetTapped(sender: UIButton) {
        if (tweet.retweeted!) {
            retweetButton.selected = false
            tweet.undoretweet(handleError)
        } else {
            retweetButton.selected = true
            tweet.retweet(handleError)
        }
    }
    
    @IBAction func replyTapped(sender: UIButton) {
    
    }
    
    

    
    func handleError(error: NSError?) {
        if error != nil {
            let alert = UIAlertController(title: "API Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        var retweetEnabled = UIImage(named: "retweetEnabled")
        retweetButton.setImage(retweetEnabled, forState: UIControlState.Selected)
        
        var starred = UIImage(named: "favoriteEnabled")
        favoriteButton.setImage(starred, forState: UIControlState.Selected)

        updateFromTweet()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func setTweet(tweet: Tweet) {
        self.tweet = tweet
    }
    
    func updateFromTweet() {
        self.tweetLabel.text = tweet.text
        
        if (tweet.user != nil && tweet.user?.profileImageUrl != nil) {
            var url = NSURL(string: tweet.user!.largeProfileImage())
            self.profileImageView.setImageWithURL(url)
            self.profileImageView.layer.cornerRadius = 5
        }
        
        self.screenNameLabel.text = tweet.user?.name
        self.handleLabel.text = "@\(tweet.user!.screenname!)"
        self.timestampLabel.text = tweet.createdAtString
        
        self.retweetButton.selected = tweet.retweeted!
        self.favoriteButton.selected = tweet.favorited!
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var vc = segue.destinationViewController as TweetComposeController
        vc.inReplyTo = tweet
    }
    
    

}
