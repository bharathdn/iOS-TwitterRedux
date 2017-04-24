//
//  User.swift
//  TwitterClient
//
//  Created by Bharath D N on 4/11/17.
//  Copyright © 2017 Bharath D N. All rights reserved.
//

import UIKit
import KeychainAccess
import BDBOAuth1Manager

class User: NSObject {
  public private(set) var uuid: String?
  
  var id: Int?
  var name: String?
  var screenName: String?
  var profileImageUrl: URL?
  var profileBackgroundImageUrl: URL?
  var tagLine: String?
  
  var tweetCount: Int?
  var followerCount: Int?
  var followingCount: Int?
  
  var dictionary: [String: AnyObject]?
  
  static let currentUserDataKey = "currentUserData"
  static let userDataKey = "userDataKey"
  static let userDidLogoutNotification = "UserDidLogout"
  static let userDidPostTweet = "UserDidPostTweet"
  static let bundleIdenfitier = "com.bharath.DNRTwitterClient"
  
  init(dictionary: [String: AnyObject]) {
    self.dictionary = dictionary
    
    uuid = dictionary["uuid"] as? String
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
  
  private static var _currentUser: User?
  
  class var currentUser: User? {
    get{
      if _currentUser == nil {
        let defaults = UserDefaults.standard
        let userData = defaults.object(forKey: currentUserDataKey) as? Data
        if let userData = userData {
          let dictionary = try! JSONSerialization.jsonObject(with: userData, options:[]) // as! NSDictionary
          _currentUser = User.init(dictionary: dictionary as! [String: AnyObject])
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
  
  private static var _users: [User]?
  class var users: [User]? {
    get {
      if let _users = _users {
        return _users
      } else {
        let defaults = UserDefaults.standard
        
        if let usersData = defaults.object(forKey: userDataKey) as? Data,
          let usersJson = try? JSONSerialization.jsonObject(with: usersData, options:[]),
          let userDictionaries = usersJson as? [[String: AnyObject]] {
          _users = userDictionaries.map { userDictionary in
            let user = User(dictionary: userDictionary)
            let uuid = userDictionary["uuid"]
            if let uuid = uuid {
              user.uuid = uuid as? String
            }
            return user
          }
          return _users
        }
        return nil
      }
    }
    set(users) {
      _users = users
      
      let defaults = UserDefaults.standard
      if let users = users {
        let userDictionaries: [[String: AnyObject]] = users.map { user in
          return user.dictionary!
        }
        
        if let usersData = try? JSONSerialization.data(withJSONObject: userDictionaries, options: []) {
          defaults.set(usersData, forKey: userDataKey)
        } else {
          defaults.removeObject(forKey: userDataKey)
        }
      }
      else {
        defaults.removeObject(forKey: userDataKey)
      }
      defaults.synchronize()
    }
  }
  
  class func saveCurrentUser(user: User, accessToken: BDBOAuth1Credential) {
    let uuid = UUID().uuidString
    user.uuid = uuid
    user.dictionary!["uuid"] = uuid as AnyObject?
    
    let keychain = Keychain(service: bundleIdenfitier)
    if let token = accessToken.token,
      let secret = accessToken.secret {
      keychain["\(uuid)_access_token"] = token
      keychain["\(uuid)_access_token_secret"] = secret
    }
    
    currentUser = user
    if users != nil {
      self.users! += [user]
    } else {
      self.users = [user]
    }
  }
  
  class func loadAccessToken() -> Bool {
    print("loading access token")
    if let client = TwitterClient.sharedInstance {
      client.requestSerializer.removeAccessToken()
      
      if let currentUser = User.currentUser,
        let uuid = currentUser.uuid {
        let keychain = Keychain(service: bundleIdenfitier)
        if let accessToken = keychain["\(uuid)_access_token"],
          let accessTokenSecret = keychain["\(uuid)_access_token_secret"] {
          
          let generatedToken = BDBOAuth1Credential(token: accessToken, secret: accessTokenSecret, expiration: nil)
          client.requestSerializer.saveAccessToken(generatedToken)
          
          return true
        }
      }
    }
    return false
  }
  
}
