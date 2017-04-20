//
//  Tweet.swift
//  TwitterClient
//
//  Created by Bharath D N on 4/11/17.
//  Copyright © 2017 Bharath D N. All rights reserved.
//

import UIKit


class Tweet: NSObject {
  
  var text: String?
  var retweetCount: Int = 0
  var favouritesCount: Int = 0
  var timeStamp: Date?
  var id: String?
  
  var userName: String?
  var userScreenName: String?
  var userImageUrl: URL?
  var didUserRetweet: Bool?
  var didUserFavorite: Bool?
  
  var retweetUserName: String?
  var retweetUserScreenName: String?
  
  private static var _max_id: Int?
  class var MaxId: Int? {
    get{
      return _max_id
    }
    set(id) {
      _max_id = id!
    }
  }
  
  private static var _since_id: Int?
  class var SinceId: Int? {
    get{
      return _since_id
    }
    set(id) {
      _since_id = id!
    }
  }
 

  init(dictionary: NSDictionary) {
    text = dictionary["text"] as? String
    retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
    favouritesCount = (dictionary["favorite_count"] as? Int) ?? 0
    
    let timeStampString = dictionary["created_at"] as? String
    
    if let timeStampString = timeStampString {
      let formatter = DateFormatter()
      formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
      timeStamp = formatter.date(from: timeStampString)
    }
    
    id = dictionary["id_str"] as? String
    
    didUserRetweet = dictionary["retweeted"] as? Bool ?? false
    didUserFavorite = dictionary["favorited"] as? Bool ?? false
    
    let retweetStatus = dictionary["retweeted_status"] as? NSDictionary
    if retweetStatus != nil {
      let user = retweetStatus?["user"] as? NSDictionary
      userName = user?["screen_name"] as? String
      userScreenName = user?["name"] as? String
      //or profile_image_url
      let userImageUrlString = user?["profile_image_url_https"] as? String
      userImageUrl = URL(string: userImageUrlString!)
      
      let retweetUser = dictionary["user"] as? NSDictionary
      retweetUserName = retweetUser?["screen_name"] as? String
      retweetUserScreenName = retweetUser?["name"] as? String
    }
    else {
      let user = dictionary["user"] as? NSDictionary
      if user != nil
      {
        userName = user?["screen_name"] as? String
        userScreenName = user?["name"] as? String
        let userImageUrlString = user?["profile_image_url_https"] as? String
        userImageUrl = URL(string: userImageUrlString!)
      }
      else {
        print("no retweet user present")
      }
    }
  }
  
  class func tweetsWithArray(dictionaryArray: [NSDictionary]) -> [Tweet] {
    var tweets: [Tweet] = []
    
    for dictionary in dictionaryArray {
      let tweet = Tweet(dictionary: dictionary)
      tweets.append(tweet)
      
      // compute max_id (the lowest value of ids) and since_id (greatest value of ids)
      let id = Int(tweet.id!)
      
      if MaxId == nil {
        MaxId = id
      }
      else if id! < MaxId! {
        MaxId = id
      }
      
      if SinceId == nil {
        SinceId = id
      }
      else if id! > SinceId! {
        SinceId = id
      }
    }
    
    return tweets
  }

  class func mentionTweetsWithArray(dictionaryArray: [NSDictionary]) -> [Tweet] {
    var tweets: [Tweet] = []
    
    for dictionary in dictionaryArray {
      let tweet = Tweet(dictionary: dictionary)
      tweets.append(tweet)
      
      // compute max_id (the lowest value of ids) and since_id (greatest value of ids    
    }
    
    return tweets
  }

  
  
  func stringifyTweet() -> String {
    return "tweet with text \" \(text ?? "Text Unavailable!!") \"  posted successfully"
  }
}
