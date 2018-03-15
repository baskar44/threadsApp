//
//  InstanceImageCVC.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 10/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

class InstanceImageCVC: UICollectionViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    
    func configure(imageURL: String?){
        cellImageView.loadImageUsingCacheWithURLString(imageURL: imageURL) { (didLoad, error) in
            
        }
          
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //cellImageView.layer.cornerRadius = cellImageView.frame.width/2
        // Initialization code
    }

}
