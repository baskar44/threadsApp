//
//  EditUserVC+ext+handle_Save.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 27/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit


extension EditUserVC {
    /*
    private func loadAlertVC(for failedType: EditUserFailedType){
        
        let title = s_._Failed
        
        let alertViewController = UIAlertController(title: title, message: failedType.rawValue, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: s_._Cancel, style: .cancel) { (alert) in
            self.view.isUserInteractionEnabled = true
        }
        
        alertViewController.addAction(cancelAction)
        
        present(alertViewController, animated: true) {
            self.view.isUserInteractionEnabled = false
        }
    }
    
    private func handleSave(completion: @escaping (Bool, EditUserFailedType?, Error?) -> Void){
        self.view.isUserInteractionEnabled = false
        
        guard let username = usernameTextField.text else  {
            completion(false, .usernameIsEmpty, nil)
            return
        }
        
        guard let currentUsername = currentUserStructure?.username else {
            //error handle
            completion(false, .currentUsernameIsNil, nil)
            return
        }
        
        guard usernameTextField.text != s_._emptyString else {
            completion(false, .usernameIsEmpty, nil)
            return
        }
        
        //If username did not change
        if currentUsername == username {
            
            self.handleEditUser(completion: { (didEditUser, failedType, error) in
                completion(didEditUser, failedType, error)
                return
            })
            
        }else { //if username did change from original username
            
            database.child(s_._User).queryOrdered(byChild: s_._username).queryEqual(toValue: username).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let _ = snapshot.value as? NSDictionary {
                    //username already exists
                    completion(false, .usernameAlreadyExists, nil)
                    return
                }else {
                    self.handleEditUser(completion: { (didEditUser, failedType, error) in
                        completion(didEditUser, failedType, error)
                        return
                    })
                }
            })
        }
    }
    
    @objc func handleSaveButtonTapped(){
     
        self.view.isUserInteractionEnabled = false
        
        handleSave { (didSave, failedType, error) in
            if didSave {
                self.navigationController?.popViewController(animated: true)
                
            }else {
                if let failedType = failedType {
                    self.loadAlertVC(for: failedType)
                }
                
                if let error = error {
                    //error handle later
                    print("mark: error: \(error)")
                }
            }
        }
        
    }
    
    
    private func handleEditUser(completion: @escaping (Bool, EditUserFailedType?, Error?) -> Void) {
        
        guard let currentUserStructure = currentUserStructure else {
            completion(false, .currentUserIsNoLongerActive ,nil)
            return
        }
        
        guard let username = usernameTextField.text else {
            //should not happen
            completion(false, .usernameIsEmpty ,nil)
            return
        }
        
        let visibility = self.visibilitySwith.isOn
        let fullname = self.fullnameTextField.text ?? s_._emptyString
        let bio = self.bioTextView.text ?? s_._emptyString
        
        let editInfo = [self.s_._username:username,
                        self.s_._bio:bio,
                        self.s_._fullname:fullname,
                        self.s_._visibility:visibility] as [String:Any]
        
        if didChangeProfileImage, let image =
            self.userProfileImageView.image {
            
            //here
            currentUserStructure.updateProfileImage(with: image, completion: { (didUpdateProfileImage, error) in
                if didUpdateProfileImage {
                    
                    if currentUserStructure.edit(editInfo: editInfo) {
                        completion(true, nil, nil)
                    }else {
                        completion(false, .editProcessFailed, nil)
                    }
                    
                    return
                    
                }else {
                    if let error = error {
                        completion(false, .profileImageUpdateFailed, error)
                    }else {
                        completion(false, .profileImageUpdateFailed, nil)
                    }
                    
                    return
                }
            })
            
        }else {
            //here
            if currentUserStructure.edit(editInfo: editInfo) {
                completion(true, nil, nil)
            }else {
                completion(false, .editProcessFailed, nil)
            }
            
            return
        }
    }
    */
}

