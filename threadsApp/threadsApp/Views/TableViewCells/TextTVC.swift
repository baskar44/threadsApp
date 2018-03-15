//
//  TextTVC.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 22/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

class TextTVC: UITableViewCell {

    @IBOutlet weak var cellText: UILabel!
    @IBOutlet weak var backView: UIView!
    
    func configure(text: String){
        
        cellText.text = text
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backView.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
