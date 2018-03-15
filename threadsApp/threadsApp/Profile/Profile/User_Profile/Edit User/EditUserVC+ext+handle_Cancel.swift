//
//  EditUserVC+ext+handle_Cancel.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 27/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit


extension EditUserVC {
   /*
    private func handleCancel() -> WarningType? {
        
        guard let username = (currentUserStructure?.username), let visibility = currentUserStructure?.visibility else {
            return .currentUsernameOrVisibilityIsNil
        }
        
        
        let fullname = (currentUserStructure?.fullname) ?? s_._emptyString
        let bio = (currentUserStructure?.bio) ?? s_._emptyString
        
        //checking if any changes have been made to the user's core
        if username == usernameTextField.text && bio == bioTextView.text && fullname == fullnameTextField.text && visibility == visibilitySwith.isOn {
            
            if !didChangeProfileImage {
                return nil
            }else {
                return .profileImageHasBeenChanged
            }
            
        }else {
            return .unsavedDataExists
        }
    }
    
    private func loadAlertVC(for warningType: WarningType){
        
        let title = s_._Warning
        
        let alertController = UIAlertController(title: title, message: warningType.rawValue, preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: s_._Cancel, style: .cancel) { (alert) in
            return
        }
        
        let backButton = UIAlertAction(title: s_._Back, style: .default) { (alert) in
            self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addAction(cancelButton)
        alertController.addAction(backButton)
        
        present(alertController, animated: true, completion: {
            self.view.isUserInteractionEnabled = false
        })
    }
    
    @objc func handleCancelButtonTapped(){
        
        if let warningType = handleCancel() {
            loadAlertVC(for: warningType)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
       
    }
 */
}


