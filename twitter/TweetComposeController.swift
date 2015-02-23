//
//  TweetComposeController.swift
//  twitter
//
//  Created by Christopher Kintner on 2/22/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

import UIKit

class TweetComposeController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var composeTextView: UITextView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tweetBarButton: UIBarButtonItem!
    
    var inReplyTo: Tweet?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var user = User.currentUser!
        var url = user.largeProfileImage()
        profileImageView.setImageWithURL(NSURL(string: url)!)
        screennameLabel.text = user.name!
        handleLabel.text = user.screenname!
        
        if isReply() {
            setupReply()
            var username = inReplyTo!.user!.screenname!
            composeTextView.text = "@\(username) "
        }
        
        composeTextView.becomeFirstResponder()

    }
    
    func setupReply() {
        navBar.topItem?.title = "Reply"
        tweetBarButton.title = "Reply"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func isReply() -> Bool {
        return inReplyTo != nil
    }
    
    

    
    @IBAction func doTweet(sender: AnyObject) {
        SVProgressHUD.show()
        TwitterClient.sharedInstance.tweet(composeTextView.text, params: NSDictionary(), inReplyTo: inReplyTo, completion: tweetCallback)
    }
    
    func tweetCallback(tweet: Tweet?, error: NSError?) {
        SVProgressHUD.dismiss()
        
        if (error == nil) {
            NSNotificationCenter.defaultCenter().postNotificationName("newTweetTweetedNotification", object: self, userInfo: ["tweet": tweet!])
            
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            self.handleError(error)
        }
        
    }
    
    
    @IBAction func doCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func handleError(error: NSError?) {
        if error != nil {
            NSLog("error: %@", error!.localizedDescription)
            let alert = UIAlertController(title: "API Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            
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
