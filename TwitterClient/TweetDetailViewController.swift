//
//  TweetDetailViewController.swift
//  TwitterClient
//
//  Created by Bharath D N on 4/13/17.
//  Copyright © 2017 Bharath D N. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
  
  var tweet: Tweet! = nil
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var retweetImageView: UIImageView!
  @IBOutlet weak var retweetUserNameLabel: UILabel!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var userScreenNameLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var tweetTimeStampLabel: UILabel!
  @IBOutlet weak var retweetCountLabel: UILabel!
  @IBOutlet weak var favCountLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
    if tweet != nil {
      populateDetails()
    }
  }
  
  func populateDetails() {
    userImageView.setImageWith(tweet.userImageUrl!)
    
    if tweet?.retweetUserName == nil {
      retweetImageView.isHidden = true
      retweetImageView.bounds.size.height = 0
      retweetUserNameLabel.isHidden = true
      retweetUserNameLabel.bounds.size.height = 0
    }
    else {
      retweetUserNameLabel.text = (tweet?.retweetUserName)! + " Retweeted"
    }
    
    userNameLabel.text = tweet.userName
    userScreenNameLabel.text = tweet.userScreenName
    
    tweetTextLabel.text = tweet.text
    
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, h:mm a"
    formatter.amSymbol = "AM"
    formatter.pmSymbol = "PM"
    tweetTimeStampLabel.text = formatter.string(from: (tweet?.timeStamp)!)
    
    retweetCountLabel.text = String(describing: tweet.retweetCount)
    favCountLabel.text = String(describing: tweet.favouritesCount)
  }
  
  @IBAction func onCancelButton(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func onReplyButtton(_ sender: Any) {
    print("Replying to tweet")
  }
  
  @IBAction func onRetweetButton(_ sender: Any) {
    print("Retweeting")
    
  }
  
  @IBAction func onFavButton(_ sender: Any) {
    print("Fav")
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
