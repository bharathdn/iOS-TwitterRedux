//
//  MenuViewController.swift
//  TwitterClient
//
//  Created by Bharath D N on 4/20/17.
//  Copyright © 2017 Bharath D N. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
  
  var viewControllers: [UIViewController] = []
  var hamburgerViewController: HamburgerViewController!
  
  private var profileViewController: ProfileViewController!
  private var homeTimeLineViewController: TweetsViewController!
  private var mentionsViewController: MentionsViewController!
  private var accountsViewController: AccountViewController!
  
  @IBOutlet weak var tableView: UITableView!
  let menuLabels = ["Profile", "TimeLine", "Mentions", "Accounts"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 200
    
    print("Hello from Menu view c")
    instantiateViewControllers()
    hamburgerViewController.contentViewController = viewControllers[1]
  }
  
  private func instantiateViewControllers() {
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    profileViewController = storyBoard.instantiateViewController(withIdentifier: "UserProfileView") as! ProfileViewController
    homeTimeLineViewController = storyBoard.instantiateViewController(withIdentifier:
      "HomeTimeLineViewController") as! TweetsViewController
    mentionsViewController = storyBoard.instantiateViewController(withIdentifier: "MentionsViewController") as! MentionsViewController
    accountsViewController = storyBoard.instantiateViewController(withIdentifier: "AccountView") as! AccountViewController
    accountsViewController.hamburgerViewController = hamburgerViewController
    accountsViewController.homeTimeLineViewController = homeTimeLineViewController
    
    viewControllers.append(profileViewController)
    viewControllers.append(homeTimeLineViewController)
    viewControllers.append(mentionsViewController)
    viewControllers.append(accountsViewController)
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

extension MenuViewController : UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    hamburgerViewController.contentViewController = viewControllers[indexPath.row]
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell") as! MenuCell
    cell.menuLabel.text = menuLabels[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewControllers.count
  }
}
