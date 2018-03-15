    //
//  ProfileViewController.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 3/12/17.
//  Copyright © 2017 Gururaj Baskaran. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class ProfileViewController: UIViewController {

    var shouldPop: Bool = false
    var currentUserStructure: UserStructure?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !shouldPop {
            navigationController?.isNavigationBarHidden = true
            
            if let mainTabViewController = parent?.parent as? MainTabBarController {
                
                guard let currentUserStructure = mainTabViewController.currentUserStructure else {
                    return
                }
                
                //core lists which are required to be loaded before user can be sent to profile
                //adding remove observers for all user list types...
                let listTypes: [User.ListType] = [.followers, .following, .createdThreads]
                let threadsData = ThreadsData.sharedInstance
                
                for type in listTypes {
                    
                    let listManagerWithFeedback = threadsData.getUserListManager(selectedUserStruture: currentUserStructure, employedBy: currentUserStructure, listType: type)
                    
                    let listManager = listManagerWithFeedback.0
                    
                  
                }
                
                let manager = UserProfileManager(employedBy: currentUserStructure, selectedUserStructure: currentUserStructure)
                
                let profileVC = ProfileVC(manager: manager)
                navigationController?.pushViewController(profileVC, animated: true)
                
            }
        }else {
            dismiss(animated: true, completion: nil)
  
        }
    }
}
