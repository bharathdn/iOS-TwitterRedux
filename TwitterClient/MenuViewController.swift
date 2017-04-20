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
  
  private var homeTimeLineViewController: UIViewController!
  private var mentionsViewController: UIViewController!
  
  @IBOutlet weak var tableView: UITableView!
  let menuLabels = ["Profile", "TimeLine", "Mentions", "Accounts"]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    
    print("Hello from Menu view c")
    
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    homeTimeLineViewController = storyBoard.instantiateViewController(withIdentifier: "HomeTimeLineViewController")
    viewControllers.append(homeTimeLineViewController)
    // change this later
    viewControllers.append(homeTimeLineViewController)
    
    mentionsViewController = storyBoard.instantiateViewController(withIdentifier: "MentionsViewController")
    viewControllers.append(mentionsViewController)
    viewControllers.append(mentionsViewController)
    hamburgerViewController.contentViewController = viewControllers[0]
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
    print("setting row at indexpath \(indexPath.row)")
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewControllers.count
  }
}
