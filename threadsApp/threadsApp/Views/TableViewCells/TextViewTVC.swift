//
//  TextViewTVC.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 15/12/17.
//  Copyright © 2017 Gururaj Baskaran. All rights reserved.
//

import UIKit

class TextViewTVC: UITableViewCell {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var cellHeading: UILabel!
    @IBOutlet weak var cellMarker: UIView!
    @IBOutlet weak var cellHeadingHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var cellMarkerHeightLayoutConstraint: NSLayoutConstraint!
    
    func configure(text: String, headingText: String){
        textView.text = text
        
        if headingText == Constants.sharedInstance._emptyString {
            cellHeadingHeightLayoutConstraint.constant = 0
            cellMarkerHeightLayoutConstraint.constant = 0
        }else {
           cellHeading.text = headingText
        }
        
        
        

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellMarker.layer.cornerRadius = cellMarker.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
