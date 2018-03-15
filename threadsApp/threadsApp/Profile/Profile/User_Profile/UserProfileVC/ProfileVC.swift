//
//  ProfileVC.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 3/12/17.
//  Copyright © 2017 Gururaj Baskaran. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class ProfileVC: ViewControllerWithFollowState {
   
    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    //Variable
    var tableViewDisplay: [[TableViewRowDisplay]] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    
    private var _manager: UserProfileManager?
    var manager: UserProfileManager? {
        return _manager
    }
    
    let accessibilityIdentifier = Constants.sharedInstance._ProfileVC
    
    //MARK:- Initialization Related
    // this is a convenient way to create this view controller without a imageURL
    convenience init() {
        let userStructure = UserStructure(id: "Dummy", createdDate: Date(), createdDateString: "Dummy", visibility: true, username: "Dummy", fullname: "Dummy", bio: "Dummy", profileImageURL: "Dummy")
        
        let manager = UserProfileManager(employedBy: userStructure, selectedUserStructure: userStructure)
        self.init(manager: manager)
    }
    
    init(manager: UserProfileManager?) {
        _manager = manager
        super.init(nibName: Constants.sharedInstance._ProfileVC, bundle: nil)
    }
    
    // if this view controller is loaded from a storyboard, imageURL will be nil
    
    /* Xcode 6
     required init(coder aDecoder: NSCoder) {
     super.init(coder: aDecoder)
     }
     */
    
    // Xcode 7 & 8
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //MARK:- Overriding Functions
    //Tested 2/20/2018
    override func setupNavigationController(navigationController: UINavigationController?) -> Bool {
        guard let navigationController = navigationController else {
            return false
        }
        
        navigationController.setup(isNavigationBarHidden: false)
        navigationController.setupBackButtonButtonItem(navigationItem: navigationItem) //belongs elsewhere?
        
        return true
    }
    
    //Tested 2/20/2018
    override func setupNavigationBar(navigationBar: UINavigationBar?) -> Bool {
        guard let navigationBar = navigationBar else {
            return false
        }
        navigationBar.setup(accessibilityIdenfitier: accessibilityIdentifier, backgroundColor: UIColor.white, prefersLargeTitles: true)
        navigationBar.barTintColor = .white
        
        return true
    }
    
    //Tested 2/20/2018
    override func setupNavigationItem(navigationItem: UINavigationItem?) -> Bool {
        guard let navigationItem = navigationItem else {
            return false
        }
        
        guard navigationItem.setup(title: manager?.selectedUserStructure.username) else {
            return false
        }
        
        return true
    }
    
    //Tested 2/20/2018
    override func setupTabBar(tabBar:UITabBar?) -> Bool {
        guard let tabBar = tabBar else {
            return false
        }
        
        let backgroundColor = UIColor.white
        
        tabBar.setup(accessibilityIdenfitier: accessibilityIdentifier, isHidden: false, backgroundColor: backgroundColor)
        
        return true
    }
    
    //Tested 2/20/2018
    override func setupTabBarController(tabBarController: UITabBarController?) -> Bool {
        guard tabBarController != nil else {
            return false
        }
        return true
    }
    
    //Tested 2/20/2018
    override func setupTableView(tableView: UITableView?) -> Bool {
        guard let tableView = tableView else {
            return false
        }
        let accessibilityIdentifier = Constants.sharedInstance._ProfileVC
        let backgroundColor = UIColor.white
        
        let register: [TableViewCellType] = [.typical, .button]
        
        tableView.setup(accessibilityIdentifier: accessibilityIdentifier, delegate: self, dataSource: self, backgroundColor: backgroundColor, register: register)
        
        return true
    }
}

extension ProfileVC {
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let failedType = runOnLoad(navigationItem: navigationItem, tableView: tableView, tabBarController: tabBarController)
        loadAlertController(failedType: failedType)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let manager = manager else {
            return
        }
        
        //1
        let failedType = runOnAppear(tabBarController: tabBarController, navigationController: navigationController)
        loadAlertController(failedType: failedType)
        
        //2
        setupHeaderView()
        setupBioLabel(manager: manager)
        setupProfileImageViewCornerRadius()
        
        //3
        setupProfileImageView(imageURL: manager.selectedUserStructure.profileImageURL) { (feedback) in
           
        }
        
        //4
        setupFollowStateSubView(manager: manager) { (result) in
             
        }
        
        //5
        manager.getUserAccessLevel { (accessLevel) in
            self.tableViewDisplay = self.getTableViewDisplay(accessLevel: accessLevel)
        }
    }
    
    //MARK: - Alert Controllers
    func loadLocalAlertController(failedType: ProfileVCFeedback){
        let alertController = UIAlertController(title: Constants.sharedInstance._Failed, message: failedType.rawValue, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: Constants.sharedInstance._Okay, style: .default) { (alert) in
            
            self.view.isUserInteractionEnabled = true
            
            alertController.dismiss(animated: true, completion: {
            })
        }
        
        alertController.addAction(okAction)
        present(alertController, animated: true) {
            self.view.isUserInteractionEnabled = false
        }
    }
    
    
    internal func loadLocalAlertController(feedback: ProfileVCFeedback?){
        guard let feedback = feedback else {
            return
        }
        
        let strings = Constants.sharedInstance
        let alertController = UIAlertController(title: strings._Failed, message: feedback.rawValue, preferredStyle: .alert)
        let closeAction = UIAlertAction(title: strings._Close, style: .cancel) { (alert) in
            self.view.isUserInteractionEnabled = true
        }
        
        alertController.addAction(closeAction)
        
        present(alertController, animated: true) {
            self.view.isUserInteractionEnabled = false
        }
    }

    //MARK:- Move later
    func setupHeaderView(){
        headerView.layer.cornerRadius = 12
    }
}
