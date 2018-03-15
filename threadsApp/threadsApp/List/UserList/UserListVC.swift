//
//  UserVC.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 22/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit
import CoreData

class UserListVC: ViewControllerWithFollowState {
    
    //IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userInformationView: UIView!
    @IBOutlet weak var userInformationHeightConstraint: NSLayoutConstraint!
    
    
    private var _manager: UserListManager?
    var manager: UserListManager? {
        return _manager
    }
    
    let accessibilityIdentifier = Constants.sharedInstance._UserListVC
    
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        return segmentedControl
    }()
    
    var frc: NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            do {
                try frc?.performFetch()
            }catch {
                print(error)
            }
        }
    }
    
    //MARK:- Initialization Related
    // this is a convenient way to create this view controller without a imageURL
    convenience init() {
        let userStructure = UserStructure(id: "Dummy", createdDate: Date(), createdDateString: "Dummy", visibility: true, username: "Dummy", fullname: "Dummy", bio: "Dummy", profileImageURL: "Dummy")
        
        
        let manager = UserListManager(.createdThreads, employedBy: userStructure, selectedUserStructure: userStructure, context: ThreadsData.sharedInstance.container?.viewContext)

        self.init(manager: manager)
    }
    
    init(manager: UserListManager?) {
        _manager = manager
        super.init(nibName: Constants.sharedInstance._UserListVC, bundle: nil)
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
       
        let failedType = runOnAppear(tabBarController: tabBarController, navigationController: navigationController)
        loadAlertController(failedType: failedType)
        
        guard performAdditionalUpdatesToNavigationItem(navigationItem: navigationItem, manager: manager) else {
            return //error handle
        }
        
        guard setupSegmentControl(listType: manager.listType) else {
            return // error handle
        }
        
        setupUserInformationView()
      
        let feedback = self.fetchFRC(manager: manager)
    }
    
    //MARK:- Overriding Functions related to Table View
    override func setupTableView(tableView: UITableView?) -> Bool {
        guard let tableView = tableView else {
            return false
        }
        
        let register: [TableViewCellType] = [.user, .thread, .threadFeed, .threadBody, .threadPhoto, .typical]
        
        tableView.setup(accessibilityIdentifier: accessibilityIdentifier, delegate: self, dataSource: self, backgroundColor: UIColor.white, register: register)
        
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        return true
    }
    
    override func setupCollectionView(collectionView: UICollectionView?) -> Bool {
        guard collectionView == nil else {
            return false
        }
        return true
    }
    
    //MARK:- Overriding functions related to Navigation
    override func setupNavigationBar(navigationBar: UINavigationBar?) -> Bool {
        guard let navigationBar = navigationBar else {
            return false
        }
        navigationBar.setup(accessibilityIdenfitier: accessibilityIdentifier, backgroundColor: UIColor.white, prefersLargeTitles: true)
        navigationBar.barTintColor = .white
        return true
    }
    
    override func setupNavigationItem(navigationItem: UINavigationItem?) -> Bool {
        guard let navigationItem = navigationItem else {
            return false
        }
        
        guard navigationItem.setup(title: manager?.listType.rawValue) else {
            return false
        }
        return true
    }
    
    internal func performAdditionalUpdatesToNavigationItem(navigationItem: UINavigationItem?, manager: UserListManager) -> Bool {
        guard let navigationItem = navigationItem else {
            return false
        }
        
        var rightBarButtonItems: [UIBarButtonItem] = []
        if manager.employedBy.id == manager.selectedUserStructure.id {
            if manager.listType == .createdThreads {
                rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddButtonTapped))]
            }else if manager.listType == .followers {
                rightBarButtonItems = [UIBarButtonItem(title: Constants.sharedInstance._Pending, style: .plain, target: self, action: #selector(handlePendingButtonTapped))]
            }else if manager.listType == .following {
                rightBarButtonItems = [UIBarButtonItem(title: Constants.sharedInstance._Requested, style: .plain, target: self, action: #selector(handleRequestedButtonTapped))]
            }
        }
        
        navigationItem.rightBarButtonItems = rightBarButtonItems
        
        return true
    }
    
    @objc func handleRequestedButtonTapped(){
        
        guard let manager = manager else {
            return
        }
        
        let listManagerWithFeedback = ThreadsData.sharedInstance.getUserListManager(selectedUserStruture: manager.employedBy, employedBy: manager.employedBy, listType: .requested)
        
        if let listManager = listManagerWithFeedback.0 {
            
            listManager.observe(action: .add, toFirst: 10, completion: { (feedback, error) in
                print(feedback)
                let userListVC = UserListVC(manager: listManager)
                self.navigationController?.pushViewController(userListVC, animated: true)
            })
            
            listManager.observe(action: .remove, toFirst: nil, completion: { (feedback, error) in
              
            })
            
        }else {
           //error handle
        }
    }
    
    @objc func handlePendingButtonTapped(){
        guard let manager = manager else {
            return
        }
        
        let listManagerWithFeedback = ThreadsData.sharedInstance.getUserListManager(selectedUserStruture: manager.employedBy, employedBy: manager.employedBy, listType: .pending)
        
        if let listManager = listManagerWithFeedback.0 {
            
            listManager.observe(action: .add, toFirst: 1, completion: { (feedback, error) in
                print(feedback)
                
                //remove
                guard let context = self.container?.viewContext else {
                    return
                }
                
                User.get(userId: listManager.selectedUserStructure.id, context: context, strings: Constants.sharedInstance, completion: { (user, error) in
                    if let user = user.0 {
                  
                        let userListVC = UserListVC(manager: listManager)
                        self.navigationController?.pushViewController(userListVC, animated: true)
                    }
                })
                
             
            })
            
            listManager.observe(action: .remove, toFirst: nil, completion: { (feedback, error) in
               
            })
            
        }else {
            //error handle
        }
    }
    
    override func setupNavigationController(navigationController: UINavigationController?) -> Bool {
        
        guard let navigationController = navigationController else {
            return false
        }
        navigationController.setup(isNavigationBarHidden: false)
        return true
    }
    
    override func setupTabBarController(tabBarController: UITabBarController?) -> Bool {
        guard tabBarController != nil else {
            return false
        }
        return true
    }
    
    override func setupTabBar(tabBar: UITabBar?) -> Bool {
        guard let tabBar = tabBar else {
            return false
        }
        
        let strings = Constants.sharedInstance
        let accessibilityIdentifier = strings._UserListVC
        let backgroundColor = UIColor.white
        
        tabBar.setup(accessibilityIdenfitier: accessibilityIdentifier, isHidden: false, backgroundColor: backgroundColor)
        
        return true
    }
    
    @objc func handleAddButtonTapped(){
        guard let employedBy = self.manager?.employedBy else {
            return
        }
        let manager = NotepadManager(mode: (false, nil), employedBy: employedBy, workingUnder: self, selectedMedia: nil)
        let notepadVC = NotepadVC(manager: manager)
        navigationController?.pushViewController(notepadVC, animated: true)
    }
    
    //MARK:- Alert Controllers
  
    
    //MARK:- Move later
    func setupUserInformationView(){
        userInformationView.layer.cornerRadius = 12
        usernameLabel.text = manager?.selectedUserStructure.username
        fullnameLabel.text = manager?.selectedUserStructure.fullname
        profileImageView.loadImageUsingCacheWithURLString(imageURL: manager?.selectedUserStructure.profileImageURL) { (didLoad, error) in
            //later
        }
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        
        let constant = fullnameLabel.frame.maxY + 16
        userInformationView.layoutIfNeeded()
        
        if constant < 90 {
            userInformationHeightConstraint.constant = 90
        }else {
            userInformationHeightConstraint.constant = constant
        }
        
    }
    
}

extension UserListVC: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.navigationBar.barTintColor = nil
    }
}



