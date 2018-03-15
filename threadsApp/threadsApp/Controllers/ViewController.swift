//
//  ViewController.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 1/11/17.
//  Copyright © 2017 Gururaj Baskaran. All rights reserved.
//

import CoreData
import Firebase
import UIKit

class ViewController: UIViewController {
    
    ///Function sets up navigation controller and table view, while also ensuring that no tab bar controller exists. The function has returns a failed type if any of the setups fail.
    /// - Parameter navigationController: The existing UINavigationController
    /// - Parameter tableView: The existing UITableView
    /// - Parameter tabBarController: The existing UITabBarController
    
    internal enum FailedType: String {
        case failedToRetrieveCurrentUserStructure = "Failed to retrieve current object."
        case failedToRetrieveSelectedObjectStructure = "Failed to retrieve selected object."
        case failedWhileLoadingTableViewDisplay = "Failed to load table view information"
        case failedWhileLoadingNavigationController = "Failed during setupNavigationController(navigationController:)"
        case failedWhileLoadingTabBarController = "Failed during setupTabBarController(tabBarController:)"
        case failedWhileLoadingTableView = "Failed during setupTableView(tableView:)"
        case failedWhileLoadingAccessLevel = "Failed to get access level"
        case failedWhileLoadingNavigationBar = "Failed during setupNavigationBar(navigationBar:)"
        case failedWhileLoadingNavigationItem = "Failed during setupNavigationItem(navigationItem:)"
        case failedWhileLoadingTabBar = "Failed during setupTabBar(tabBar:)"
        case failedWhileLoadingCollectionView = "Failed during setupCollectionView()"
        case blockExists = "Block exists."
    }
    
    enum UserAccessLevel {
        case current
        case full
        case noAccess
        case blocked
        case failed
    }
    
