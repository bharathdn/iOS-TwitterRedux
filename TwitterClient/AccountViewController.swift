//
//  AccountViewController.swift
//  TwitterClient
//
//  Created by Bharath D N on 4/22/17.
//  Copyright © 2017 Bharath D N. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {
  
  var users: [User]!

  var footerView: AddButtonCell!
  @IBOutlet weak var tableView: UITableView!
 
  var hamburgerViewController: HamburgerViewController!
  var homeTimeLineViewController: TweetsViewController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    tableView.dataSource = self
    
    users = User.users
    addFooterView()
  }
  
  
  func addFooterView() {
    footerView = Bundle.main.loadNibNamed("AddButtonCell", owner: self, options: nil)?.first as! AddButtonCell
    footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: footerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height)
    footerView.setNeedsLayout()
    footerView.layoutIfNeeded()
    tableView.tableFooterView = footerView
    
    // add action for footer
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AccountViewController.onPlusButtonTap(_:)))
    tapGesture.numberOfTouchesRequired = 1
    tapGesture.numberOfTapsRequired = 1
    footerView.addGestureRecognizer(tapGesture)
  }
  
  func onPlusButtonTap(_ sender: UITapGestureRecognizer) {
      TwitterClient.sharedInstance?.login(
        success: {
          self.users = User.users
          self.tableView.reloadData()
      },
        failure: { (error) in
          print("error adding new user")
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

extension AccountViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = Bundle.main.loadNibNamed("AccountLabelImageCell", owner: self, options: nil)?.first as! AccountLabelImageCell
    cell.user = users[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    User.currentUser = users[indexPath.row]
    print("\n new user account \(User.currentUser?.name ?? "unknown") has been set \n")
    tableView.deselectRow(at: indexPath, animated: true)
    if User.loadAccessToken() {
      TwitterClient.sharedInstance?.currentAccount(
        success: {_ in
          print("Newly selected user set")
          self.loadHomeTimeline()
      },
      failure: { error in
          return print(error.localizedDescription)
      })
    }
  
    UIView.animate(withDuration: 1) {
      self.loadHomeTimeline()
    }
    
  }
  
  func loadHomeTimeline() {
    hamburgerViewController.contentViewController = homeTimeLineViewController
  }
  
}
