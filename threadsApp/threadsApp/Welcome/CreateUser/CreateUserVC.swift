//
//  CreateVC.swift
//  Instance_
//
//  Created by Gururaj Baskaran on 30/10/17.
//  Copyright © 2017 Gururaj Baskaran. All rights reserved.
//

import UIKit
import Firebase

class CreateUserVC: ViewController {

    //MARK:- Weak Variables
    weak var emailTextField: UITextField!
    weak var passwordTextField: UITextField!
    weak var confirmPasswordTextField: UITextField!
    weak var usernameTextField: UITextField!
    weak var loginButton: UIButton!
    
    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottomLayoutConstraint: NSLayoutConstraint!
    
    //MARK:- Constants
    let tableViewDisplay: [[CreateUserVCRowType]] = [[.email], [.password, .confirmPassword], [.username]]
    let accessibilityIdentifier = Constants.sharedInstance._CreateUserVC
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //close
        let failedType = runOnLoad(navigationItem: navigationItem, tableView: tableView, tabBarController: tabBarController)
        loadAlertController(failedType: failedType)
        addNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let failedType = runOnAppear(tabBarController: tabBarController, navigationController: navigationController)
        loadAlertController(failedType: failedType)
    }
    
    //MARK:- Overriding Functions...
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
        
        let rightBarButtonItems: [UIBarButtonItem] = [UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(createBarButtonItemTapped))]
        
        guard navigationItem.setup(title: Constants.sharedInstance._Register, rightBarButtonItems: rightBarButtonItems) else {
            return false
        }
        
        return true
    }
    
    
    @objc private func cancelBarButtonItemTapped(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func createBarButtonItemTapped(){
        let strings = Constants.sharedInstance
        let registerAssistant = RegisterAssistant(email: emailTextField, username: usernameTextField, password: passwordTextField, confirmPassword: confirmPasswordTextField, strings: strings)
        
        registerAssistant.register { (failedType) in
            guard let failedType = failedType else {
                self.navigationController?.popToRootViewController(animated: true)
                return
            }
            
            self.loadLocalAlertController(failedType: failedType)
        }
    }
    
    //Tested 2/19/2018
    override func setupNavigationBar(navigationBar: UINavigationBar?) -> Bool {
        guard let navigationBar = navigationBar else {
            return false
        }
        
        navigationBar.setup(accessibilityIdenfitier: accessibilityIdentifier, backgroundColor: UIColor.white, prefersLargeTitles: true)
        
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
    
    //Tested 2/19/2018
    override func setupTabBar(tabBar:UITabBar?) -> Bool {
        if tabBar == nil  {
            return true
        }else {
            return false
        }
    }
    
    //Tested 2/19/2018.
    override func setupTableView(tableView: UITableView?) -> Bool {
        guard let tableView = tableView else {
            return false
        }
        
        let register: [TableViewCellType] = [.textField, .typical]
        tableView.setup(accessibilityIdentifier: accessibilityIdentifier, delegate: self, dataSource: self, backgroundColor: UIColor.white, register: register)
        
        return true
    }
    
    //Tested 2/20/2018.
    override func setupCollectionView(collectionView: UICollectionView?) -> Bool {
        
        guard collectionView == nil else {
            return false
        }
        
        
        return true
    }
    
    ///Function adds the required observers in the notifcation center.
    private func addNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableView), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    ///Function updates table view bottom layout constraint.
    @objc private func updateTableView(notifcation: Notification) {
        if let info = notifcation.userInfo {
            if let keyboardEndFrameCoordinates = info[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let rectVal = keyboardEndFrameCoordinates.cgRectValue
                let keyboardEndFrame = self.view.convert(rectVal, to: view.window)
                tableViewBottomLayoutConstraint.constant = -keyboardEndFrame.height
            }
        }
    }
    
    internal func loadLocalAlertController(failedType: CreateUserFailedType?){
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


