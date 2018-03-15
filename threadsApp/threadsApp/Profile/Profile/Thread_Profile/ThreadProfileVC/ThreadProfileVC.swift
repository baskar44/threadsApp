//
//  ThreadProfileVC.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 23/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit
import CoreData


class ThreadProfileVC: ViewController {
    
    enum PickerType {
        case photo
        case video
        case audio
    }
    
    //MARK:- IBOutlets
    @IBOutlet weak var threadTitleLabel: UILabel!
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var threadInformationView: UIView!
    @IBOutlet weak var threadInformationViewHeight: NSLayoutConstraint!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var threadInformationEditIcon: UIButton!
  
    @IBOutlet weak var contentStateButtonTopLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var contentStateButton: UIButton!
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        return segmentedControl
    }()
    
    internal var blockOperations = [BlockOperation]()
    
    var shouldReloadCollectionView: Bool = false
    
    //MARK:- Main Variables
    private var _manager: ThreadProfileManager?
    var manager: ThreadProfileManager? {
        return _manager
    }
    
    var selectedPickerType: PickerType = .photo
    
    var editMode: Bool = false {
        didSet {
            changeToEditModeDisplay()
        }
    }
    
    var isContentMode: Bool = false {
        didSet {
            updateContentStateButtonPosition(isContentMode: isContentMode)
        }
    }
    
  

    internal var frcForInstanceMedia: NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            do {
                try frcForInstanceMedia?.performFetch()
            }catch {
                print(error)
            }
        }
    }
    
    internal var frcForInstanceBody: NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            do {
                try frcForInstanceBody?.performFetch()
            }catch {
                print(error)
            }
        }
    }
  
    func setupContentStateButton(){
        contentStateButton.layer.cornerRadius = contentStateButton.frame.width/2
        contentStateButton.addTarget(self, action: #selector(contentStateButtonTapped), for: .touchUpInside)
        updateContentStateButtonPosition(isContentMode: isContentMode)
    }
   
    
    func updateContentStateButtonPosition(isContentMode: Bool){
        if isContentMode {
            moveContentStateButtonToTop()
        }else {
            moveContentStateButtonToBottom()
            
        }
    }
    
    func moveContentStateButtonToTop(){
        collectionView.layoutIfNeeded()
        //contentStateButton.layoutIfNeeded()
        collectionViewHeightLayoutConstraint.constant = 0
        //contentStateButtonTopLayoutConstraint.constant = collectionView.frame.maxY + 16
        contentStateButtonTopLayoutConstraint.constant = 0
        //tableViewHeight.constant = collectionView.frame.maxY - contentStateButton.frame.height - 32
        tableView.isHidden = false
    }
    
    func moveContentStateButtonToBottom(){
        //tableView.layoutIfNeeded()
        collectionView.layoutIfNeeded()
        collectionViewHeightLayoutConstraint.constant = 320
        contentStateButtonTopLayoutConstraint.constant = 16 
        
        //contentStateButtonTopLayoutConstraint.constant = collectionView.frame.maxY + 16
        //tableViewHeight.constant = 0
        tableView.isHidden = true
        collectionView.reloadData()
    }
    
    let accessibilityIdenfitier = Constants.sharedInstance._ThreadProfileVC
  
    //MARK:- Initialization Related
    // this is a convenient way to create this view controller without a imageURL
    convenience init() {
        let userStructure = UserStructure(id: "Dummy", createdDate: Date(), createdDateString: "Dummy", visibility: true, username: "Dummy", fullname: "Dummy", bio: "Dummy", profileImageURL: "Dummy")
        
        let threadStructure = ThreadStructure(id: "Dummy", title: "Dummy", visibility: true, createdDate: Date(), about: "Dummy", creatorStructure: userStructure)
        
        let manager = ThreadProfileManager(selectedThreadStructure: threadStructure, employedBy: userStructure)
        self.init(manager: manager)
    }
    
    init(manager: ThreadProfileManager?) {
        _manager = manager
        super.init(nibName: Constants.sharedInstance._ThreadProfileVC, bundle: nil)
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
    
    func setupFRC(with manager: ThreadProfileManager, context: NSManagedObjectContext, completion: @escaping (Bool) -> Void ){
        manager.getThreadAccessLevel { (accessLevel) in
            if accessLevel == .full || accessLevel == .creator {
                
                self.frcForInstanceMedia = manager.getFRCForMedia(selectedSegmentIndex: self.segmentedControl.selectedSegmentIndex, context: context)
                self.frcForInstanceBody = manager.getFRCForInstanceBody(context: context)
                
                self.frcForInstanceMedia?.delegate = self
                self.frcForInstanceBody?.delegate = self
            }else {
                self.frcForInstanceMedia?.delegate = nil
                self.frcForInstanceBody?.delegate = nil
            }
            
            
            completion(true)
        }
    }
    
    //MARK:- Overriding functions...
    
    //Tested 2/20/2018
    override func setupNavigationBar(navigationBar: UINavigationBar?) -> Bool {
        guard let navigationBar = navigationBar else {
            return false
        }
        
        guard let keyWindow = UIApplication.shared.keyWindow else {
            return false
        }

        navigationBar.setup(accessibilityIdenfitier: self.accessibilityIdenfitier, backgroundColor: UIColor.white, prefersLargeTitles: false)
        
        return true
    }
    
    //Tested 2/20/2018
    override func setupNavigationItem(navigationItem: UINavigationItem?) -> Bool {
        guard let navigationItem = navigationItem else {
            return false
        }
       
        guard navigationItem.setup(title: nil) else {
            return false
        }
        
        navigationItem.titleView = segmentedControl
        
        return true
    }
    
    func performAdditionalUpdatesToNavigationItem(manager: ThreadProfileManager, navigationItem: UINavigationItem) {

        navigationItem.rightBarButtonItems = []
        
        manager.getShareState(completion: { (shareState) in
            self.navigationItem.rightBarButtonItems?.append(UIBarButtonItem(title: shareState.rawValue, style: .plain, target: self, action: #selector(self.shareStateBarButtonTapped(sender:))))
        })
        
        manager.getBookmarkState(completion: { (bookmarkState) in
            self.navigationItem.rightBarButtonItems?.append(UIBarButtonItem(title: bookmarkState.rawValue, style: .plain, target: self, action: #selector(self.bookmarkStateBarButtonTapped(sender:))))
        })
        
        if manager.isCurrentUser() {
            self.navigationItem.rightBarButtonItems?.append(UIBarButtonItem(title: Constants.sharedInstance._More, style: .plain, target: self, action: #selector(self.moreBarButtonTapped)))
           
        }
    }
    
    
 
    
    enum MoreSubAction {
        case edit
        case report
        case block
        case cancel
        case add
    }
    
    
    func getMoreSubAction(manager: ThreadProfileManager, completion: @escaping (MoreSubAction) -> Void){
        let alertController = UIAlertController(title: Constants.sharedInstance._More, message: nil, preferredStyle: .actionSheet)
        
        let reportAction = UIAlertAction(title: Constants.sharedInstance._Report, style: .default) { (alert) in
            //later
            completion(MoreSubAction.report)
            return
        }
        
        alertController.addAction(reportAction)
        
        let blockAction = UIAlertAction(title: Constants.sharedInstance._Block, style: .default) { (alert) in
            //later
            completion(MoreSubAction.block)
            return
        }
        
        alertController.addAction(blockAction)
        
        if manager.isCurrentUser() {
            let editAction = UIAlertAction(title: Constants.sharedInstance._Edit, style: .default) { (alert) in
                //later
                completion(MoreSubAction.edit)
                return
            }
            
            let addAction = UIAlertAction(title: Constants.sharedInstance._Add, style: .default, handler: { (alert) in
                completion(MoreSubAction.add)
                return
            })
            
            alertController.addAction(editAction)
            alertController.addAction(addAction)
        }
        
        let cancelAction = UIAlertAction(title: Constants.sharedInstance._Cancel, style: .cancel) { (alert) in
            completion(MoreSubAction.cancel)
            return
        }
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true) {
            //later
        }
    }
    
    func handleMoreBarButtonTapped(manager: ThreadProfileManager){
        
        getMoreSubAction(manager: manager) { (subAction) in
            switch subAction {
            case .block:
                //handle
                break
            case .cancel:
                return
            case .edit:
                self.handleEditActionSelected(manager: manager)
                break
            case .report:
                break
            case .add:
                
                let alertController = UIAlertController(title: "Choose media type", message: nil, preferredStyle: .actionSheet)
                
                let body = UIAlertAction(title: Constants.sharedInstance._Body, style: .default, handler: { (alert) in
                  
                    self.view.isUserInteractionEnabled = true
                    
                    let notepadManager = NotepadManager(mode: (false, nil), employedBy: manager.getEmployer(), workingUnder: self, selectedMedia: nil)
                    let notepadVC = NotepadVC(manager: notepadManager)
                    self.navigationController?.pushViewController(notepadVC, animated: true)
                    
                })
                
                let photo = UIAlertAction(title: Constants.sharedInstance._Photo, style: .default, handler: { (alert) in
                    self.view.isUserInteractionEnabled = true
                    
                    let picker = UIImagePickerController()
                    picker.delegate = self
                    
                    self.present(picker, animated: true, completion: {
                       //maybe later
                    })

                })
                
                let video = UIAlertAction(title: Constants.sharedInstance._Video, style: .default, handler: { (alert) in
                    self.view.isUserInteractionEnabled = true
                })
                
                let audio = UIAlertAction(title: Constants.sharedInstance._Audio, style: .default, handler: { (alert) in
                    self.view.isUserInteractionEnabled = true
                })
                
                let cancel = UIAlertAction(title: Constants.sharedInstance._Cancel, style: .cancel, handler: { (alert) in
                    self.view.isUserInteractionEnabled = true
                })
                
                alertController.addAction(body)
                alertController.addAction(photo)
                alertController.addAction(video)
                alertController.addAction(audio)
                alertController.addAction(cancel)
                
                self.present(alertController, animated: true, completion: {
                    self.view.isUserInteractionEnabled = false
                })
                
                
                break
            }
        }
    }
    
    func handleEditActionSelected(manager: ThreadProfileManager){
        retractNavigationBarButtonsForEditMode(navigationItem: navigationItem)
        editMode = true
        
    }
    
    func retractNavigationBarButtonsForEditMode(navigationItem: UINavigationItem){
        navigationItem.rightBarButtonItems = []
        let cancelEditModeBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelEditBarButtonTapped))
        navigationItem.rightBarButtonItems?.append(cancelEditModeBarButtonItem)
    }
    
    func changeToEditModeDisplay(){
        threadInformationEditIcon.isHidden = false
        tableView.setEditing(true, animated: true)
        collectionView.reloadData()
    }
    
    func changeToDefaultDisplay(){
        threadInformationEditIcon.isHidden = true
        tableView.setEditing(false, animated: true)
        collectionView.reloadData()
        
    }
    
 
    
    //Tested 2/20/2018
    override func setupNavigationController(navigationController: UINavigationController?) -> Bool {
        guard let navigationController = navigationController else {
            return false
        }
        navigationController.setup(isNavigationBarHidden: false)
        return true
    }
    
    //Tested 2/20/2018
    override func setupTableView(tableView: UITableView?) -> Bool {
        guard let tableView = tableView else {
            return false
        }
        
        
        tableView.setup(accessibilityIdentifier: accessibilityIdenfitier, delegate: self, dataSource: self, backgroundColor: UIColor.white, register: [.text])
        return true
    }
    
    //Tested 2/20/2018
    override func setupCollectionView(collectionView: UICollectionView?) -> Bool {
        guard let collectionView = collectionView else {
            return false
        }
        collectionView.setup(accessibilityIdentifier: accessibilityIdenfitier, delegate: self, dataSource: self, backgroundColor: UIColor.white, register: [.photo])
        return true
    }
    
    
    //Tested 2/20/2018
    override func setupTabBar(tabBar: UITabBar?) -> Bool {
        guard let tabBar = tabBar else {
            return false
        }
        
        tabBar.setup(accessibilityIdenfitier:accessibilityIdenfitier, isHidden: false, backgroundColor: UIColor.white)
        return true
    }
    
    //Tested 2/20/2018
    override func setupTabBarController(tabBarController: UITabBarController?) -> Bool {
        guard tabBarController != nil else {
            return false
        }
        return true
    }
    
    //MARK:- Handling Share State
    func handeShareStateButtonTapped(sender: UIBarButtonItem, manager: ThreadProfileManager){
        
        guard let senderTitle = sender.title else {
            return
        }
        
        switch senderTitle {
        case Constants.sharedInstance._Share:
            sender.title = Constants.sharedInstance._Loading
            
            manager.share(completion: { (feedback, error) in
                if feedback == .successful {
                    sender.title = Constants.sharedInstance._Shared
                }else {
                    sender.title = Constants.sharedInstance._Share
                }
                
                return
            })
        
            
        case Constants.sharedInstance._Shared:
            sender.title = Constants.sharedInstance._Loading
            
            manager.removeShare(completion: { (feedback, error) in
                if feedback == .successful {
                    sender.title = Constants.sharedInstance._Share
                }else {
                    sender.title = Constants.sharedInstance._Shared
                }
                
                return
            })
    
        case Constants.sharedInstance._Loading:
            manager.getShareState(completion: { (shareState) in
                sender.title = shareState.rawValue
                return
            })
            break
        default:
            return
        }
    }
    
    //MARK:- Handling Bookmark State
    func handeBookmarkStateButtonTapped(sender: UIBarButtonItem, manager: ThreadProfileManager){
        
        guard let senderTitle = sender.title else {
            return
        }
        
        switch senderTitle {
        case Constants.sharedInstance._Bookmark:
            sender.title = Constants.sharedInstance._Loading
            
            manager.bookmark(completion: { (feedback, error) in
                if feedback == .successful {
                    sender.title = Constants.sharedInstance._Bookmarked
                }else {
                    sender.title = Constants.sharedInstance._Bookmark
                }
                
                return
            })
            
        case Constants.sharedInstance._Bookmarked:
            sender.title = Constants.sharedInstance._Loading
            
            manager.removeBookmark(completion: { (feedback, error) in
                if feedback == .successful {
                    sender.title = Constants.sharedInstance._Bookmark
                }else {
                    sender.title = Constants.sharedInstance._Bookmarked
                }
                
                return
            })
           
        case Constants.sharedInstance._Loading:
            manager.getShareState(completion: { (shareState) in
                sender.title = shareState.rawValue
                return
            })
            break
        default:
            return
        }
    }
    
    deinit {
        for operation: BlockOperation in blockOperations {
            operation.cancel()
        }
        
        blockOperations.removeAll(keepingCapacity: false)
    }
    
    
}

//Run related...
extension ThreadProfileVC {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let context = container?.viewContext else {
            return
        }
        
        manager?.observe(.bodies, type: .added, context: context, completion: { (feedback, error) in
            if feedback == .successful {
                //todo
            }else {
                //alert
            }
        })
        
        manager?.observe(.bodies, type: .remove, context: context, completion: { (feedback, error) in
            if feedback == .successful {
                
            }
        })
        
        manager?.observe(.photos, type: .added, context: context, completion: { (feedback, error) in
            if feedback == .successful {
                
            }
        })
   
   
        manager?.observe(.photos, type: .remove, context: context, completion: { (feedback, error) in
            if feedback == .successful {
                
            }
        })
        
    }
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let failedType = runOnLoad(navigationItem: navigationItem, tableView: tableView, tabBarController: tabBarController, collectionView: collectionView)
        loadAlertController(failedType: failedType)
        setupSegmentedControl()
        
        guard let manager = _manager else {
            return
        }
        
        performAdditionalUpdatesToNavigationItem(manager: manager, navigationItem: navigationItem)
        
        setupContentStateButton()
        
        guard let context = container?.viewContext else {
            return
        }
        
        self.setupFRC(with: manager, context: context) { (didSetup) in
            if didSetup {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                 
                    
                    
                }
            }
        }
      
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let failedType = runOnAppear(tabBarController: tabBarController, navigationController: navigationController)
        loadAlertController(failedType: failedType)
       
        guard let context = container?.viewContext else {
            return
        }
        
        guard let manager = _manager else {
            return
        }
        
        Thread_.get(threadId: manager.getThreadId(), context: context) { (thread, error) in
            if let thread = thread.0 {
                guard let selectedThreadStructure = thread.createStructure() else {
                    return
                }
    
                let threadProfileManager = ThreadProfileManager(selectedThreadStructure: selectedThreadStructure, employedBy: manager.getEmployer())
                
                self.view.layoutIfNeeded()
                self._manager = threadProfileManager
                
                self.setupThreadTitleLabel(text: threadProfileManager.getThreadTitle())
                self.setupThreadAboutLabel(text: threadProfileManager.getThreadAbout())
                self.setupCreatedDateString(text: threadProfileManager.getCreatedDateString())
                self.setupThreadInformationView(manager: threadProfileManager)
              
            }
        }
    }
    
    //Selector functions
    @objc func contentStateButtonTapped(){
        isContentMode = !isContentMode
    }
    
    
    @objc private func moreBarButtonTapped(sender: UIBarButtonItem){
        
        guard let manager = manager else {
            return
        }
        
        handleMoreBarButtonTapped(manager: manager)
    }
    
    @objc private func shareStateBarButtonTapped(sender: UIBarButtonItem){
        guard let manager = manager else {
            return
        }
        
        handeShareStateButtonTapped(sender: sender, manager: manager)
    }
    
    @objc private func bookmarkStateBarButtonTapped(sender: UIBarButtonItem){
        guard let manager = manager else {
            return
        }
        handeBookmarkStateButtonTapped(sender: sender, manager: manager)
    }
    
    @objc private func handleBackButtonTapped(){
        navigationController?.navigationBar.barTintColor = nil
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func cancelEditBarButtonTapped(sender: UIBarButtonItem){
        
        guard let manager = manager else {
            return
        }
        
        editMode = false
        performAdditionalUpdatesToNavigationItem(manager: manager, navigationItem: navigationItem)
        changeToDefaultDisplay()
    }
    
    
    @objc func editThreadButtonTapped(){
        guard let manager = manager else {
            return
        }
        
        let notepadManager = NotepadManager(mode: (true, manager.getSelectedThread()), employedBy: manager.getEmployer(), workingUnder: self, selectedMedia: nil)
        let notepadVC = NotepadVC(manager: notepadManager)
        navigationController?.pushViewController(notepadVC, animated: true)
    }
    
}