    func shouldProceedWithWithdraw(completion: @escaping (Bool) -> Void){
        let alertController = UIAlertController(title: Constants.sharedInstance._Warning, message: "Are you sure you want to withdraw request to user?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: Constants.sharedInstance._Cancel, style: .cancel) { (alert) in
            self.view.isUserInteractionEnabled = true
            completion(false)
        }
        
        let yesAction = UIAlertAction(title: Constants.sharedInstance._Yes, style: .default) { (alert) in
            self.view.isUserInteractionEnabled = true
            completion(true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        
        present(alertController, animated: true) {
            self.view.isUserInteractionEnabled = false
        }
    }
    
    
    func shouldProceedWithUnFollow(completion: @escaping (Bool) -> Void){
        let alertController = UIAlertController(title: Constants.sharedInstance._Warning, message: "Are you sure you want to un follow user?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: Constants.sharedInstance._Cancel, style: .cancel) { (alert) in
            self.view.isUserInteractionEnabled = true
            completion(false)
        }
        
        let yesAction = UIAlertAction(title: Constants.sharedInstance._Yes, style: .default) { (alert) in
            self.view.isUserInteractionEnabled = true
            completion(true)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        
        present(alertController, animated: true) {
            self.view.isUserInteractionEnabled = false
        }
    }
    
    enum Result {
        case cancel
        case yes
        case no
    }
    
    func shouldProceedWithPending(completion: @escaping (Result) -> Void){
        let alertController = UIAlertController(title: Constants.sharedInstance._Warning, message: "Make a decision. Allow user to follow you?", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: Constants.sharedInstance._Cancel, style: .cancel) { (alert) in
            self.view.isUserInteractionEnabled = true
            completion(.cancel)
        }
        
        let yesAction = UIAlertAction(title: Constants.sharedInstance._Yes, style: .default) { (alert) in
            self.view.isUserInteractionEnabled = true
            completion(.yes)
        }
        
        let noAction = UIAlertAction(title: Constants.sharedInstance._No, style: .default) { (alert) in
            self.view.isUserInteractionEnabled = true
            completion(.no)
        }
        
        
        alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        present(alertController, animated: true) {
            self.view.isUserInteractionEnabled = false
        }
    }
   //start here
    func handleFollowState(senderTitle: String, manager: UserProfileManager, completion: @escaping (Feedback, UserStructure.FollowState) -> Void){
        switch senderTitle {
        case Constants.sharedInstance._Follow:
            
            manager.initiateFollow(completion: { (feedback, followState) in
                completion(feedback, followState)
                return
            })

            
        case Constants.sharedInstance._Following:
            //ask if user wants to un follow
            shouldProceedWithUnFollow(completion: { (shouldProceed) in
                if shouldProceed {
                    manager.initiateUnFollow(completion: { (feedback, followState) in
                        completion(feedback, followState)
                        return
                    })
                }
            })
            break
        case Constants.sharedInstance._Requested:
            //ask if user wants to withdraw request
            shouldProceedWithWithdraw(completion: { (shouldProceed) in
                if shouldProceed {
                    manager.initiateWithdrawRequest(completion: { (feedback, followState) in
                        completion(feedback, followState)
                        return
                    })
                }
            })
            break
        case Constants.sharedInstance._Pending:
            //ask if user wants to cancel pending
            shouldProceedWithPending(completion: { (result) in
                switch result {
                case .cancel:
                    completion(.cancelled, .pending)
                    break
                case .no:
                    manager.initiateCancelPending(completion: { (feedback, followState) in
                        completion(feedback, followState)
                        return
                    })
                    break
                case .yes:
                    manager.initiateAcceptPending(completion: { (feedback, followState) in
                        completion(feedback, followState)
                        return
                    })
                    break
                }
            })
            break
        case Constants.sharedInstance._Loading:
            manager.getFollowState(completion: { (followState) in
                completion(.successful, followState)
                return
            })
            break
        case Constants.sharedInstance._Current:
            manager.getFollowState(completion: { (followState) in
                completion(.successful, followState)
                return
            })
            break
        default:
            return
        }
    }
    
    func loadAlertController(failedType: ViewController.FailedType?){
        
        guard let failedType = failedType else {
            return
        }
        
        let strings = Constants.sharedInstance
        
        let alertController = UIAlertController(title: strings._Failed, message: failedType.rawValue, preferredStyle: .alert)
        
        let closeAction = UIAlertAction(title: strings._Close, style: .default) { (alert) in
            
            self.dismiss(animated: true, completion: {
                //maybe later
            })
        }
        
        alertController.addAction(closeAction)
        
        if self is WelcomeVC && (failedType == .failedWhileLoadingTableView || failedType == .failedWhileLoadingTabBarController) {
            return
        }
        
        if (self is LoginVC || self is CreateUserVC) && (failedType == .failedWhileLoadingTabBarController) {
            return
        }
        
        present(alertController, animated: true) {
            self.view.isUserInteractionEnabled = false
        }
    }
    
    ///Function setups up the navigation controller.
    func setupNavigationController(navigationController: UINavigationController?) -> Bool {
        
        if navigationController == nil {
            return false
        }else {
            return true
        }
    }
    
    func setupNavigationItem(navigationItem: UINavigationItem?) -> Bool {
        if navigationItem == nil {
            return false
        }else {
            return true
        }
    }
    
    func setupNavigationBar(navigationBar: UINavigationBar?) -> Bool {
        if navigationBar == nil {
            return false
        }else {
            return true
        }
    }
    
    
    ///Function setups up the table view.
    func setupTableView(tableView: UITableView?) -> Bool {
        if tableView == nil {
            return true
        }else {
            return false
        }
    }
    
    //Function sets up collection view.
    func setupCollectionView(collectionView: UICollectionView?) -> Bool {
     
        if collectionView == nil {
            return true
        }else {
            
            
            return false
        }
    }
    
    ///Function setups up the tab bar controller.
    func setupTabBarController(tabBarController: UITabBarController?) -> Bool {
        if tabBarController == nil {
            return false
        }else {
            return true
        }
    }
    
    
    func setupTabBar(tabBar: UITabBar?) -> Bool {
        if tabBar == nil {
            return false
        }else {
            return true
        }
    }
    
    //MARK:- View Life Cycle
    internal func runOnAppear(tabBarController: UITabBarController?, navigationController: UINavigationController?) -> ViewController.FailedType? {
        
        guard setupTabBar(tabBar: tabBarController?.tabBar) else {
            //error handle: Failed during setupTabBar(tabBar:)
            return .failedWhileLoadingTabBar
        }
        
        guard setupNavigationController(navigationController: navigationController) else {
            //error handle: Failed during setupNavigationController(navigationController:)
            return .failedWhileLoadingNavigationController
        }
        
        guard setupNavigationBar(navigationBar: navigationController?.navigationBar) else {
            //error handle: Failed during setupNavigationBar(navigationBar:)
            return .failedWhileLoadingNavigationBar
        }
        
        return nil
    }
    
    internal func runOnLoad(navigationItem: UINavigationItem?, tableView: UITableView? = nil, tabBarController: UITabBarController?, collectionView: UICollectionView? = nil) -> ViewController.FailedType? {
        
        guard setupNavigationItem(navigationItem: navigationItem) else {
            //error handle: Failed during setupNavigationItem(navigationItem:)
            return .failedWhileLoadingNavigationItem
        }
        
        guard setupTableView(tableView: tableView) else {
            //error handle: Failed during setupTableView(tableView:)
            return .failedWhileLoadingTableView
        }
        
        guard setupTabBarController(tabBarController: tabBarController) else {
            //error handle: Failed during setupTabBarController(tabBarController:)
            return .failedWhileLoadingTabBarController
        }
        
        guard setupCollectionView(collectionView: collectionView) else {
            //error handle: Failed during setupTabBarController(tabBarController:)
            return .failedWhileLoadingCollectionView
        }
        
        return nil
    }
    
    enum ViewState {
        case open
        case closed
    }
    
    
    var userAccess: UserAccess?
    
    let s_ = Constants.sharedInstance
    let keyWindow = UIApplication.shared.keyWindow
    
    //MARK:- CoreData Related Variables:
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer 
    
    
    func toggle(curtainView: UIView, to viewState: ViewState) -> Bool {
        
        guard let keyWindow = keyWindow else {
            return false
        }
        
        if viewState == .open {
            curtainView.isHidden = false
            curtainView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: keyWindow.frame.height)
        }else if viewState == .closed {
            
            curtainView.isHidden = true
            curtainView.frame = CGRect(x: keyWindow.frame.width, y: 0, width: 0, height: keyWindow.frame.height)
        }
        
        return true
    }
    
    
    func toggle(activityIndicatorView: UIActivityIndicatorView, to viewState:ViewState) -> Bool {
       
        if viewState == .open {
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
        }else if viewState == .closed {
            activityIndicatorView.isHidden = true
            activityIndicatorView.stopAnimating()
        }
        
        return true
    }
}


