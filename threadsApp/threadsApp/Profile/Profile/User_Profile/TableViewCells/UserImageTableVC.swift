//
//  UserImageTableVC.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 3/12/17.
//  Copyright © 2017 Gururaj Baskaran. All rights reserved.
//

import UIKit

class UserImageTableVC: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userFollowStateButton: UIButton!
    @IBOutlet weak var userSendMessageButton: UIButton!
    @IBOutlet weak var userOtherButton: UIButton!
    
    func configure(userProfileImageURL: String){
        //todo
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        userFollowStateButton.layer.cornerRadius = userFollowStateButton.frame.height/2
        userSendMessageButton.layer.cornerRadius = userSendMessageButton.frame.height/2
        userOtherButton.layer.cornerRadius = userOtherButton.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
