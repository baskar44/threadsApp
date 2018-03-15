//
//  ProfileVC+ext+CoreSubViews.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 7/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

extension ProfileVC {
    //MARK:- Functions setting up Sub Views
    
    internal func setupProfileImageViewCornerRadius(){
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
    }
    
    //Tested 2/20/2018
    internal func getProfileImageViewHeight(imageURL: String?) -> CGFloat {
        if imageURL == nil {
            return 120
        }else {
            return 120
        }
    }
    
    internal func setupBioLabel(manager: UserProfileManager) {
        
        fullnameLabel.text = manager.selectedUserStructure.fullname
        
        bioLabel.text = manager.selectedUserStructure.bio
        headerView.layoutIfNeeded()
        
        let constant = bioLabel.frame.maxY + 16
        
        if constant < 90 {
            headerViewHeightConstraint.constant = 90
        }else {
            headerViewHeightConstraint.constant = constant
        }
        
        
    }
    
    //Tested 2/20/2018
    internal func getFollowStateButtonHeight(accessLevel: UserAccessLevel)  -> CGFloat {
        if accessLevel == .current || accessLevel == .failed {
            return 0
        }else {
            return 30
        }
    }
    
    internal func setupProfileImageView(imageURL: String?, completion: @escaping (ProfileVCFeedback) -> Void){
        //profileImageViewHeighLayoutConstraint.constant = getProfileImageViewHeight(imageURL: imageURL) //tested
        profileImageView.loadImageUsingCacheWithURLString(imageURL: imageURL) { (didLoad, error) in  //Need to test..
            //maybe later - activity indicator
            if didLoad {
                completion(ProfileVCFeedback.didLoadProfileImageURL)
            }else {
                if let _ = error {
                    completion(ProfileVCFeedback.failedToLoadProfileImageURLWithErr)
                }else {
                    completion(ProfileVCFeedback.failedToLoadProfileImageURL)
                }
            }
            
            return
        }
    }
    
    internal func setupFollowStateSubView(manager:UserProfileManager, completion: @escaping (Bool) -> Void){
       
        /*
        self.followStateButton.addTarget(self, action: #selector(self.followStateButtonTapped), for: .touchDown)
        manager.getFollowState { (followState) in
            self.followStateButton.setTitle(followState.rawValue, for: .normal)
            completion(true)
            return
        }
        */
    }
 
    
    
    //Tested 2/20/2018
    internal func getTableViewDisplay(accessLevel: UserAccessLevel) -> [[TableViewRowDisplay]] {
        
        var tableViewDisplay: [[TableViewRowDisplay]] = []
        
        switch accessLevel {
        case .current:
            tableViewDisplay = [[.feed],[.threads],[.followers, .following], [.edit, .signOut]]
            break
        case .full:
            tableViewDisplay = [[.feed],[.threads],[.followers, .following], [.report, .block]]
            break
        case .noAccess:
            tableViewDisplay = [[.noAccess], [.report, .block]]
            break
        default:
            break
        }
        
        return tableViewDisplay
    }
    
    //MARK:- Selector Functions
    @objc internal func followStateButtonTapped(sender: UIButton){
        
        guard let manager = manager else {
            return
        }
        
        guard let senderTitle = sender.titleLabel?.text else {
            return loadLocalAlertController(failedType: .failedToRetrieveFollowStateButtonTitle)
        }
        
        sender.setTitle(Constants.sharedInstance._Loading, for: .normal)
        
        handleFollowState(senderTitle: senderTitle, manager: manager) { (feedback, followState) in
            sender.setTitle(followState.rawValue, for: .normal)
            return
        }
    }
}
