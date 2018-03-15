//
//  TitleTVC.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 5/12/17.
//  Copyright © 2017 Gururaj Baskaran. All rights reserved.
//

import UIKit

class TitleTVC: UITableViewCell {

    @IBOutlet weak var titleTextView: UITextField!
    
    func configure(titleText: String){
        titleTextView.text = titleText
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
