//
//  TweetDetailViewController.swift
//  TwitterClient
//
//  Created by Bharath D N on 4/13/17.
//  Copyright © 2017 Bharath D N. All rights reserved.
//

import UIKit

@objc protocol TweetDetailViewControllerDelegate {
  @objc optional func tweetDetailViewController(tweetDetailViewController: TweetDetailViewController, tweetUpadted tweet: Tweet)
}

class TweetDetailViewController: UIViewController {
  
  var tweet: Tweet! = nil
  weak var delegate: TweetDetailViewControllerDelegate?
  
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
    else {
      retweetButtonImageView.setImage(#imageLiteral(resourceName: "retweet-1"), for: .normal)
    }
    
    if tweet.didUserFavorite! {
      favButtonImageView.setImage(#imageLiteral(resourceName: "likeActive"), for: .normal)
    }
    else {
      favButtonImageView.setImage(#imageLiteral(resourceName: "likeInactive"), for: .normal)
    }
  }
  
  @IBAction func onCancelButton(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func onRetweetButton(_ sender: Any) {
    print("Retweeting")
    if !(tweet.didUserRetweet!) {
      TwitterClient.sharedInstance?.reTweet(tweet: tweet, success: { (responseTweet: Tweet) in
        responseTweet.didUserRetweet = true
        responseTweet.retweetCount += 1
        self.tweet = responseTweet
        self.populateDetails()
        self.delegate?.tweetDetailViewController!(tweetDetailViewController: self, tweetUpadted: self.tweet)
      }, failure: { (error: Error) in
        print("\n\nError retweting:: \(error.localizedDescription)")
      })
    }
  }
  
  @IBAction func onFavButton(_ sender: Any) {
    print("Fav Tweet clicked")
    if !(tweet.didUserFavorite!) {
      TwitterClient.sharedInstance?.favoriteTweet(tweet: tweet, success: { (responseTweet: Tweet) in
        responseTweet.didUserFavorite = true;
        responseTweet.favouritesCount += 1
        self.tweet = responseTweet
        self.populateDetails()
        self.delegate?.tweetDetailViewController!(tweetDetailViewController: self, tweetUpadted: self.tweet)
      }, failure: { (error: Error) in
        print("\n\nError favoriting:: \(error.localizedDescription)")
      })
    }
  }
  
  @IBAction func onUserImageTapGesture(_ sender: UITapGestureRecognizer) {
    performSegue(withIdentifier: "TweetDetailProfileSegue", sender: nil)
    
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
    else if segue.identifier == "TweetDetailProfileSegue" {
      let tweetDictionary = tweet.tweetDictionary
      let userDictionary = tweetDictionary?["user"] as! [String: AnyObject]
      let user = User(dictionary: userDictionary)
      
      let uiNavigationController = segue.destination as! UINavigationController
      let profileViewController = uiNavigationController.topViewController as! ProfileViewController
      profileViewController.user = user
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
