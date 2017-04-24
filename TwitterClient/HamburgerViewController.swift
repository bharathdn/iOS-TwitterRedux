//
//  HamburgerViewController.swift
//  TwitterClient
//
//  Created by Bharath D N on 4/20/17.
//  Copyright © 2017 Bharath D N. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {
  
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var menuView: UIView!
  @IBOutlet weak var contentViewLeftMarginConstraint: NSLayoutConstraint!
  
  var contentViewOriginalLeftMargin: CGFloat!
  
  var menuViewController: UIViewController! {
    didSet {
      view.layoutIfNeeded()
      menuView.addSubview(menuViewController.view)
    }
  }
  
  var contentViewController: UIViewController! {
    didSet(oldContentViewController) {
      view.layoutIfNeeded()
      
      if oldContentViewController != nil {
        oldContentViewController.willMove(toParentViewController: nil)
        oldContentViewController.view.removeFromSuperview()
        oldContentViewController.didMove(toParentViewController: nil)
      }
      
      // the following statement will call ViewWillAppear
      contentViewController.willMove(toParentViewController: self)
      contentView.addSubview(contentViewController.view)
      contentViewController.didMove(toParentViewController: self)
      
      UIView.animate(withDuration: 0.3) {
        self.contentViewLeftMarginConstraint.constant = 0
        self.view.layoutIfNeeded()
      }
    }
  }
  
  override func viewDidLoad() {
    print("Hello from Hamburger view c")
    super.viewDidLoad()
    
    self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
    //    self.automaticallyAdjustsScrollViewInsets = true
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func onPanGesture(_ sender: UIPanGestureRecognizer) {
    let velocity = sender.velocity(in: view)
    let translation = sender.translation(in: view)
    
    if sender.state == .began {
      contentViewOriginalLeftMargin = contentViewLeftMarginConstraint.constant
    } else if sender.state == .changed {
      contentViewLeftMarginConstraint.constant = contentViewOriginalLeftMargin + translation.x
    } else if sender.state == .ended {
      UIView.animate(withDuration: 0.25, animations: {
        if velocity.x > 0 {
          self.contentViewLeftMarginConstraint.constant = self.view.frame .width - 100
        } else {
          self.contentViewLeftMarginConstraint.constant = 0
        }
        self.view.layoutIfNeeded()
      })
    }
  }
  
  @IBAction func onSignOut(_ sender: Any) {
    TwitterClient.sharedInstance?.deauthorize()
    User.currentUser = nil
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
  }
  
}
