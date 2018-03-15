//
//  AboutOrBioTVC.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 5/12/17.
//  Copyright © 2017 Gururaj Baskaran. All rights reserved.
//

import UIKit

class AboutOrBioTVC: UITableViewCell {

    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var aboutTextView: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(aboutText: String, labelText: String){
        aboutTextView.text = aboutText
        aboutLabel.text = labelText
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
