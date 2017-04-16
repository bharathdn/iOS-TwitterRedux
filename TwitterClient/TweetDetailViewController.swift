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
  @IBOutlet weak var charsRemainingLabel: UILabel!
  
  // Pop over items
  @IBOutlet weak var replyPopoverView: UIView!
  @IBOutlet weak var replyPopoverTextView: UITextView!
  @IBOutlet weak var replyPopoverButton: UIButton!
  @IBOutlet weak var remainingCharLabel: UILabel!
  
  // auto-layout constraints
  @IBOutlet weak var userScreenNameTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var userImageTopConstraint: NSLayoutConstraint!
  
//  let twitterBlueColor = UIColor(displayP3Red: 0, green: 122, blue: 255, alpha: 0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    replyPopoverView.isHidden = true
    replyPopoverTextView.delegate = self
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
  
  @IBAction func onReplyButtton(_ sender: Any) {
    print("Replying to tweet")
    replyPopoverView.isHidden = false
    replyPopoverTextView.becomeFirstResponder()
    replyPopoverButton.isEnabled = false
    replyPopoverButton.setTitleColor(UIColor.gray, for: .normal)
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
  
  @IBAction func onPopoverReplyButton(_ sender: Any) {
    let replyText = replyPopoverTextView.text!
    print("your reply:: \(replyText)")
    let replyMsg = replyPopoverTextView.text!
    TwitterClient.sharedInstance?.replyToTweet(replyMsg: replyMsg, tweet: tweet, success: { (responseTweet: Tweet) in
      print("reply success")
    }, failure: { (error: Error) in
      print("reply fail")
    })
    
    view.endEditing(true)
    replyPopoverView.isHidden = true
    replyPopoverTextView.text = ""
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

extension TweetDetailViewController: UITextViewDelegate {
  
  func textViewDidChange(_ textView: UITextView) {
    if(replyPopoverTextView.text!.characters.count > 0) {
      replyPopoverButton.isEnabled = true
      replyPopoverButton.setTitleColor(UIColor.white, for: .normal)
    }
    else {
      replyPopoverButton.isEnabled = false
      replyPopoverButton.setTitleColor(UIColor.gray, for: .normal)
    }
    
    limitcharacterCount()
  }
  
  func limitcharacterCount() {
    let limit = 140
    let replyText = replyPopoverTextView.text!
    
    let replyTextCharCount = replyText.characters.count
    let remainingCharacters = limit - replyTextCharCount
    
    if remainingCharacters <= 0 {
      remainingCharLabel.textColor = UIColor.red
      remainingCharLabel.text = "0 chars remaining"
      
      let limitedCharactersIndex = replyText.index(replyText.startIndex, offsetBy: limit)
      replyPopoverTextView.text = replyText.substring(to: limitedCharactersIndex)
    }
    else {
      remainingCharLabel.text = String(remainingCharacters) + " chars remaining"
      remainingCharLabel.textColor = UIColor.white
    }
  }
}

