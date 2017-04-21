//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Bharath D N on 4/20/17.
//  Copyright © 2017 Bharath D N. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileViewController: UIViewController {
  
  var tweets: [Tweet] = []
  var user: User!
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var userBackgroundImageView: UIImageView!
  @IBOutlet weak var userImageView: UIImageView!
  @IBOutlet weak var userNameLabel: UILabel!
  @IBOutlet weak var userScreeNameLabel: UILabel!
  
  @IBOutlet weak var followersCountLabel: UILabel!
  @IBOutlet weak var followingCountLabel: UILabel!
  @IBOutlet weak var tweetCountLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 200
    
    user = User.currentUser
    populateUserElements()
    getTweetsForUser(user: user)
  }
  
  func getTweetsForUser(user: User) {
    var parameters = [String: AnyObject]()
    parameters["count"] = 20 as AnyObject
    parameters["user_id"] = user.id as AnyObject
    
    TwitterClient.sharedInstance?.userTimeline(parameters: parameters ,success: { (tweets: [Tweet]?) in
      print("*** \(tweets?.count ?? 0) Number of tweets retrieved for user profile")
      
      self.tweets += tweets!
      self.tableView.reloadData()
    }, failure: { (error: Error) in
      print(error.localizedDescription)
    })

  }
  
  func populateUserElements() {
    userBackgroundImageView.setImageWith(user.profileBackgroundImageUrl!)
    userImageView.setImageWith(user.profileImageUrl!)
    userScreeNameLabel.text = user.screenName
    userNameLabel.text = user.name
    followersCountLabel.text = String(user.followerCount!)
    followingCountLabel.text = String(user.followerCount!)
    tweetCountLabel.text = String(user.tweetCount!)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
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

// MARK: - Navigation
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = Bundle.main.loadNibNamed("TweetPrototypeCell", owner: self, options: nil)?.first as! TweetPrototypeCell
    cell.tweet = tweets[indexPath.row]
    return cell
  }
  
}
