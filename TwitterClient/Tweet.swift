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
  var favouritesCount = 0
  var timeStamp: Date?
  
  init(dictionary: NSDictionary) {
    text = dictionary["text"] as? String
    retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
    favouritesCount = (dictionary["favourites_count"] as? Int) ?? 0
    
    let timeStampString = dictionary["created_at"] as? String
    
    if let timeStampString = timeStampString {
      let formatter = DateFormatter()
      formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
      timeStamp = formatter.date(from: timeStampString)
    }
  }
  
  class func tweetsWithArray(dictionaryArray: [NSDictionary]) -> [Tweet] {
    var tweets: [Tweet] = []
    
    for dictionary in dictionaryArray {
      let tweet = Tweet(dictionary: dictionary)
      tweets.append(tweet)
    }
    
    return tweets
  }

}
