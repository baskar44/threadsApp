//
//  EditUserVC+ext+TableView.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 27/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

/*
extension EditUserVC: UITableViewDataSource {
    //section 1 - user image
    //section 2 - username and fullname
    //section 3 - bio
    //section 4 - visibility
    //section 5 - change password
    /*
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewDisplay.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDisplay[section].count
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let originalImage = info[s_._UIImagePickerControllerOriginalImage] as? UIImage {
            
            userProfileImageView.image = originalImage
            didChangeProfileImage = true
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let display = tableViewDisplay[indexPath.section][indexPath.row]
        let cell = UITableViewCell()
        switch display {
        case .username:
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: s_._TextFieldTVC, for: indexPath) as? TextFieldTVC {
                var username: String = s_._emptyString
                
                if let currentUsername = currentUserStructure?.username {
                    username = currentUsername
                }
                
                cell.configure(textFieldText: username, headingLabelText: s_._Username)
                usernameTextField = cell.textField
                return cell
            }
            
            break
        case .fullname:
            if let cell = tableView.dequeueReusableCell(withIdentifier: s_._TextFieldTVC, for: indexPath) as? TextFieldTVC {
                
                var fullname: String = s_._emptyString
                
                if let currentFullName = currentUserStructure?.fullname {
                    fullname = currentFullName
                }
                
                cell.configure(textFieldText: fullname, headingLabelText: s_._Full_name)
                fullnameTextField = cell.textField
                return cell
            }
            break
        case .bio:
            if let cell = tableView.dequeueReusableCell(withIdentifier: s_._TextViewTVC, for: indexPath) as? TextViewTVC {
                
                
                cell.isHidden = false
                var bioText: String = s_._emptyString
                
                if let currentBioText = currentUserStructure?.bio {
                    bioText = currentBioText
                }
                
                bioTextView = cell.textView
                cell.textView.isEditable = true
                cell.textView.isSelectable = true
                cell.configure(text: bioText, headingText: s_._Bio)
                return cell
            }
            
            break
        case .visibility:
            if let cell = tableView.dequeueReusableCell(withIdentifier: s_._SwitchTVC, for: indexPath) as? SwitchTVC {
                
                var visibility: Bool = false
                
                if let currentVisibility = currentUserStructure?.visibility {
                    visibility = currentVisibility
                }
                
                visibilitySwith = cell.cellSwitch
                cell.configure(label: s_._Public, switchState: visibility)
                return cell
            }
            break
        case .changePassword:
            cell.backgroundColor = .darkGray
            if let cell = tableView.dequeueReusableCell(withIdentifier: s_._TypicalTVCell, for: indexPath) as? TypicalTVCell {
                cell.configure(mainLabel: s_._Change_password)
                return cell
            }
            break
        }
        
        return cell
    }
}

extension EditUserVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let branch = tableViewDisplay[indexPath.section][indexPath.row]
        
        switch branch {
        case .username:
            return 90
        case .fullname:
            return 90
        case .bio:
            return 120
        case .visibility:
            return 90
        case .changePassword:
            return 60
        }
    }
 */
}
*/
