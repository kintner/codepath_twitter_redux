//
//  ContainerViewController.swift
//  twitter
//
//  Created by Christopher Kintner on 2/28/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, MenuControllerDelegate, UIGestureRecognizerDelegate {
    
    private var tweetsViewController: TwiiterNavViewController!
    private var profileViewController: ProfileViewController!
    private var menuViewController: MenuController!
    private var metionsController: TwiiterNavViewController!
    
    @IBOutlet weak var containerView: UIView!
    
    var menuVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        var board = UIStoryboard(name: "Main", bundle: nil)
        
        // SETUP TWEETS
        tweetsViewController = board.instantiateViewControllerWithIdentifier("TwitterNavViewController") as TwiiterNavViewController
        var tweetsController = tweetsViewController.childViewControllers[0] as TweetsViewController
        tweetsController.menuDelegate = self
        
        displayVC(tweetsViewController)
        
        
        // SETUP MENU
        menuViewController = storyboard?.instantiateViewControllerWithIdentifier("menu-controller") as MenuController
        menuViewController.delegate = self

        view.insertSubview(menuViewController.view, atIndex: 0)
        addChildViewController(menuViewController)
        menuViewController.didMoveToParentViewController(self)
        
        // SETUP Profile
        profileViewController = storyboard?.instantiateViewControllerWithIdentifier("profile-view-controller") as ProfileViewController
        profileViewController.isModal = false
        profileViewController.delegate = self
        
        //SETUP MENTIONS
        
        metionsController = board.instantiateViewControllerWithIdentifier("TwitterNavViewController") as TwiiterNavViewController
        var tc = metionsController.childViewControllers[0] as TweetsViewController
        tc.isMentions = true
        tc.menuDelegate = self
        
        
        displayVC(tweetsViewController)
              
        // ADD GESTURES
        var tapGesture = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        tapGesture.delegate = self
        containerView.addGestureRecognizer(tapGesture)
        
        var edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "handleEdgePan:")
        edgePanGesture.edges = UIRectEdge.Left
        view.addGestureRecognizer(edgePanGesture)
       
        

    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return menuVisible
    }
    
    
    func toggleLeftPanel() {
        animateLeftPanel(shouldExpand: !menuVisible)
    }
    
    func showMentions() {
        displayVC(metionsController)
        animateLeftPanel(shouldExpand: false)
    }
    
    func showProfile() {
        profileViewController.user = User.currentUser
        displayVC(profileViewController)
        
        animateLeftPanel(shouldExpand: false)
    }
    
    func showTimeline() {
        displayVC(tweetsViewController)
        animateLeftPanel(shouldExpand: false)
    }
    
    func displayVC(vc: UIViewController) {
        addChildViewController(vc)
        vc.view.frame = containerView.bounds
        containerView.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
        
    }

    
    func animateLeftPanel(#shouldExpand: Bool) {
        if (shouldExpand) {
            menuVisible = true
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(containerView.frame) - 150)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.menuVisible = false
                UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
            }
        }
    }
    

    

    func animateCenterPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.containerView.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func handleTapGesture(sender: UITapGestureRecognizer) {
        if (sender.state == .Ended) {
            animateLeftPanel(shouldExpand: false)
        }
        
    }
    
    func handleEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        NSLog("edgePan: \(sender.state)")
        if sender.state == UIGestureRecognizerState.Ended {
            animateLeftPanel(shouldExpand: true)
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
