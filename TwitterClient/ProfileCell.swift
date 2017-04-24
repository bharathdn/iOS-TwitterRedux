//
//  ProfileCell.swift
//  TwitterClient
//
//  Created by Bharath D N on 4/21/17.
//  Copyright © 2017 Bharath D N. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {
  
  @IBOutlet weak var userBackgroundImageView: UIImageView!
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var userScreeNameLabel: UILabel!
  
  @IBOutlet weak var followersCountLabel: UILabel!
  @IBOutlet weak var followingCountLabel: UILabel!
  @IBOutlet weak var tweetCountLabel: UILabel!
  @IBOutlet weak var pageControl: UIPageControl!
  
  var user: User! {
    didSet {
      let backgroundUrl = user.profileBackgroundImageUrl
      if backgroundUrl != nil {
        userBackgroundImageView.setImageWith(user.profileBackgroundImageUrl!)
      } else {
        userBackgroundImageView.image = #imageLiteral(resourceName: "wall")
      }
      userImageView.setImageWith(user.profileImageUrl!)
      userScreeNameLabel.text = user.screenName!
      userNameLabel.text = "@" + user.name!
      followersCountLabel.text = String(user.followerCount!)
      followingCountLabel.text = String(user.followingCount!)
      tweetCountLabel.text = String(user.tweetCount!)
    }
  }
  
  
}
