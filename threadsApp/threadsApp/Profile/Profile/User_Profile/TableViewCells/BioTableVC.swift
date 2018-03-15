//
//  BioTableVC.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 3/12/17.
//  Copyright © 2017 Gururaj Baskaran. All rights reserved.
//

import UIKit

class BioTableVC: UITableViewCell {

    @IBOutlet weak var bioLabel: UILabel!
    
    private func configure(bioText: String){
        bioLabel.text = bioText
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bioLabel.layer.cornerRadius = 12
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
