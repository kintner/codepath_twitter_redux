//
//  ContainerViewController.swift
//  twitter
//
//  Created by Christopher Kintner on 2/28/15.
//  Copyright (c) 2015 Christopher Kintner. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController, MenuControllerDelegate, UIGestureRecognizerDelegate {
    
    var mainViewController: TwiiterNavViewController!
    var menuViewController: MenuController!
    
    var menuVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        var board = UIStoryboard(name: "Main", bundle: nil)
        mainViewController = board.instantiateViewControllerWithIdentifier("TwitterNavViewController") as TwiiterNavViewController
        
        view.addSubview(mainViewController.view)
        addChildViewController(mainViewController)
        mainViewController.didMoveToParentViewController(self)
        
        var tweetsController = mainViewController.childViewControllers[0] as TweetsViewController
        tweetsController.menuDelegate = self
        
        
        var tapGesture = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        tapGesture.delegate = self
        mainViewController.view.addGestureRecognizer(tapGesture)
        
        var edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "handleEdgePan:")
        edgePanGesture.edges = UIRectEdge.Left
        mainViewController.view.addGestureRecognizer(edgePanGesture)
       
        
        menuViewController = storyboard?.instantiateViewControllerWithIdentifier("menu-controller") as MenuController
        view.insertSubview(menuViewController.view, atIndex: 0)
        addChildViewController(menuViewController)
        menuViewController.didMoveToParentViewController(self)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return menuVisible
    }
    
    
    func toggleLeftPanel() {
        animateLeftPanel(shouldExpand: !menuVisible)
    }

    
    func animateLeftPanel(#shouldExpand: Bool) {
        if (shouldExpand) {
            menuVisible = true
            
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(mainViewController.view.frame) - 150)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.menuVisible = false
            }
        }
    }

    func animateCenterPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.mainViewController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func handleTapGesture(sender: UITapGestureRecognizer) {
        if (sender.state == .Ended) {
            animateLeftPanel(shouldExpand: false)
        }
        
    }
    
    func handleEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
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
