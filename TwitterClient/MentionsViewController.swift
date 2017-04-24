//
//  MentionsViewController.swift
//  TwitterClient
//
//  Created by Bharath D N on 4/20/17.
//  Copyright © 2017 Bharath D N. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController {
  
  var tweets: [Tweet] = []
  var replyIndex: Int?
  var detailsViewIndex: Int?
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("HELLO FROM MENTIONS VC")
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 200
  }
  
  
  override func viewWillAppear(_ animated: Bool) {
    loadMentions()
  }
  
  
  func loadMentions() {
    var parameters = [String: AnyObject]()
    parameters["count"] = 20 as AnyObject
    
    TwitterClient.sharedInstance?.mentions(parameters: parameters ,success: { (tweets: [Tweet]?) in
      print("*** \(tweets?.count ?? 0) Number of MENTION TWEETS retrieved for user")
      
      self.tweets += tweets!
      self.tableView.reloadData()
      
    }, failure: { (error: Error) in
      print(error.localizedDescription)
    })
  }
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}

// MARK: - Table and Scroll View
extension MentionsViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = Bundle.main.loadNibNamed("TweetPrototypeCell", owner: self, options: nil)?.first as! TweetPrototypeCell
    cell.tweet = tweets[indexPath.row]
    return cell
  }
  
  //  func scrollViewDidScroll(_ scrollView: UIScrollView) {
  //    // Calculate the position of one screen length before the bottom of the results
  //    let scrollViewContentHeight = tableView.contentSize.height
  //    let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
  //
  //    if (!isMoreDataLoading) {
  //      // When the user has scrolled past the threshold, start requesting
  //      if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
  //        print("UI Scrolled for more data")
  //        isMoreDataLoading = true
  //        // Update position of loadingMoreView, and start loading indicator
  //        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
  //        loadingMoreView?.frame = frame
  //        loadingMoreView!.startAnimating()
  //
  //        loadTweets()
  //      }
  //    }
  //  }
}

