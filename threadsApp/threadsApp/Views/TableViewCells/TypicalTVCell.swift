//
//  TypicalTVCell.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 14/11/17.
//  Copyright © 2017 Gururaj Baskaran. All rights reserved.
//

import UIKit

class TypicalTVCell: UITableViewCell {

    @IBOutlet weak var cellSubLabel: UILabel!
    @IBOutlet weak var cellMainLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    @IBOutlet weak var backView: UIView!
    func configure(imageURL: String? = nil, mainLabel: String, subLabel: String? = nil) {
        //set imageURL later
        cellMainLabel.text = mainLabel
        cellSubLabel.text = subLabel
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellImageView.layer.cornerRadius = cellImageView.frame.height/2
        backView.layer.cornerRadius = 12
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
