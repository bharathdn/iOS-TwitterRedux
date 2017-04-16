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
    registerForKeyboardNotifications()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    deregisterFromKeyboardNotifications()
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
  
  func registerForKeyboardNotifications()
  {
    //Adding notifies on keyboard appearing
    NotificationCenter.default.addObserver(self, selector: #selector(TweetDetailViewController.keyboardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(TweetDetailViewController.keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  
  func deregisterFromKeyboardNotifications()
  {
    //Removing notifies on keyboard appearing
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  
  func keyboardWasShown(notification:NSNotification) {
    let userInfo:NSDictionary = notification.userInfo! as NSDictionary
    let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
    let keyboardRectangle = keyboardFrame.cgRectValue
    keyBoardHeight = keyboardRectangle.height
    
    replyTextViewTopConstraint.constant -= keyBoardHeight!
  }
  
  
  func keyboardWillBeHidden(notification: NSNotification)
  {
    replyTextViewTopConstraint.constant = 160
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


