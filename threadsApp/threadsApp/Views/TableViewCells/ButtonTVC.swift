//
//  ButtonTVC.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 9/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

class ButtonTVC: UITableViewCell {

    @IBOutlet weak var cellButton: UIButton!
    
    func configure(buttonTitle: String){
        cellButton.setTitle(buttonTitle, for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellButton.layer.cornerRadius = 9
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
