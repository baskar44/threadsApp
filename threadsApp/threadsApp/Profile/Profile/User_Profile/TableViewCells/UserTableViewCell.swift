//
//  UserTableViewCell.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 7/12/17.
//  Copyright © 2017 Gururaj Baskaran. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var followerState: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    var cellIndexPath: IndexPath?
    
    func configure(username: String, followerState: String){
        self.followerState.setTitle(followerState, for: .normal)
        usernameLabel.text = username
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        followerState.layer.cornerRadius = 12
        cellImageView.layer.cornerRadius = cellImageView.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
