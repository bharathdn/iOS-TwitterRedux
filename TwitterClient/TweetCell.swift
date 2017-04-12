//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Bharath D N on 4/11/17.
//  Copyright © 2017 Bharath D N. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
  
  
  @IBOutlet weak var tweetTextLabel: UILabel!
  @IBOutlet weak var retweetCountLabel: UILabel!
  @IBOutlet weak var favCountLabel: UILabel!
  @IBOutlet weak var timeStampLabel: UILabel!
  
  var tweet: Tweet! {
    didSet {
      tweetTextLabel.text = tweet.text
      retweetCountLabel.text = String(tweet.retweetCount)
      favCountLabel.text = String(tweet.favouritesCount)
      timeStampLabel.text = String(describing: tweet.timeStamp)
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
