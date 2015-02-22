//
//  TweetCell.swift
//  twitter
//
//  Created by Christopher Kintner on 2/19/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var starButton: UIButton!
    
    var tweet: Tweet!
    var starred = false
    var replied = false
    var delegate: TweetCellDelegate?
    
    override func awakeFromNib() {
        var retweetEnabled = UIImage(named: "retweetEnabled")
        retweetButton.setImage(retweetEnabled, forState: UIControlState.Selected)

        var starred = UIImage(named: "favoriteEnabled")
        starButton.setImage(starred, forState: UIControlState.Selected)
        

    }
    
    
    func updateFromTweet(tweet: Tweet) {
        
        self.tweet = tweet
        self.tweetText.text = tweet.text
        if (tweet.user != nil && tweet.user?.profileImageUrl != nil) {
            var url = NSURL(string: tweet.user!.largeProfileImage())
            self.avatarImage.setImageWithURL(url)
            self.avatarImage.layer.cornerRadius = 5
        }
        
        self.nameLabel.text = tweet.user?.name
        self.handleLabel.text = "@\(tweet.user!.screenname!)"
        
        self.retweetButton.selected = tweet.retweeted!
        self.starButton.selected = tweet.favorited!
        
    }
    
    @IBAction func doRetweet(sender: AnyObject) {
        delegate?.retweet(self)
    }

    
    @IBAction func doStar(sender: AnyObject) {
        delegate?.favorite(self)
    }
    @IBAction func doReply(sender: AnyObject) {
    }
}

protocol TweetCellDelegate {
    func retweet(cell: TweetCell)
    func favorite(cell: TweetCell)
}
