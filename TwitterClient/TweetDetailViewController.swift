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
  @IBOutlet weak var retweetButtonImageView: UIButton!
  @IBOutlet weak var favButtonImageView: UIButton!
  
  // auto-layout constraints
  @IBOutlet weak var userScreenNameTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var userImageTopConstraint: NSLayoutConstraint!
  
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
      retweetUserNameLabel.isHidden = true
      userImageTopConstraint.constant = -18
      userScreenNameTopConstraint.constant = -18
    }
    else {
      retweetImageView.isHidden = false
      retweetUserNameLabel.isHidden = false
      userImageTopConstraint.constant = 6
      userScreenNameTopConstraint.constant = 14
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
    
    if tweet.didUserRetweet! {
      retweetButtonImageView.setImage(#imageLiteral(resourceName: "retweetGreen"), for: .normal)
    }
    
    if tweet.didUserFavorite! {
      favButtonImageView.setImage(#imageLiteral(resourceName: "likeActive"), for: .normal)
    }
  }
  
  @IBAction func onCancelButton(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
    
  @IBAction func onRetweetButton(_ sender: Any) {
    print("Retweeting")
    TwitterClient.sharedInstance?.reTweet(tweet: tweet, success: { (responseTweet: Tweet) in
      self.retweetButtonImageView.setImage(#imageLiteral(resourceName: "retweetGreen"), for: .normal)
      self.retweetCountLabel.text = String(responseTweet.retweetCount)
    }, failure: { (error: Error) in
      print("\n\nError retweting:: \(error.localizedDescription)")
    })
  }
  
  @IBAction func onFavButton(_ sender: Any) {
    print("Fav Tweet clicked")
    TwitterClient.sharedInstance?.favoriteTweet(tweet: tweet, success: { (responseTweet: Tweet) in
      self.favButtonImageView.setImage(#imageLiteral(resourceName: "likeActive"), for: .normal)
      self.favCountLabel.text = String(responseTweet.favouritesCount)
    }, failure: { (error: Error) in
      print("\n\nError favoriting:: \(error.localizedDescription)")
    })
  }
  
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    print("segue called")
    if segue.identifier == "replyToTweetSegueFromDetail" {
      print("segue to tweet reply controller")
      let uiNavigationController = segue.destination as! UINavigationController
      let replyViewController = uiNavigationController.topViewController as! TweetReplyViewController
      replyViewController.tweet = tweet
    }
   }
}

extension TweetDetailViewController: TweetReplyViewControllerDelegate {
  
  func tweetReplyViewController(tweetReplyViewController: TweetReplyViewController, didPostReply tweet: Tweet) {
    print("TweetDetailView Controller:  reply to tweet has been posted")
    self.tweet = tweet
    populateDetails()
  }
  
}

