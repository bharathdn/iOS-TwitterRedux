//
//  HamburgerNavController.swift
//  TwitterClient
//
//  Created by Bharath D N on 4/23/17.
//  Copyright © 2017 Bharath D N. All rights reserved.
//

import UIKit

class HamburgerNavController: UINavigationController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.showUserAccountView(sender:)))
    
    longPressGestureRecognizer.delegate = self as? UIGestureRecognizerDelegate
    navigationBar.addGestureRecognizer(longPressGestureRecognizer)
    navigationBar.isUserInteractionEnabled = true
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func showUserAccountView(sender: UILongPressGestureRecognizer) {
    print("user long pressed")
    if sender.state == .began {
        performSegue(withIdentifier: "HamburgerAccountSegue", sender: nil)
    }
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
