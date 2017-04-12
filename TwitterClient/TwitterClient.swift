//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Bharath D N on 4/11/17.
//  Copyright © 2017 Bharath D N. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

// APP Keys
let twitterBaseUrl = "https://api.twitter.com"
let twitterConsumerKey = "Bfsp7IKTeuS83c2RCckteVSbE"
let twitterConsumerSecret = "6iMhMnvoyWoWrSHTLiUgA7437WkB3xdmCsTwEAk4JVr1SniNdC"
// Url paths
let twitterRequestTokenPath = "oauth/request_token"
let twitterAuthUrl = "https://api.twitter.com/oauth/authorize"
let twitterAccessTokenPath = "oauth/access_token"
let twitterVerifyCredentialsPath = "1.1/account/verify_credentials.json"
let twitterHomeTimeLinePath = "1.1/statuses/home_timeline.json"

class TwitterClient: BDBOAuth1SessionManager {
  
  static let sharedInstance = TwitterClient(baseURL: NSURL(string: twitterBaseUrl)! as URL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
  
  var loginSuccess: (() -> ())?
  var loginFailure: ((Error) -> ())?
  
  func homeTimeLine(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
    get(twitterHomeTimeLinePath, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      
      let dictionariesArray = response as! [NSDictionary]
      let tweets = Tweet.tweetsWithArray(dictionaryArray: dictionariesArray)
      success(tweets)
    }, failure: { (task: URLSessionDataTask?, error: Error?) in
      failure(error!)
    })
  }
  
  func currentAccount() {
    get(twitterVerifyCredentialsPath, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      
//      let userDictionary = response as! NSDictionary
//      let user = User(dictionary: userDictionary)
      
    }, failure: { (task: URLSessionDataTask?, error: Error?) in
      print("error verifying credentials")
    })
  }
  
  func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
    loginSuccess = success
    loginFailure = failure
    
    TwitterClient.sharedInstance?.fetchRequestToken (withPath: twitterRequestTokenPath, method: "GET", callbackURL: NSURL(string: "twitterClient://oauth")! as URL, scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
      let authUrl = twitterAuthUrl + "?oauth_token=\(requestToken.token!)"
      let url = NSURL(string: authUrl)! as URL
      UIApplication.shared.open(url)
    }, failure: { (error: Error?) in
      print("Error loggin in: \(String(describing: error?.localizedDescription))")
      self.loginFailure?(error!)
    })
  }
  
  func handleOpenUrl(url: URL) {
    let requestToken = BDBOAuth1Credential(queryString: url.query)
    fetchAccessToken(withPath: twitterAccessTokenPath, method: "POST", requestToken: requestToken, success: { (accesToken: BDBOAuth1Credential?) in
      self.loginSuccess?()
    }, failure: { (error: Error?) in
      print("Error fetching Access TOken")
      self.loginFailure?(error!)
    })
  }
  

}
