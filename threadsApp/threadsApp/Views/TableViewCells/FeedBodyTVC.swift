//
//  FeedBodyTVC.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 14/3/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

class FeedBodyTVC: UITableViewCell {

    @IBOutlet weak var feedResponsiveTimeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bodyTextLabel: UILabel!
    @IBOutlet weak var creatorUsernameLabel: UILabel!
    @IBOutlet weak var bodyView: UIView!
    
    @IBOutlet weak var backView: UIView!
    func configure(message: String, bodyText: String, creatorUsername: String, responsiveTime: String){

        messageLabel.text = message
        bodyTextLabel.text = bodyText
        creatorUsernameLabel.text = creatorUsername
        feedResponsiveTimeLabel.text = responsiveTime
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backView.layer.cornerRadius = 12
        bodyView.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
