//
//  TableView+extension.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 6/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

extension UITableView {
    
    func setup(accessibilityIdentifier: String, delegate: UITableViewDelegate, dataSource: UITableViewDataSource, backgroundColor: UIColor?, register types: [TableViewCellType]){
        
        self.delegate = delegate
        self.dataSource = dataSource
        //self.backgroundColor = backgroundColor
        self.accessibilityIdentifier = accessibilityIdentifier
       
        handleTableViewRegistration(types: types)
    }
    
    private func handleTableViewRegistration(types: [TableViewCellType]){
        for type in types {
            let identifier = type.rawValue
            let nib = UINib(nibName: identifier, bundle: nil)
            register(nib, forCellReuseIdentifier: identifier)
        }
    }
}


extension UICollectionView {
    
    func setup(accessibilityIdentifier: String, delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource, backgroundColor: UIColor?, register types: [CollectionViewCellType]){
        
        self.delegate = delegate
        self.dataSource = dataSource
        self.backgroundColor = backgroundColor
        self.accessibilityIdentifier = accessibilityIdentifier
        handleCollectionViewRegistration(types: types)
    }
    
    private func handleCollectionViewRegistration(types: [CollectionViewCellType]){
        for type in types {
            let identifier = type.rawValue
            let nib = UINib(nibName: identifier, bundle: nil)
            register(nib, forCellWithReuseIdentifier: identifier)
        }
        
        
    }
}
