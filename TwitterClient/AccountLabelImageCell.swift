//
//  AccountLabelImageCell.swift
//  TwitterClient
//
//  Created by Bharath D N on 4/22/17.
//  Copyright © 2017 Bharath D N. All rights reserved.
//

import UIKit

class AccountLabelImageCell: UITableViewCell {
  
  @IBOutlet weak var accountLabel: UILabel!

  var user: User! {
    didSet {
      if user != nil {
        accountLabel.text = user.name
      }
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
