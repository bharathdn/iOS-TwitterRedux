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
  @IBOutlet weak var repliesCountLabel: UILabel!
  @IBOutlet weak var retweetCountLabel: UILabel!
  @IBOutlet weak var favCountLabel: UILabel!
  
  
  var tweet: Tweet! {
    didSet {
      userImageView.setImageWith(tweet.userImageUrl!)
      if tweet.retweetUserName == nil {
        retweetImageView.isHidden = true
        retweetImageView.bounds.size.height = 0
        retweetUserLabel.isHidden = true
        retweetUserLabel.bounds.size.height = 0
      } else {
        retweetUserLabel.text = tweet.retweetUserScreenName! + " Retweeted"
      }
      
      userScreenNameLabel.text = tweet.userScreenName!
      userNameLabel.text = "@" + tweet.userName!
      timeStampLabel.text = getTimeStampLabel(timeStamp: tweet.timeStamp!)
      tweetTextLabel.text = tweet.text
      repliesCountLabel.text = ""
      retweetCountLabel.text = String(tweet.retweetCount)
      favCountLabel.text = String(tweet.favouritesCount)
    }
  }
  
  private func getTimeStampLabel(timeStamp: Date) -> String {
    let timeElaspsedInSeconds = Int(fabs((tweet.timeStamp?.timeIntervalSinceNow)!))
    let secondsIn23Hours = 23 * 60 * 60
    
    if timeElaspsedInSeconds < 3600 {
      let minutes = Int(timeElaspsedInSeconds/60)
      return "• \(minutes)m"
    }
    else if timeElaspsedInSeconds < secondsIn23Hours {
      let hours = Int(timeElaspsedInSeconds/60/60)
      return "• \(hours)h"
    }
    else {
      let formatter = DateFormatter()
      formatter.dateFormat = "MM/dd/yy"
      let dateString = formatter.string(from: (tweet?.timeStamp)!)
      return "• \(dateString)h"
    }
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
