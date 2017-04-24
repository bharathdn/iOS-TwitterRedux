//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Bharath D N on 4/11/17.
//  Copyright © 2017 Bharath D N. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController {
  
  var tweets: [Tweet] = []
  var replyIndex: Int?
  var detailsViewIndex: Int?
  
  @IBOutlet weak var tableView: UITableView!
  let refreshControl = UIRefreshControl()
  
  var isMoreDataLoading = false
  var isFirstRequestLoaded = false
  var loadingMoreView:InfiniteScrollActivityView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 200
    
    loadTweets()
    isFirstRequestLoaded = true
    
    // Refresh Control
    refreshControl.addTarget(self, action: #selector(TweetsViewController.loadTweets), for: .valueChanged)
    tableView.insertSubview(refreshControl, at: 0)
    
    // Infinite Scroll Control
    let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
    loadingMoreView = InfiniteScrollActivityView(frame: frame)
    loadingMoreView!.isHidden = true
    tableView.addSubview(loadingMoreView!)
    
    var insets = tableView.contentInset
    insets.bottom += InfiniteScrollActivityView.defaultHeight
    tableView.contentInset = insets
    
    NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: User.userDidPostTweet), object: nil, queue: OperationQueue.main) { (notification) in
      self.tweets.insert(notification.userInfo?["tweet"] as! Tweet, at: 0)
      self.tableView.reloadData()
    }
  }
  
  @IBAction func onLogoutButton(_ sender: Any) {
    print("Logging out user")
    User.currentUser = nil
    TwitterClient.sharedInstance?.logout()
    
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
  }
  
  func loadTweets() {
    var parameters = [String: AnyObject]()
    parameters["count"] = 20 as AnyObject
    
    if isFirstRequestLoaded && Tweet.MaxId != nil {
      
      print("\n\n\n \(Tweet.MaxId!) \n\n\n")
      parameters["max_id"] = Tweet.MaxId as AnyObject
    }
    
    TwitterClient.sharedInstance?.homeTimeLine(parameters: parameters ,success: { (tweets: [Tweet]?) in
      print("*** \(tweets?.count ?? 0) Number of tweets retrieved for user")
      
      self.tweets += tweets!
      self.tableView.reloadData()
      self.refreshControl.endRefreshing()
      self.loadingMoreView!.stopAnimating()
      self.isMoreDataLoading = false
      
    }, failure: { (error: Error) in
      print(error.localizedDescription)
    })
  }
  
  
  fileprivate func HandleRetweetAction(index: Int) {
    print("\nRetweeting from home Timeline")
    let tweet = tweets[index]
    
    if !(tweet.didUserRetweet!) {
      
      let indexPath = IndexPath(item: index, section: 0)
      
      TwitterClient.sharedInstance?.reTweet(tweet: tweet, success: { (responseTweet: Tweet) in
        tweet.didUserRetweet = true
        tweet.retweetCount += 1
        self.tweets[index] = tweet
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
      }, failure: { (error: Error) in
        print("\n\nError retweting from Home TimeLine:: \(error.localizedDescription)")
      })
    }
  }
  
  fileprivate func HandleFavAction(index: Int) {
    print("\n Fav Tweet from Home timeline")
    let tweet = tweets[index]
    
    if !(tweet.didUserFavorite!) {
      let indexPath = IndexPath(item: index, section: 0)
      
      TwitterClient.sharedInstance?.favoriteTweet(tweet: tweet, success: { (tweet: Tweet) in
        tweet.didUserFavorite = true
        tweet.favouritesCount += 1
        self.tweets[index] = tweet
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
      }, failure: { (error: Error) in
        print("\n\nError favoriting tweet on home Timeline:: \(error.localizedDescription)")
      })
    }
  }
  
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "HomeDetailSegue" {
      let tweet = tweets[detailsViewIndex!]
      let uiNavigationController = segue.destination as! UINavigationController
      let detailViewController = uiNavigationController.topViewController as! TweetDetailViewController
      detailViewController.tweet = tweet
    }
