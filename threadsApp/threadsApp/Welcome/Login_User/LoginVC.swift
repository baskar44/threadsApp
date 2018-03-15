//
//  LoginVC.swift
//  Instance_
//
//  Created by Gururaj Baskaran on 30/10/17.
//  Copyright © 2017 Gururaj Baskaran. All rights reserved.
//

import UIKit
import Firebase
import CoreData

//This view controller has three functioning parts to it.
//1) The user tries to log in
//2) The user wants to register
//3) The user forgot his/her password.

class LoginVC: ViewController {
    
    //Internal Enumerations
    internal enum LoginVCRowDisplay {
        case email
        case password
        case loginButton
    }

    internal enum LoginVCFailedType: String {
        case featureNotAvail = "Feature not available currently."
        case invalidUserCredentials = "Invalid User Credentials"
        case requiredFieldsIncomplete = "Required fields are incomplete"
        case loginFailedWithError = "Login in failed due to with error"
        case loginFailedWithoutError = "Login in failed due to with unknown error"
        case requiredFieldsDoesNotExist = "Required text fields do not exist."
    }
    
    //MARK:- IBOutlets:
    @IBOutlet weak var tableView: UITableView!
    
    let tableViewDisplay: [[LoginVCRowDisplay]] = [[.email, .password], [.loginButton]]
    
    //MARK:- Weak Variables:
    weak var emailTextField: UITextField!
    weak var passwordTextField: UITextField!
    
    //MARK:- Constants
    let accessibilityIdenfitier = Constants.sharedInstance._LoginVC
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let failedType = runOnLoad(navigationItem: navigationItem, tableView: tableView, tabBarController: tabBarController)
        loadAlertController(failedType: failedType)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let failedType = runOnAppear(tabBarController: tabBarController, navigationController: navigationController)
        loadAlertController(failedType: failedType)
    }
  
    //MARK:- Overriding functions...
    //Tested 2/19/2018
    override func setupTabBar(tabBar: UITabBar?) -> Bool {
        if tabBar == nil {
            return true
        }else {
           return false
        }
    }
    
    //Tested 2/19/2018
    override func setupTableView(tableView: UITableView?) -> Bool {
        guard let tableView = tableView else {
            return false
        }
        
        let strings = Constants.sharedInstance
        let accessibilityIdenfitier = strings._LoginVC
        let backgroundColor = UIColor.white
        
         tableView.setup(accessibilityIdentifier: accessibilityIdenfitier, delegate: self, dataSource: self, backgroundColor: backgroundColor, register: [.textField, .button])
        
        return true
    }
    
    //Tested 2/19/2018
    override func setupNavigationController(navigationController: UINavigationController?) -> Bool {
        
        guard let navigationController = navigationController else {
            return false
        }
        
        navigationController.setup(isNavigationBarHidden: false)
        
        return true
    }
    
    //Tested 2/19/2018
    override func setupNavigationItem(navigationItem: UINavigationItem?) -> Bool {
        guard let navigationItem = navigationItem else {
            return false
        }
        
        let strings = Constants.sharedInstance
        
        let rightBarButtonItems = [UIBarButtonItem(title: strings._Forgot_Password, style: .plain, target: self, action: #selector(self.forgotPasswordBarButtonItemTapped))]
        
        let leftBarButtonItems = [UIBarButtonItem(title: strings._Register, style: .plain, target: self, action: #selector(self.registerBarButtonItemTapped))]

        guard navigationItem.setup(title: strings._Login, rightBarButtonItems: rightBarButtonItems, leftBarButtonItems: leftBarButtonItems) else {
            return false
        }
        return true
    }
    
    
    /// Function is triggered when 'Forgot Password' is called.
    @objc private func forgotPasswordBarButtonItemTapped(){
        loadLocalAlertController(failedType: .featureNotAvail)
    }
    
    /// Function is triggered when 'Register' is called.
    @objc private func registerBarButtonItemTapped(){
        navigationController?.isNavigationBarHidden = true
        let createUserVC = CreateUserVC(nibName: Constants.sharedInstance._CreateUserVC, bundle: nil)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.pushViewController(createUserVC, animated: true)
    }
    
    //Tested 2/19/2018
    override func setupNavigationBar(navigationBar: UINavigationBar?) -> Bool {
        guard let navigationBar = navigationBar else {
            return false
        }
        navigationBar.setup(accessibilityIdenfitier: accessibilityIdenfitier,backgroundColor: UIColor.white, prefersLargeTitles: true)
        return true
    }
    
    //Tested 2/19/2018
    override func setupTabBarController(tabBarController: UITabBarController?) -> Bool {
        if tabBarController == nil {
            return true
        }else {
            return false
        }
    }
    
    internal func loadLocalAlertController(failedType: LoginVCFailedType?){
        guard let failedType = failedType else {
            return
        }
        
        let strings = Constants.sharedInstance
        
        let alertController = UIAlertController(title: strings._Failed, message: failedType.rawValue, preferredStyle: .alert)
        
        let closeAction = UIAlertAction(title: strings._Close, style: .cancel) { (alert) in
            self.view.isUserInteractionEnabled = true
        }
        
        alertController.addAction(closeAction)
        
        present(alertController, animated: true) {
            self.view.isUserInteractionEnabled = false
        }
    }
}



