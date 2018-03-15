//
//  PhotoCVC.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 25/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

class PhotoCVC: UICollectionViewCell {
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var editView: UIView!
    
    func configure(editMode: Bool, imageURL: String, text: String?){
        cellImageView.loadImageUsingCacheWithURLString(imageURL: imageURL) { (didLoad, error) in
            //maybe later
        }
        
        if editMode {
            editView.isHidden = false
        }else {
            editView.isHidden = true
        }
        
        //cellTextView.text = text
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellImageView.layer.cornerRadius = 2
        editView.layer.cornerRadius = editView.frame.width/2
    }

}
