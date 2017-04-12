//
//  User.swift
//  TwitterClient
//
//  Created by Bharath D N on 4/11/17.
//  Copyright © 2017 Bharath D N. All rights reserved.
//

import UIKit

class User: NSObject {
  var name: String?
  var screenName: String?
  var profileUrl: URL?
  var tagLine: String?
  
  init(dictionary: NSDictionary) {
    name = dictionary["name"] as? String
    screenName = dictionary["screen_name"] as? String
    
    let profileUrlString = dictionary["profile_image_url_https"] as? String
    if let profileUrlString = profileUrlString {
      profileUrl = NSURL(string: profileUrlString)! as URL
    }
    
    tagLine = dictionary["description"] as? String
  }
  
  
  
}
