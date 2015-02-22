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
    
    
    func updateFromTweet(tweet: Tweet) {
        self.tweetText.text = tweet.text
        if (tweet.user != nil && tweet.user?.profileImageUrl != nil) {
            var url = NSURL(string: tweet.user!.largeProfileImage())
            self.avatarImage.setImageWithURL(url)
            self.avatarImage.layer.cornerRadius = 5
        }
        
        self.nameLabel.text = tweet.user?.name
        self.handleLabel.text = "@\(tweet.user!.screenname!)"
        
    }
}
