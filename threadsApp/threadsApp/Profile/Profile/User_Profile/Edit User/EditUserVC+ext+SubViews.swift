//
//  EditUserVC+ext+SubViews.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 27/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

/*
extension EditUserVC {
    
    func run(){
        setupBackLitView()
        setupActivityIndiactor()
        setupNavigationBar()
        setupUserProfileImageView()
        addNotifications()
        setupTableView()
    }
    
    func showActivityIndicator(){
        backLitView.isHidden = false
        activityIndicatorBackgroundView.isHidden = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator(){
        backLitView.isHidden = true
        activityIndicatorBackgroundView.isHidden = true
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func setupBackLitView(){
        backLitView.isHidden = true
    }
    
    private func setupActivityIndiactor(){
        activityIndicatorBackgroundView.isHidden = true
        activityIndicator.isHidden = true
        activityIndicatorBackgroundView.layer.cornerRadius = activityIndicatorBackgroundView.frame.width/2
        activityIndicator.stopAnimating()
    }
    
    
    
    private func setupTableView(){
        
        tableView.accessibilityIdentifier = "EditUser"
        
        if let keyWindow = UIApplication.shared.keyWindow, let y = navigationController?.navigationBar.frame.height {
            let height = keyWindow.frame.height - y
            let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            
            tableView.frame = frame
            tableView.backgroundColor = .white
            tableView.separatorStyle = .none
            
            tableView.delegate = self
            tableView.dataSource = self
            handleTableViewRegistration(types: [.textField, .textView, .switchType, .typical], tableView: tableView)
        }
        
    }
    
    private func setupNavigationBar(){
        
        //Identifier
        navigationController?.navigationBar.accessibilityIdentifier = "EditUser"
        
        //Bar Button Items
        let rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(handleSaveButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        let cancelBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleCancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        
        //Other
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
            self.navigationController?.isNavigationBarHidden = false
            self.navigationItem.title = "Edit User"
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.tabBarController?.tabBar.isHidden = true
        }) { (didAnimate) in
            
        }
    }
    
    private func showProfileImageActivityIndicator(){
        profileImageActivityIndicator.isHidden = false
        profileImageActivityIndicator.startAnimating()
    }
    
    private func hideProfileImageActivityIndicator(){
        self.profileImageActivityIndicator.isHidden = true
        self.profileImageActivityIndicator.stopAnimating()
    }
    
    private func setupUserProfileImageView(){
        userProfileImageView.clipsToBounds = true
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.width/2
        
        if currentUser?.profileImageURL == nil {
            hideProfileImageActivityIndicator()
            profileImageActivityIndicator.backgroundColor = .black
        }else {
            showProfileImageActivityIndicator()
        }
        
        userProfileImageView.loadImageUsingCacheWithURLString(imageURL: currentUser?.profileImageURL) { (didLoad, error) in
            if didLoad {
                
            }else {
                if let error = error {
                    //error handle
                }
                
                self.hideActivityIndicator()
                self.profileImageActivityIndicator.backgroundColor = .black
            }
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleUIImageViewTapped))
        userProfileImageView.addGestureRecognizer(tap)
        userProfileImageView.isUserInteractionEnabled = true
    }
    
    
    
    
}
*/
