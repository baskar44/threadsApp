//
//  ThreadTVC.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 22/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

class ThreadTVC: UITableViewCell {

    @IBOutlet weak var threadTitleLabel: UILabel!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    @IBOutlet weak var threadView: ThreadView!
    
    func configure(threadTitle: String, username: String, createdDateString: String){
       // threadTitleLabel.text = threadTitle
       // creatorUsername.text = username
       // createdDateLabel.text = createdDateString
        threadView.configure(createdDate: createdDateString, threadTitle: threadTitle, creatorUsername: username)
      
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       //cellImageView.layer.cornerRadius = cellImageView.frame.width/2
       // layoutIfNeeded()
        threadView.layer.cornerRadius = 12
        threadView.layer.shadowColor = UIColor.darkGray.cgColor
        threadView.layer.shadowOpacity = 0.05
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
