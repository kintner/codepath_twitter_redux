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
    
    func updateFromTweet(tweet: Tweet) {
        self.tweetText.text = tweet.text
        if (tweet.user != nil && tweet.user?.profileImageUrl != nil) {
            var url = NSURL(string: tweet.user?.profileImageUrl as String!)
            self.imageView?.setImageWithURL(url)
        }
        
    }
}
