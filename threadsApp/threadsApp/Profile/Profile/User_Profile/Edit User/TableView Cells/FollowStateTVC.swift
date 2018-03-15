//
//  FollowStateTVC.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 16/12/17.
//  Copyright © 2017 Gururaj Baskaran. All rights reserved.
//

import UIKit

class FollowStateTVC: UITableViewCell {

    @IBOutlet weak var followStateButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        followStateButton.layer.cornerRadius = followStateButton.frame.height/6
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
