//
//  ComposeTweetController.swift
//  TwitterClient
//
//  Created by Bharath D N on 4/13/17.
//  Copyright © 2017 Bharath D N. All rights reserved.
//

import UIKit
import AFNetworking

@objc protocol ComposeTweetControllerDelegate {
  @objc optional func composeTweetController (composeTweetController: ComposeTweetController, didPostTweet tweet: Tweet)
}

class ComposeTweetController: UIViewController {
  
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var userScreenNameLabel: UILabel!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var charCountBarItem: UIBarButtonItem!
  @IBOutlet weak var tweetTextView: UITextView!
  @IBOutlet weak var tweetButton: UIBarButtonItem!
  
  weak var delegate: ComposeTweetControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tweetTextView.delegate = self
    
    // Do any additional setup after loading the view.
    let user = User.currentUser
    userImageView.setImageWith((user?.profileImageUrl)!)
    userScreenNameLabel.text = user?.screenName!
    userNameLabel.text = user?.name!
    
    tweetButton.isEnabled = false
  }
  
  @IBAction func onTweetButton(_ sender: Any) {
    print("\n\n \(tweetTextView.text!.characters.count) \n\n")
    print(tweetTextView.text!)
    if tweetTextView.text!.characters.count > 0 {
      TwitterClient.sharedInstance?.postTweet(tweetMsg: tweetTextView.text!, success: { (response: Tweet) in
        print("tweeting success")
        print(response.stringifyTweet())
        self.delegate?.composeTweetController!(composeTweetController: self, didPostTweet: response)
        self.tweetTextView.text = nil
        self.dismiss(animated: true, completion: nil)
      }, failure: { (error: Error) in
        print("\nError posting tweet2:: \(error) \n\n")
      })
    }
  }
  
  @IBAction func onCancelButton(_ sender: Any) {
    dismiss(animated: true, completion: nil)
  }
  
  func limitcharacterCount() {
    let limit = 140
    let tweetText = tweetTextView.text!
    
    let tweetTextCharCount = tweetText.characters.count
    let remainingCharacters = limit - tweetTextCharCount
    
    if remainingCharacters <= 0 {
      charCountBarItem.tintColor = UIColor.red
      charCountBarItem.title = "0"
      
      let limitedCharactersIndex = tweetText.index(tweetText.startIndex, offsetBy: limit)
      tweetTextView.text = tweetText.substring(to: limitedCharactersIndex)
    }
    else {
      charCountBarItem.title = String(remainingCharacters)
      charCountBarItem.tintColor = UIColor.gray
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

extension ComposeTweetController: UITextViewDelegate {
  
  func textViewDidChange(_ textView: UITextView) {
    if(tweetTextView.text!.characters.count > 0) {
      tweetButton.isEnabled = true
    }
    else {
      tweetButton.isEnabled = false
    }
    
    limitcharacterCount()
  }
}
