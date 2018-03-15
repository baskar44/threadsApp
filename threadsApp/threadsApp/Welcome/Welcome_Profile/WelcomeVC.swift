//
//  WelcomeVC.swift
//  Instance_
//
//  Created by Gururaj Baskaran on 30/10/17.
//  Copyright © 2017 Gururaj Baskaran. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class WelcomeVC: ViewController {
    
    enum WelcomeVCFeedback {
        case failedToGetAuthenticationAssistant
        case failedToLaunchIntoLoginVC
        case failedToLoadHandleWithErr
        case failedToloadHandleWithoutErr
        case failedInitialCleanUp
    }
   
    //MARK: Private Variables
    private var userLoggedIn: Bool = false
    private var authAssistant: AuthenticationAssistantProtocol? {
        didSet {
            didSetAuthenticationAssistantProtocol(authAssistant: authAssistant) { (feedback, user, error) in
                if let user = user {
                    self.currentUserStructure = user.createStructure()
                }
            }
        }
    }
    
    //MARK: Constants
    let accessibilityIdenfitier = Constants.sharedInstance._WelcomeVC
    
    //MARK: Overriding Variables
    var currentUserStructure: UserStructure? {
        didSet {
            guard didSetCurrentUser(currentUserStructure: currentUserStructure) else {
                //error handle
                return
            }
        }
    }
    
    //MARK: View Life Cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let failedType = runOnAppear(tabBarController: tabBarController, navigationController: navigationController)
        loadAlertController(failedType: failedType)
    }
    
    //View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let failedType = runOnLoad(navigationItem: navigationItem, tableView: nil, tabBarController: tabBarController)
        loadAlertController(failedType: failedType)
        
        let clearAssistant = ClearAssistant(objectTypes: [.audio, .video, .photo, .thread, .user, .body, .feedItem, .journalItem], container: container)
        
        getAuthenticationAssistant(clearAssistant: clearAssistant) { (assistant) in
            guard let authAssistant = assistant  else {
                return
            }
            
            self.authAssistant = authAssistant
        }
    }
    
    //Functions related to Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.sharedInstance._launchUserIntoApp, let currentUserStructure = sender as? UserStructure? {
            
            guard let destination = segue.destination as? MainTabBarController else{
                return
            }
            destination.currentUserStructure = currentUserStructure
        }
    }
    
    //MARK: Overriding Functions
    //Tested 2/19/2018
    override func setupNavigationController(navigationController: UINavigationController?) -> Bool {
        guard let navigationController = navigationController else {
            return false
        }
        
        navigationController.setup(isNavigationBarHidden: true)
        return true
    }
    
    //Tested 2/19/2018
    override func setupNavigationBar(navigationBar: UINavigationBar?) -> Bool {
        guard let navigationBar = navigationBar else {
            return false
        }
        navigationBar.setup(accessibilityIdenfitier: accessibilityIdenfitier, backgroundColor: UIColor.white, prefersLargeTitles: true)
        return true
    }
    
    //Tested 2/19/2018
    override func setupNavigationItem(navigationItem: UINavigationItem?) -> Bool {
        guard let navigationItem = navigationItem else {
            return false
        }
        
        guard navigationItem.setup(title: Constants.sharedInstance._threads, leftBarButtonItems: []) else {
            return false
        }
        
        return true
    }
    
    //Tested 2/19/2018
    override func setupTableView(tableView: UITableView?) -> Bool {
        guard tableView == nil else {
            return false
        }
        return true
    }
    
    //Tested 2/19/2018
    override func setupTabBar(tabBar: UITabBar?) -> Bool {
        guard tabBar == nil else {
            return false
        }
        return true
    }
    
    //Tested 2/19/2018
    override func setupTabBarController(tabBarController: UITabBarController?) -> Bool {
        guard tabBarController == nil else {
            return false
        }
        return true
    }
    
    //Functions and Enum related to clearing CoreData
    //Testable? - Mock a clear() function by mocking the VC?
    ///Function clears all objects inside the given container.
    //clear objects here
    
    //Tested on 2/19/2018
    internal func getAuthenticationAssistant(clearAssistant: ClearAssistantProtocol, completion: @escaping (AuthenticationAssistantProtocol?) -> Void) {
        
        clearAssistant.clear { (feedback) in
            if feedback == .clearCompleted {
                let assistant = AuthenticationAssistant()
                completion(assistant)
            }else {
                completion(nil)
            }
            
            return
        }
    }
    
    //Private functions
    //Tested on 2/19/2018
    /// Function is triggered when the var currentUserStructure is set. The function perform a segue, taking the active user into the application. The function returns false, if the currentUserStructure is nil.
    internal func didSetCurrentUser(currentUserStructure: UserStructure?) -> Bool {
        
        guard let currentUserStructure = currentUserStructure else {
            return false
        }
        
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: Constants.sharedInstance._launchUserIntoApp, sender: currentUserStructure)
        }
        
        return true
    }
    
    //Tested on 2/19/2018
    /// Function launches user into LoginVC. Returns false is navigationController nil.
    internal func launchLoginVC(navigationController: UINavigationController?) -> Bool {
        
        guard let navigationController = navigationController else {
            return false
        }
        
        let nibName = Constants.sharedInstance._LoginVC
        let loginVC = LoginVC(nibName: nibName, bundle: nil)
        navigationController.pushViewController(loginVC, animated: true)
        
        return true
    }
    
    
    //Testing...?
    func didSetAuthenticationAssistantProtocol(authAssistant: AuthenticationAssistantProtocol?, completion: @escaping (WelcomeVCFeedback?, User?, Error?) -> Void){
        
        authAssistant?.setupHandle(completion: { (feedback, user, error) in
            if feedback == .foundActiveUser {
                if let user = user {
                    
                    completion(nil, user, error)
                    return
                }
                
            }else if feedback == .noActiveUser {
                guard self.launchLoginVC(navigationController: self.navigationController) else {
                    completion(.failedToLaunchIntoLoginVC, nil, nil)
                    return
                }
                
            }else {
                
                if let error = error {
                    completion(.failedToLoadHandleWithErr, nil, error)
                }else {
                    completion(.failedToloadHandleWithoutErr, nil, nil)
                }
                return
            }
        })
    }
}






