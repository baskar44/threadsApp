//
//  HeadingTableVC.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 3/12/17.
//  Copyright © 2017 Gururaj Baskaran. All rights reserved.
//

import UIKit

class HeadingTableVC: UITableViewCell {

    @IBOutlet weak var headingLabel: UILabel!
    
    func configure(headingText: String){
        headingLabel.text = headingText
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
