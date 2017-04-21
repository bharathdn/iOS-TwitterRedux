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
let twitterConsumerKey = Key.TwitterConsumerKey //"Bfsp7IKTeuS83c2RCckteVSbE"
let twitterConsumerSecret = Key.TwitterConsumerSecret //"6iMhMnvoyWoWrSHTLiUgA7437WkB3xdmCsTwEAk4JVr1SniNdC"
// Url paths
let twitterRequestTokenPath = "oauth/request_token"
let twitterClientOAuthUrl = "twitterClient://oauth"
let twitterAuthUrl = "https://api.twitter.com/oauth/authorize"
let twitterAccessTokenPath = "oauth/access_token"
let twitterVerifyCredentialsPath = "1.1/account/verify_credentials.json"

// home timeline
let twitterHomeTimeLinePath = "1.1/statuses/home_timeline.json"
// mentions
let twitterMentionsPath = "1.1/statuses/mentions_timeline.json"
// user timeline
let twitterUserTimeLinePath = "1.1/statuses/user_timeline.json"
// Post tweet
let twitterPostTweetUrl = "1.1/statuses/update.json"
// Retweet
let twitterRetweetUrl = "1.1/statuses/retweet/" // + ":id.json"
// Favorite
let twitterFavUrl = "1.1/favorites/create.json"
// reply
let twitterReplyStatusId = "in_reply_to_status_id"

class TwitterClient: BDBOAuth1SessionManager {
  
  static let sharedInstance = TwitterClient(baseURL: NSURL(string: twitterBaseUrl)! as URL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
  
  var loginSuccess: (() -> ())?
  var loginFailure: ((Error) -> ())?
  
  func homeTimeLine(parameters: [String: AnyObject]? ,success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
    
    get(twitterHomeTimeLinePath, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      
      let dictionariesArray = response as! [NSDictionary]
      let tweets = Tweet.tweetsWithArray(dictionaryArray: dictionariesArray)
      success(tweets)
      
    }, failure: { (task: URLSessionDataTask?, error: Error?) in
      
      failure(error!)
      
    })
  }
  
  
  func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
    get(twitterVerifyCredentialsPath, parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      
      let userDictionary = response as! NSDictionary
      let user = User(dictionary: userDictionary)
      success(user)
      
    }, failure: { (task: URLSessionDataTask?, error: Error?) in
      
      print("error verifying credentials")
      failure(error!)
      
    })
  }
  
  
  func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
    loginSuccess = success
    loginFailure = failure
    
    TwitterClient.sharedInstance?.fetchRequestToken (withPath: twitterRequestTokenPath, method: "GET", callbackURL: NSURL(string: twitterClientOAuthUrl)! as URL, scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
      
      let authUrl = twitterAuthUrl + "?oauth_token=\(requestToken.token!)"
      let url = NSURL(string: authUrl)! as URL
      print("Auth token fetched, opening URL")
      UIApplication.shared.open(url)
      
    }, failure: { (error: Error?) in
      print("Error loggin in: \(String(describing: error?.localizedDescription))")
      self.loginFailure?(error!)
    })
  }
  
  func logout() {
    deauthorize()
  }
  
  
  func handleOpenUrl(url: URL) {
    let requestToken = BDBOAuth1Credential(queryString: url.query)
    
    fetchAccessToken(withPath: twitterAccessTokenPath, method: "POST", requestToken: requestToken, success: { (accesToken: BDBOAuth1Credential?) in
      
      self.currentAccount(success: { (user: User) in
        User.currentUser = user
        self.loginSuccess?()
      }, failure: { (error: Error) in
        self.loginFailure?(error)
      })
      
      
    }, failure: { (error: Error?) in
      
      print("Error fetching Access Token")
      self.loginFailure?(error!)
      
    })
  }
  
  func postTweet(tweetMsg: String, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
    let parameters = ["status": tweetMsg]
    
    post(twitterPostTweetUrl, parameters: parameters, progress: nil, success: { (task:  URLSessionDataTask, response: Any?) in
      print("tweet sent successfully")
      success(Tweet.init(dictionary: response as! NSDictionary))
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      print("\nError posting tweet1:: \(error) \n\n")
      failure(error)
    })
  }
  
  
  func reTweet(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
    let retweetUrlWithId = twitterRetweetUrl + tweet.id! + ".json"
    post(retweetUrlWithId, parameters: nil, progress: nil, success: { (task:  URLSessionDataTask, response: Any?) in
      print("retweeted successfully\n")
      print("\n\n")
      success(Tweet.init(dictionary: response as! NSDictionary))
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      print("\nError posting tweet1:: \(error) \n\n")
      failure(error)
    })
  }
  
  
  func favoriteTweet(tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
    let parameters = ["id": tweet.id]
    post(twitterFavUrl, parameters: parameters, progress: nil, success: { (task:  URLSessionDataTask, response: Any?) in
      print("tweet favorited successfully")
      success(Tweet.init(dictionary: response as! NSDictionary))
    }, failure: { (task: URLSessionDataTask?, error: Error) in
      print("\nError favoriting tweet:: \(error) \n\n")
      failure(error)
    })
  }
  
  func replyToTweet(replyMsg: String, tweet: Tweet, success: @escaping (Tweet) -> (), failure: @escaping (Error) -> ()) {
    let replyMsg = "@" + tweet.userName! + " " + replyMsg
    let parsedMsg = replyMsg.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    let url = "1.1/statuses/update.json?status=\(parsedMsg!)&" + twitterReplyStatusId + "=" + tweet.id!
    print(url)
    post(url, parameters: nil, progress: nil, success: { (task:  URLSessionDataTask, response: Any?) in
    print("reply posted successfully")
    success(Tweet.init(dictionary: response as! NSDictionary))
    }, failure: { (task: URLSessionDataTask?, error: Error) in
    print("\nError replying to tweet:: \(error) \n\n")
    failure(error)
    })
  }
  
  func mentions(parameters: [String: AnyObject]? ,success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
    
    get(twitterMentionsPath, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      
      let dictionariesArray = response as! [NSDictionary]
      let tweets = Tweet.mentionTweetsWithArray(dictionaryArray: dictionariesArray)
      success(tweets)
      
    }, failure: { (task: URLSessionDataTask?, error: Error?) in
      
      failure(error!)
      
    })
  }
  
  func userTimeline(parameters: [String: AnyObject]? ,success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
    
    get(twitterUserTimeLinePath, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
      
      let dictionariesArray = response as! [NSDictionary]
      let tweets = Tweet.mentionTweetsWithArray(dictionaryArray: dictionariesArray)
      success(tweets)
      
    }, failure: { (task: URLSessionDataTask?, error: Error?) in
      
      failure(error!)
      
    })
  }
  
}
