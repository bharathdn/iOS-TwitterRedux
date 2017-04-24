//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Bharath D N on 4/20/17.
//  Copyright © 2017 Bharath D N. All rights reserved.
//

import UIKit
import AFNetworking
import CoreImage

class ProfileViewController: UIViewController {
  
  var tweets: [Tweet] = []
  var user: User!
  var headerView: ProfileCell!
  
  var context = CIContext(options: nil)
  
  @IBOutlet weak var tableView: UITableView!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 200
  }
  
  override func viewWillAppear(_ animated: Bool) {
    if user == nil {
      user = User.currentUser
    }
    getTweetsForUser(user: user)
    
    headerView = Bundle.main.loadNibNamed("ProfileCell", owner: self, options: nil)?.first as! ProfileCell
    headerView.user = user
    headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height)
    headerView.setNeedsLayout()
    headerView.layoutIfNeeded()
    tableView.tableHeaderView = headerView
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
  
  // MARK: - Event handler
  
  @IBAction func onCancel(_ sender: Any) {
    dismiss(animated: true) {
      print("exiting profile view")
    }
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

extension ProfileViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
    let offset = scrollView.contentOffset.y
    
    // PULL DOWN -----------------
    if offset < 0 {
      UIView.animate(withDuration: 0.1, animations: {
        self.headerView.userBackgroundImageView.transform = CGAffineTransform(scaleX: 1.3, y: 2)
        self.headerView.userBackgroundImageView.alpha = 0.2
      })
    }
      // Scroll up
    else {
      UIView.animate(withDuration: 0.1, animations: {
        self.headerView.userBackgroundImageView.transform = CGAffineTransform.identity
        self.headerView.userBackgroundImageView.alpha = 1
      })
    }
  }
  
  
  
  // Blur image code: runs very slow!
  // code from : http://stackoverflow.com/questions/41156542/how-to-blur-an-existing-image-in-a-uiimageview-with-swift
}
