//
//  TextFieldTVC.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 15/12/17.
//  Copyright © 2017 Gururaj Baskaran. All rights reserved.
//

import UIKit

class TextFieldTVC: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldHeadingLabel: UILabel!
    
    @IBOutlet weak var markerView: UIView!
    
    func configure(textFieldText: String, headingLabelText: String){
        
        textField.text = textFieldText
        textFieldHeadingLabel.text = headingLabelText
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        markerView.layer.cornerRadius = markerView.frame.height/2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
