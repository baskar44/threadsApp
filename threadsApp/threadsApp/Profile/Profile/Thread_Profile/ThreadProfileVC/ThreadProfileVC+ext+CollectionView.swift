//
//  ThreadProfileVC+ext+CollectionView.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 28/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

extension ThreadProfileVC {
    //MARK:- Collection View
}

extension ThreadProfileVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let manager = manager else {
            return
        }
        
        if editMode {
            
            if let photo = frcForInstanceMedia?.sections?[indexPath.section].objects?[indexPath.row] as? Photo {
                
                guard let photoStructure = photo.createStructure() else {
                    return
                }
                
                let notepadManager = NotepadManager(mode: (true, photoStructure), employedBy: manager.getEmployer(), workingUnder: self, selectedMedia: nil)
                let notepadVC = NotepadVC(manager: notepadManager)
                navigationController?.pushViewController(notepadVC, animated: true)
                
            }
        }
        
    }
   
}

extension ThreadProfileVC: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return CGSize.zero
        }
        return CGSize(width: keyWindow.frame.width, height: collectionView.frame.height - 32)
    }
    
    
    
}

extension ThreadProfileVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return frcForInstanceMedia?.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return frcForInstanceMedia?.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let photo = frcForInstanceMedia?.sections?[indexPath.section].objects?[indexPath.row] as? Photo {
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.sharedInstance._PhotoCVC, for: indexPath) as? PhotoCVC {
                
                var url = Constants.sharedInstance._emptyString
                
                if let imageURL = photo.imageURL {
                    url = imageURL
                }
                
                cell.configure(editMode: editMode, imageURL: url, text: photo.about)
                
                return cell
            }
        }
        
        let cell = UICollectionViewCell()
        cell.backgroundColor = .orange
        return cell
    }
}
