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
  
  @IBOutlet weak var tableView: UITableView!
  
  let refreshControl = UIRefreshControl()
  
  var isMoreDataLoading = false
  var currentOffset = 0
  var loadingMoreView:InfiniteScrollActivityView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 200
    
    currentOffset = 0
    loadTweets()
    
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
    parameters["offset"] = currentOffset as AnyObject
    
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
  
  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "tweetDetailSegue" {
      let cell = sender as! TweetCell
      let indexPath = tableView.indexPath(for: cell)
      let tweet = tweets[indexPath!.row]
      
      let uiNavigationController = segue.destination as! UINavigationController
      let detailViewController = uiNavigationController.topViewController as! TweetDetailViewController
      detailViewController.tweet = tweet
    }
    
  }
  
}

// MARK: - ComposeTweetControllerDelegate
extension TweetsViewController: ComposeTweetControllerDelegate {
  
}


// MARK: - Table and Scroll View
extension TweetsViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return tweets.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
    cell.tweet = tweets[indexPath.row]
    //    print(tweets[indexPath.row])
    return cell
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
        currentOffset += 20
        loadTweets()
      }
    }
  }
}
