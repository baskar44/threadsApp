//
//  FeedThreadCVC.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 7/3/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

class FeedThreadCVC: UICollectionViewCell {

    @IBOutlet weak var responsiveTimeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var threadView: ThreadView!
    @IBOutlet weak var backView: UIView!
    
    func configure(threadTitle: String, username: String, threadCreatedDateString: String, message: String, feedCreatedDateString: String){
        // threadTitleLabel.text = threadTitle
        // creatorUsername.text = username
        // createdDateLabel.text = createdDateString
        threadView.configure(createdDate: threadCreatedDateString, threadTitle: threadTitle, creatorUsername: username)
        
        messageLabel.text = message
        responsiveTimeLabel.text = feedCreatedDateString
       
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backView.layer.cornerRadius = 12
    }
}
