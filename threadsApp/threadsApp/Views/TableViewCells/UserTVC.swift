//
//  UserTVC.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 18/12/17.
//  Copyright © 2017 Gururaj Baskaran. All rights reserved.
//

import UIKit

class UserTVC: UITableViewCell {

    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userFollowStateButton: UIButton!
    
    func configure(fullname: String?, username: String, userImageURL: String?){
        
        fullnameLabel.text = fullname
        usernameLabel.text = username
        userImageView.loadImageUsingCacheWithURLString(imageURL: userImageURL) { (didLoad, error) in
            //maybe later
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        userFollowStateButton.layer.cornerRadius = 6
        userImageView.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
