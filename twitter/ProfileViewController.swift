//
//  ProfileViewController.swift
//  twitter
//
//  Created by Christopher Kintner on 2/28/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    var user: User!
    var isModal = true
    var delegate: MenuControllerDelegate?
        
    @IBOutlet weak private var bannerImage: UIImageView!
    @IBOutlet weak private var numTweetsLabel: UILabel!
    @IBOutlet weak private var numFollowingLabel: UILabel!
    @IBOutlet weak private var numFollowersLabel: UILabel!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var handleLabel: UILabel!
    @IBOutlet weak private var navBar: UINavigationBar!

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateForPerson() {
        var url = NSURL(string: user!.largeProfileImage())
        bannerImage.setImageWithURL(url)
        bannerImage.alpha = 0.6
        
        nameLabel.text = user.name!
        var screenName = user.screenname!
        handleLabel.text = "@\(user.screenname!)"
        
        numTweetsLabel.text = "\(user.tweetCount)"
        numFollowersLabel.text = "\(user.followersCount)"
        numFollowingLabel.text = "\(user.followingCount)"
        
        
    }
    
    @IBAction func doneTapped(sender: UIBarButtonItem) {
        if isModal {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            delegate?.toggleLeftPanel()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (user != nil) {
            updateForPerson()
        }
        
        var item = navBar.items[0] as UINavigationItem
        item.title = "Profile"
        
        if !isModal {
            item.leftBarButtonItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Done, target: self, action: "doneTapped:")
        }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
