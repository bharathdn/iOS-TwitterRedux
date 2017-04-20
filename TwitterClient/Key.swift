//
//  Key.swift
//  TwitterClient
//
//  Created by Bharath D N on 4/20/17.
//  Copyright © 2017 Bharath D N. All rights reserved.
//

import UIKit

class Key: NSObject {
  static var twitterConsumerKey = "eknzooDnx1eIWTJe5IHT1wHbJ"
  static var twitterConsumerSecret = "xin7opzAhiXppurppoWjYp1hSW5Jw5Rep37yRjOBUKRDLnK4Tx"
  
  class var TwitterConsumerKey: String? {
    get{
      return twitterConsumerKey
    }
  }
  
  class var TwitterConsumerSecret: String? {
    get{
      return twitterConsumerSecret
    }
  }
  
}
