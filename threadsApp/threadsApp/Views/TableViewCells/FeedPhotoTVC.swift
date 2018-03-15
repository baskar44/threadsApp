//
//  FeedPhotoTVC.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 14/3/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

class FeedPhotoTVC: UITableViewCell {

    @IBOutlet weak var feedResponsiveTimeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var creatorUsernameLabel: UILabel!
    @IBOutlet weak var bodyView: UIView!
    
    @IBOutlet weak var backView: UIView!
    func configure(message: String, imageURL: String, creatorUsername: String, responsiveTime: String){
         photoImageView.loadImageUsingCacheWithURLString(imageURL: imageURL) { (didLoad, error) in
        
        }
        messageLabel.text = message
        creatorUsernameLabel.text = creatorUsername
        feedResponsiveTimeLabel.text = responsiveTime
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backView.layer.cornerRadius = 12
        bodyView.layer.cornerRadius = 12
    }
    
}
