//
//  CollectionViewTVC.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 10/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

class CollectionViewTVC: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    func configure(collectionViewDelegate: UICollectionViewDelegate, collectionViewDataSource: UICollectionViewDataSource, idenfitier: String){
     
        collectionView.delegate = collectionViewDelegate
        collectionView.dataSource = collectionViewDataSource
        collectionView.accessibilityIdentifier = idenfitier
        //register
        let identifier = Constants.sharedInstance._InstanceImageCVC
        let nib = UINib(nibName: identifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
        collectionView.invalidateIntrinsicContentSize()
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
