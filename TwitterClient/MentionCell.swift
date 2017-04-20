//
//  MentionCell.swift
//  TwitterClient
//
//  Created by Bharath D N on 4/20/17.
//  Copyright © 2017 Bharath D N. All rights reserved.
//

import UIKit

class MentionCell: UITableViewCell {
  
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
  
  @IBOutlet weak var replyButtonImageView: UIButton!
  @IBOutlet weak var retweetButtonImageView: UIButton!
  @IBOutlet weak var favButtonImageView: UIButton!
  
  @IBOutlet weak var userImageTopViewContraint: NSLayoutConstraint!
  @IBOutlet weak var userScreeNameTopViewConstraint: NSLayoutConstraint!
  
  var tweet: Tweet! {
    didSet {
      userImageView.setImageWith(tweet.userImageUrl!)
      
      if tweet.retweetUserName == nil {
        retweetImageView.isHidden = true
        retweetUserLabel.isHidden = true
        userImageTopViewContraint.constant = -12
        userScreeNameTopViewConstraint.constant = -12
      } else {
        retweetImageView.isHidden = false
        retweetUserLabel.isHidden = false
        retweetUserLabel.text = tweet.retweetUserScreenName! + " Retweeted"
        userImageTopViewContraint.constant = 6
        userScreeNameTopViewConstraint.constant = 4
      }
      
      userScreenNameLabel.text = tweet.userScreenName!
      userNameLabel.text = "@" + tweet.userName!
      timeStampLabel.text = getTimeStampLabel(timeStamp: tweet.timeStamp!)
      tweetTextLabel.text = tweet.text
      repliesCountLabel.text = ""
      retweetCountLabel.text = String(tweet.retweetCount)
      favCountLabel.text = String(tweet.favouritesCount)
      
      if tweet.didUserRetweet! {
        retweetButtonImageView.setImage(#imageLiteral(resourceName: "retweetGreen"), for: .normal)
      }
      else {
        retweetButtonImageView.setImage(#imageLiteral(resourceName: "retweet-1"), for: .normal)
      }
      
      if tweet.didUserFavorite! {
        favButtonImageView.setImage(#imageLiteral(resourceName: "likeActive"), for: .normal)
      } else {
        favButtonImageView.setImage(#imageLiteral(resourceName: "likeInactive"), for: .normal)
      }
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
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
