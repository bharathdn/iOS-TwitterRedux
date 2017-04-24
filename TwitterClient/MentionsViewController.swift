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
  var profileIndex: Int?
  
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
  
  

   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "MentionsToProfile" {
      let tweet = tweets[replyIndex!]
      let tweetDictionary = tweet.tweetDictionary
      let userDictionary = tweetDictionary?["user"] as! [String: AnyObject]
      let user = User(dictionary: userDictionary)
      
      let uiNavigationController = segue.destination as! UINavigationController
      let profileViewController = uiNavigationController.topViewController as! ProfileViewController
      profileViewController.user = user
    }
   }
  
}

// MARK: - Table and Scroll View
extension MentionsViewController: UITableViewDataSource, UITableViewDelegate, TweetPrototypeCellDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = Bundle.main.loadNibNamed("TweetPrototypeCell", owner: self, options: nil)?.first as! TweetPrototypeCell
    cell.tweet = tweets[indexPath.row]
    cell.index = indexPath.row
    cell.delegate = self
    return cell
  }

  func tweetPrototypeCell (tweetPrototypeCell: TweetPrototypeCell, didClickUserImage tweet: Tweet) {
    replyIndex = tweetPrototypeCell.index
    performSegue(withIdentifier: "MentionsToProfile", sender: nil)
  }
  
}

