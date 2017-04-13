//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Bharath D N on 4/11/17.
//  Copyright © 2017 Bharath D N. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {
  
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var retweetImageView: UIImageView!
  @IBOutlet weak var retweetUserLabel: UILabel!
  @IBOutlet weak var userScreenNameLabel: UILabel!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var timeStampLabel: UILabel!
  @IBOutlet weak var tweetTextLabel: UILabel!
  
  
  var tweet: Tweet! {
    didSet {
      userImageView.setImageWith(tweet.userImageUrl!)
      if tweet.retweetUserName == nil {
        retweetImageView.isHidden = true
        retweetUserLabel.isHidden = true
        
      } else {
        retweetUserLabel.text = tweet.retweetUserScreenName! + " retweeted"
      }
      
      userScreenNameLabel.text = tweet.userScreenName!
      userNameLabel.text = "@" + tweet.userName!
      timeStampLabel.text = ": 20h" //getTimeStampLabel(timeStamp: tweet.timeStamp!)
      tweetTextLabel.text = tweet.text
    }
  }
  
  private func getTimeStampLabel(timeStamp: Date) -> String {
    return "20h"
  }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
      // Configure the view for the selected state
      tweetTextLabel.preferredMaxLayoutWidth = tweetTextLabel.frame.size.width
    }

}
