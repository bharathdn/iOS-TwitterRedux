//
//  User.swift
//  TwitterClient
//
//  Created by Bharath D N on 4/11/17.
//  Copyright © 2017 Bharath D N. All rights reserved.
//

import UIKit

class User: NSObject {
  var id: Int?
  var name: String?
  var screenName: String?
  var profileImageUrl: URL?
  var profileBackgroundImageUrl: URL?
  var tagLine: String?
  var dictionary: NSDictionary?
  
  var tweetCount: Int?
  var followerCount: Int?
  var followingCount: Int?
  
  static let currentUserDataKey = "currentUserData"
  static let userDidLogoutNotification = "UserDidLogout"
  
  init(dictionary: NSDictionary) {
    self.dictionary = dictionary
    
    id = dictionary["id"] as? Int
    name = dictionary["screen_name"] as? String
    screenName = dictionary["name"] as? String
    
    let profileUrlString = dictionary["profile_image_url_https"] as? String
    if let profileUrlString = profileUrlString {
      profileImageUrl = NSURL(string: profileUrlString)! as URL
    }
    
    let profileBackgroundImageUrlString =  dictionary["profile_background_image_url_https"] as? String
    if let profileBackgroundImageUrlString = profileBackgroundImageUrlString {
      profileBackgroundImageUrl = NSURL(string: profileBackgroundImageUrlString)! as URL
    }
    
    tagLine = dictionary["description"] as? String
    
    tweetCount = dictionary["statuses_count"] as? Int
    followerCount = dictionary["followers_count"] as? Int
    followingCount = dictionary["friends_count"] as? Int
  }
  
  static var _currentUser: User?
  
  class var currentUser: User? {
    get{
      if _currentUser == nil {
        let defaults = UserDefaults.standard
        let userData = defaults.object(forKey: currentUserDataKey) as? Data
        if let userData = userData {
          let dictionary = try! JSONSerialization.jsonObject(with: userData, options:[]) // as! NSDictionary
          _currentUser = User.init(dictionary: dictionary as! NSDictionary)
        }
      }
      return _currentUser
    }
    set(user){
      _currentUser = user
      
      let defaults = UserDefaults.standard
      if let user = user {
        let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
        defaults.set(data, forKey: currentUserDataKey)
      }
      else {
        defaults.removeObject(forKey: currentUserDataKey)
      }
      
      defaults.synchronize()
    }
  }
  
}
