//
//  TweetDetailViewController.swift
//  TwitterClient
//
//  Created by Bharath D N on 4/13/17.
//  Copyright © 2017 Bharath D N. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
  
  var tweet: Tweet?
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var retweetImageView: UIImageView!
  @IBOutlet weak var retweetUserNameLabel: UILabel!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var userScreenNameLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var tweetTimeStampLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    populateDetails()
  }
  
  func populateDetails() {
    userImageView.setImageWith((tweet?.userImageUrl)!)
    
    if tweet?.retweetUserName == nil {
      retweetImageView.isHidden = true
      retweetImageView.bounds.size.height = 0
      retweetUserNameLabel.isHidden = true
      retweetUserNameLabel.bounds.size.height = 0
    }
    else {
      retweetUserNameLabel.text = tweet?.retweetUserName
    }
    
    userNameLabel.text = tweet?.userName
    userScreenNameLabel.text = tweet?.userScreenName
    tweetTextLabel.text = tweet?.text
    
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, h:mm a"
    formatter.amSymbol = "AM"
    tweetTimeStampLabel.text = formatter.string(from: (tweet?.timeStamp)!)
  }
  
  @IBAction func onCancelButton(_ sender: Any) {
    dismiss(animated: true, completion: nil)
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