//    else if segue.identifier == "HomeNewTweetSegue" {
//      let uiNavigationController = segue.destination as! UINavigationController
//      let composeTweetController = uiNavigationController.topViewController as!ComposeTweetController
//      composeTweetController.delegate = self
//    }
    else if segue.identifier == "HomeReplySegue" {
      let tweet = tweets[replyIndex!]
      let uiNavigationController = segue.destination as! UINavigationController
      let replyViewController = uiNavigationController.topViewController as! TweetReplyViewController
      replyViewController.tweet = tweet
    }
  }
  
}

// MARK: - ComposeTweetControllerDelegate, TweetReplyViewControllerDelegate
extension TweetsViewController: TweetReplyViewControllerDelegate,
TweetDetailViewControllerDelegate {
  
//  func composeTweetController(composeTweetController: ComposeTweetController, didPostTweet tweet: Tweet) {
//    print("new tweet posted delegate called on TweetViewController")
//    tweets.insert(tweet, at: 0)
//    tableView.reloadData()
//  }

  
  
  func tweetReplyViewController(tweetReplyViewController: TweetReplyViewController, didPostReply tweet: Tweet) {
    print("reply to tweet has been posted")
    tweets[replyIndex!] = tweet
    let indexPath = IndexPath(item: replyIndex!, section: 0)
    self.tableView.reloadRows(at: [indexPath], with: .automatic)
  }
  
  func tweetDetailViewController(tweetDetailViewController: TweetDetailViewController, tweetUpadted tweet: Tweet) {
    print("fav/retweeted in detail view ctlr. Delegate received")
    tweets[detailsViewIndex!] = tweet
    let indexPath = IndexPath(item: detailsViewIndex!, section: 0)
    self.tableView.reloadRows(at: [indexPath], with: .automatic)
  }
}


// MARK: - Table and Scroll View
extension TweetsViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = Bundle.main.loadNibNamed("TweetPrototypeCell", owner: self, options: nil)?.first as! TweetPrototypeCell
    cell.tweet = tweets[indexPath.row]
    cell.delegate = self
    cell.index = indexPath.row
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    detailsViewIndex = indexPath.row
    performSegue(withIdentifier: "HomeDetailSegue", sender: nil)
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // Calculate the position of one screen length before the bottom of the results
    let scrollViewContentHeight = tableView.contentSize.height
    let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
    
    if (!isMoreDataLoading) {
      // When the user has scrolled past the threshold, start requesting
      if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
        print("UI Scrolled for more data")
        isMoreDataLoading = true
        // Update position of loadingMoreView, and start loading indicator
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView?.frame = frame
        loadingMoreView!.startAnimating()
        
        loadTweets()
      }
    }
  }
}

// MARK: - retweet, reply and fav delegates
extension TweetsViewController: TweetPrototypeCellDelegate {
  func tweetPrototypeCell (tweetPrototypeCell: TweetPrototypeCell, didClickReply tweet: Tweet) {
    print("reply button clicked on \(tweetPrototypeCell.index ?? -1)")
    replyIndex = tweetPrototypeCell.index!
    performSegue(withIdentifier: "HomeReplySegue", sender: nil)
  }
  
  func tweetPrototypeCell (tweetPrototypeCell: TweetPrototypeCell, didClickRetweet tweet: Tweet) {
    print("ReTWEET button clicked on \(tweetPrototypeCell.index ?? -1)")
    HandleRetweetAction(index: tweetPrototypeCell.index!)
  }
  
  func tweetPrototypeCell (tweetPrototypeCell: TweetPrototypeCell, didClickFav tweet: Tweet) {
    print("FAv button clicked on \(tweetPrototypeCell.index ?? -1)")
    HandleFavAction(index: tweetPrototypeCell.index!)
  }
}
