//
//  TweetReplyViewController.swift
//  TwitterClient
//
//  Created by Bharath D N on 4/16/17.
//  Copyright © 2017 Bharath D N. All rights reserved.
//

import UIKit

@objc protocol TweetReplyViewControllerDelegate {
  @objc optional func tweetReplyViewController (tweetReplyViewController: TweetReplyViewController, didPostReply tweet: Tweet)
}

class TweetReplyViewController: UIViewController {
  
  var tweet: Tweet! = nil
  weak var delegate: TweetReplyViewControllerDelegate?
  var keyBoardHeight: CGFloat?
  
  @IBOutlet weak var replyButton: UIBarButtonItem!
  @IBOutlet weak var replyTextView: UITextView!
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var userScreenNameLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var charCountBarItem: UIBarButtonItem!
  @IBOutlet weak var replyTextViewTopConstraint: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    replyTextView.delegate = self
    replyTextView.becomeFirstResponder()
    
    userImageView.setImageWith(tweet.userImageUrl!)
    userNameLabel.text = tweet.userName
    userScreenNameLabel.text = tweet.userScreenName
    tweetTextLabel.text = tweet.text
  }
  
  @IBAction func onCancelButton(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func onReplyButton(_ sender: Any) {
    print("\n\nYou replied:: \(replyTextView.text)\n\n")
    
    let replyText = replyTextView.text!
    TwitterClient.sharedInstance?.replyToTweet(replyMsg: replyText, tweet: tweet, success: { (responseTweet: Tweet) in
      print("reply success")
      
      self.delegate?.tweetReplyViewController!(tweetReplyViewController: self, didPostReply: responseTweet)
      self.dismiss(animated: true, completion: nil)
    }, failure: { (error: Error) in
      print("reply failed :(")
    })
    
    view.endEditing(true)
    replyTextView.text = nil
  }
  
  func limitCharacterCount() {
    let limit = 140
    let replyText = replyTextView.text!
    
    let replyTextCharCount = replyText.characters.count
    let remainingCharacters = limit - replyTextCharCount
    
    if remainingCharacters <= 0 {
      charCountBarItem.tintColor = UIColor.red
      charCountBarItem.title = "0"
      
      let limitedCharactersIndex = replyText.index(replyText.startIndex, offsetBy: limit)
      replyTextView.text = replyText.substring(to: limitedCharactersIndex)
    }
    else {
      charCountBarItem.title = String(remainingCharacters)
      charCountBarItem.tintColor = UIColor.white
    }
  }
}

// MARK: - Delegates
extension TweetReplyViewController: UITextViewDelegate {
  
  func textViewDidChange(_ textView: UITextView) {
    if(replyTextView.text!.characters.count > 0) {
      replyButton.isEnabled = true
    }
    else {
      replyButton.isEnabled = false
    }
    
    limitCharacterCount()
  }
}


