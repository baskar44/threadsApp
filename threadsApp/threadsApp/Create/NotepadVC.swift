//
//  CreateThreadVC.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 25/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

//completed 26/2/2018

import UIKit
import Firebase

//NotepadVC is of type ViewController
//NotepadVC is used when the user wants to edit/create a new thread/instance/body
//The user will initialise the vc by inputing, the type of media represented (NotepadVCType), edit mode (Bool) , the data udpater (DataUpdaterProtocol), initial title and body.


class NotepadVC: ViewController {

    typealias NotepadMode = (Bool, MediaStructureProtocol?)
    
    //MARK:- IBOutlets
    @IBOutlet weak var titleLengthWordCount: UILabel!
    @IBOutlet weak var bodyLengthWordCount: UILabel!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var mediaDisplayImageView: UIImageView!
    @IBOutlet weak var titleTextViewAndSubHeadings: UITextView!
    
    //MARK:- Constants
    let accessibilityIdenfitier = Constants.sharedInstance._CreateThreadVC
    
    //MARK:- Initialized Variables
    private var manager: NotepadManager?
    
    //MARK:- Local Private Variables
    private var isVisible: Bool = true
    
    //MARK:- Initialization Related
    // this is a convenient way to create this view controller without a imageURL
    convenience init() {
        let strings = Constants.sharedInstance
        let userStructure = UserStructure(id: strings._id, createdDate: Date(), createdDateString: strings._createdDate, visibility: false, username: strings._username, fullname: strings._fullname, bio: strings._bio, profileImageURL: strings._profileImageURL)
        
        let mediaStructure = ThreadStructure(id: strings._id, title: strings._title, visibility: false, createdDate: Date(), about: strings._about, creatorStructure: userStructure)
        
        let mode: NotepadMode = (false, mediaStructure)
        let manager = NotepadManager(mode: mode, employedBy: userStructure, workingUnder: UserListVC(), selectedMedia: nil)
        
        self.init(manager: manager)
    }
    
    init(manager: NotepadManager?) {
        self.manager = manager
        super.init(nibName: Constants.sharedInstance._NotepadVC, bundle: nil)
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
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let manager = manager else {
            return
        }
        
        addNotifications()
        
        let failedType = runOnLoad(navigationItem: navigationItem, tabBarController: tabBarController)
        loadAlertController(failedType: failedType)
        performAdditionalUpdatesToNavigationItem(manager: manager, navigationItem: navigationItem)
        
        setup(titleTextView, with: manager)
        setup(bodyTextView, with: manager)
        setupNotepadVC(with: manager)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //1
        let failedType = runOnAppear(tabBarController: tabBarController, navigationController: navigationController)
        loadAlertController(failedType: failedType)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func setup(_ textView: UITextView, with manager: NotepadManager){
        textView.delegate = self
        if textView == titleTextView {
            textView.text = manager.initialTitle
        }else if textView == bodyTextView {
            textView.text = manager.initialContent
        }else {
            //error handle
        }
        
        setupWordCountLabel(textView, with: manager)
    }
    
    //MARK:- Setting up Navigation Controller and Related
    override func setupNavigationController(navigationController: UINavigationController?) -> Bool {
        guard let navigationController = navigationController else {
            //error handle
            return false
        }
        navigationController.setup(isNavigationBarHidden: false)
        return true
    }
    
    override func setupNavigationBar(navigationBar: UINavigationBar?) -> Bool {
        guard let navigationBar = navigationBar else {
            return false
        }
        navigationBar.setup(accessibilityIdenfitier: accessibilityIdenfitier, backgroundColor: UIColor.white, prefersLargeTitles: false)
        return true
    }
    
    override func setupNavigationItem(navigationItem: UINavigationItem?) -> Bool {
        guard let navigationItem = navigationItem else {
            return false
        }
        guard navigationItem.setup(title: nil) else {
            return false
        }
        return true
    }
    
    func performAdditionalUpdatesToNavigationItem(manager: NotepadManager, navigationItem: UINavigationItem) {
        var rightBarButtonItems: [UIBarButtonItem] = []
        if manager.mode.0 { //if edit mode
            rightBarButtonItems.append(UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(trashBarButtonTapped)))
        }
        
        rightBarButtonItems.append(UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBarButtonTapped)))
        
        var visibilityState = Constants.sharedInstance._Public
        
        if manager.mode.0 {
            if let item = manager.mode.1 {
                if !(item.visibility) {
                    visibilityState = Constants.sharedInstance._Private
                }
            }
        }
        
        
        rightBarButtonItems.append(UIBarButtonItem(title: visibilityState, style: .plain, target: self, action: #selector(visibilityStateBarButtonTapped)))
        navigationItem.rightBarButtonItems = rightBarButtonItems
    }
    
    @objc func handleBackBarButtonTapped(){
      
    }
    
    //MARK:- Overriding Table View related
    override func setupTableView(tableView: UITableView?) -> Bool {
        guard tableView == nil else {
            return false
        }
        return true
    }
    
    //MARK:- Overriding Collection View related
    override func setupCollectionView(collectionView: UICollectionView?) -> Bool {
        guard collectionView == nil else {
            return false
        }
        return true
    }
    
    //MARK:- Overriding Tab Bar Controller related
    override func setupTabBar(tabBar: UITabBar?) -> Bool {
        guard let tabBar = tabBar else {
            return false
        }
        tabBar.setup(accessibilityIdenfitier: accessibilityIdenfitier, isHidden: true, backgroundColor: UIColor.white)
        return true
    }
    
    override func setupTabBarController(tabBarController: UITabBarController?) -> Bool {
        if tabBarController == nil  {
            return false
        }
        return true
    }
    
    //MARK: Navigation Item Bar Button Functions...
    
    //MARK:- Trash
    //1 UIBarButton alerts VC that the user has tapped the button.
    @objc private func trashBarButtonTapped() {
        
        //1 Ensure that the manager exists, i.e. not set to nil.
        guard let manager = manager else {
            return //error handle- managerIsSetToNil - local
        }
        
        //1a Ensure that navigation controller exists
        guard let navigationController = navigationController else {
            return //error handle - local
        }
        
        //1 Ensure that the note pad is not edit mode, if not, then its a FATAL ERROR, i.e. the trash bar button should not appear if the note pad is not on edit mode.
        
        if manager.mode.0 { //if in edit mode - proceed
            
            shouldProceedWithTrashingItem(completion: { (shouldProceed) in
                if shouldProceed {
                    
                    //handle trash bar button tapped
                    self.handleTrashBarButtonItemTapped(with: manager, completion: { (feedback) in
                        if feedback == .successful {
                            //navigate away
                            
                            //1 get no of existing view controllers in the navigation controller
                            let noOfViewControllers = navigationController.viewControllers.count
                            
                            if manager.mode.1 is BodyStructureProtocol || manager.mode.1 is PhotoStructureProtocol {
                                //if working with body structure, then pop to previous page
                                navigationController.popViewController(animated: true)
                                
                            }else if manager.mode.1 is ThreadStructureProtocol {
                                //if working with thread or instance structure, popping to previous page would be invalid as
                                //the thread/instance no longer exists. So the controller needs to pop two pages behind rather than one.
                                
                                if noOfViewControllers > 2 {
                                    //make sure that are enough view controllers to pop back 2 steps
                                    let targetVCIndex = (noOfViewControllers - 3)
                                    let targetVC = navigationController.viewControllers[targetVCIndex]
                                    navigationController.popToViewController(targetVC, animated: true)
                                    
                                }else {
                                    //if not enough - which should not be the case - then pop to previous page by default.
                                    navigationController.popViewController(animated: true)
                                }
                            }
                            
                        }else {
                            
                            //remove failed
                            //alert user of failure
                            self.loadAlertControllerForNotepadTrashFeedback(feedback: feedback)
                            return
                        }
                    })
                    
                }else {
                    return //end the function
                }
            })
            
        }else {
            return
            //FATAL ERROR, i.e. the trash bar button should not appear if the note pad is not on edit mode. - local
        }
    }
    
    //2
    private func shouldProceedWithTrashingItem(completion: @escaping (Bool) -> Void){
        let alertController = UIAlertController(title: Constants.sharedInstance._Warning, message: "Are you sure you want to trash item?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: Constants.sharedInstance._Cancel, style: .cancel, handler: { (alert) in
            self.view.isUserInteractionEnabled = true
            completion(false)
        })
        
        let yesAction = UIAlertAction(title: Constants.sharedInstance._Yes, style: .default, handler: { (alert) in
            completion(true)
        })
        
        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: {
            self.view.isUserInteractionEnabled = false
        })
    }
    
    //3
    func handleTrashBarButtonItemTapped(with manager: NotepadManager, completion: @escaping (NotepadManager.NotepadTrashFeedback) -> Void){
        manager.trash { (feedback) in
            completion(feedback)
            return
        }
    }
    
    //MARK:- Funcions related to Save
    @objc func saveBarButtonTapped(){
        
        guard let manager = manager else {
            return
        }
        
        //1 Check if required fields are not empty
        if checkIfRequiredTextViewsAreEmpty(with: manager, titleTextView: titleTextView, bodyTextView: bodyTextView) {
            notifyUser(.requiredFieldsAreEmpty)
        }else {
            
            //2 Check if below word count
            if !checkIfRequiredTextViewsAreBelowWordCount(with: manager, titleTextView: titleTextView, contentTextView: bodyTextView) {
                notifyUser(.requiredFieldsAreAboveAllowedWordCount)
                
               
                
            }else {
                
                
                
                
                //3 Check if any change has occured to the initial values
              
                if checkIfChangesHaveBeenMade(with: manager, titleTextView: titleTextView, contentTextView: bodyTextView, isVisible: isVisible) {
                    //3a ask user if should proceed with save
                   
                    if manager.mode.0 {
              
                        shouldProceedWithSave(completion: { (shouldProceed) in
                            if shouldProceed {
                        
                                
                                var count = 0
                                self.handleSaveBarButtonTapped(with: manager, title: self.titleTextView.text, content: self.bodyTextView.text, isVisible: self.isVisible, completion: { (feedback) in
                                    
                                    if feedback == .successful {
                                        count = count + 1
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                             self.navigationController?.popViewController(animated: true)
                                        })
                                        
                                       
                                    }else {
                                    self.loadAlertControllerForNotepadSaveFeedback(feedback: feedback)
                                    
                                        return
                                    }
                                })
                            }else {
                     
                                return
                            }
                        })
                    }else {
      
                        //no need to ask if manager can save changes because its a new item
                        self.handleSaveBarButtonTapped(with: manager, title: self.titleTextView.text, content: self.bodyTextView.text, isVisible: self.isVisible, completion: { (feedback) in
                            
                            if feedback == .successful {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                    self.navigationController?.popViewController(animated: true)
                                })
                            
                                
                            }else {
                                self.loadAlertControllerForNotepadSaveFeedback(feedback: feedback)
                       
                                return
                            }
                        })
                    }
                }else {
                    //3b no changes have been made
                   navigationController?.popViewController(animated: true)
        
                }
            }
        }
    }
   
    func shouldProceedWithSave(completion: @escaping (Bool) -> Void){
        let alertController = UIAlertController(title: Constants.sharedInstance._Warning, message: "Are you sure you want to save changes?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: Constants.sharedInstance._Cancel, style: .cancel, handler: { (alert) in
            self.view.isUserInteractionEnabled = true
            completion(false)
        })
        
        let yesAction = UIAlertAction(title: Constants.sharedInstance._Yes, style: .default, handler: { (alert) in
            completion(true)
        })
        
        alertController.addAction(yesAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: {
            self.view.isUserInteractionEnabled = false
        })
    }
    
    //1a - Tested 2/26/2018
    func checkIfRequiredTextViewsAreEmpty(with manager: NotepadManager, titleTextView: UITextView, bodyTextView: UITextView) -> Bool {
        
        if manager.mode.0 {
            if manager.mode.1 is BodyStructure {
                //make sure content text view is not empty
                return bodyTextView.checkIfEmpty()
            }else if manager.mode.1 is ThreadStructure {
                return titleTextView.checkIfEmpty()
            }
            
        }else {//not edit mode, i.e. add mode
            /*
            if manager.workingUnder is InstanceProfileVC {
                return bodyTextView.checkIfEmpty()
            }else if manager.workingUnder is ThreadListVC || manager.workingUnder is UserListVC {
                return titleTextView.checkIfEmpty()
            }
            */
        }
        
        return false
    }
    
    //1b - Tested 2/26/2018
    func checkIfRequiredTextViewsAreBelowWordCount(with manager: NotepadManager, titleTextView: UITextView, contentTextView: UITextView) -> Bool {
        
        var result: Bool = true
        
        if manager.mode.1 is BodyStructure {
            if !titleTextView.checkIfBelowWordCount(limit: 20) {
                result = false
            }
            
            if !contentTextView.checkIfBelowWordCount(limit: 300) {
                result = false
            }
            
        }else if manager.mode.1 is ThreadStructure {
            if !titleTextView.checkIfBelowWordCount(limit: 20) {
                result = false
            }
            
            if !contentTextView.checkIfBelowWordCount(limit: 120) {
                result = false
            }
        }
        return result
    }
    
    //1c - Tested 2/26/2018
    func checkIfChangesHaveBeenMade(with manager: NotepadManager, titleTextView: UITextView, contentTextView: UITextView, isVisible: Bool) -> Bool {
        
        var result = false
        
        if titleTextView.text != manager.initialTitle {
            result = true
        }
        
        if contentTextView.text != manager.initialContent {
            result = true
        }
        
        if manager.mode.1 != nil {
            if isVisible != manager.mode.1?.visibility {
                result = true
            }
        }
        
        return result
    }
    
    //2
    func handleSaveBarButtonTapped(with manager: NotepadManager, title: String, content: String, isVisible: Bool, completion: @escaping (NotepadManager.NotepadSaveFeedback) -> Void){
        manager.save(title: title, content: content, image: mediaDisplayImageView.image, isVisible: isVisible) { (feedback) in
            completion(feedback)
        }
    }
    
    @objc func visibilityStateBarButtonTapped(sender: UIBarButtonItem){
        isVisible = !isVisible
        if isVisible {
            sender.title = Constants.sharedInstance._Public
        }else {
            sender.title = Constants.sharedInstance._Private
        }
    }
    
    //MARK:- Alert Controllers
    private func loadAlertControllerForNotepadSaveFeedback(feedback: NotepadManager.NotepadSaveFeedback){
        let alertController = UIAlertController(title: Constants.sharedInstance._Failed, message: feedback.rawValue, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: Constants.sharedInstance._Cancel, style: .cancel, handler: { (alert) in
            self.view.isUserInteractionEnabled = true
        })
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: {
            self.view.isUserInteractionEnabled = false
        })
    }
    
    //1a
    private func loadAlertControllerForNotepadTrashFeedback(feedback: NotepadManager.NotepadTrashFeedback){
        let alertController = UIAlertController(title: Constants.sharedInstance._Failed, message: feedback.rawValue, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: Constants.sharedInstance._Cancel, style: .cancel, handler: { (alert) in
            self.view.isUserInteractionEnabled = true
        })
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: {
            self.view.isUserInteractionEnabled = false
        })
    }
    
    func notifyUser(_ feedback: SaveFeedback){
        let alertController = UIAlertController(title: Constants.sharedInstance._Warning, message: feedback.rawValue, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: Constants.sharedInstance._Cancel, style: .cancel, handler: { (alert) in
            self.view.isUserInteractionEnabled = true
        })
        
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: {
            self.view.isUserInteractionEnabled = false
        })
    }
    
    func setupNotepadVC(with manager: NotepadManager){
        
        if manager.mode.1 == nil {
            
            if let selectedMedia = manager.selectedMedia as? UIImage {
                mediaDisplayImageView.image = selectedMedia
                mediaDisplayImageView.isHidden = false
                titleTextViewAndSubHeadings.isHidden = true
            }else {
                mediaDisplayImageView.isHidden = true
                titleTextViewAndSubHeadings.isHidden = false
            }
            //need to add audio and video
            
        }else {
            
            if let photoStructure = manager.mode.1 as? PhotoStructure {
                mediaDisplayImageView.loadImageUsingCacheWithURLString(imageURL: photoStructure.imageURL, completion: { (didLoad, error) in
                    if !didLoad {
                        //error
                    }
                })
                mediaDisplayImageView.isHidden = false
                titleTextViewAndSubHeadings.isHidden = true
            }else if let videoStructure = manager.mode.1 as? FilmStructure {
                //todo later
                mediaDisplayImageView.isHidden = false
                titleTextViewAndSubHeadings.isHidden = true
            }else if let audioStructure = manager.mode.1 as? AudioStructure {
                //todo later
                mediaDisplayImageView.isHidden = false
                titleTextViewAndSubHeadings.isHidden = true
            }else if manager.mode.1 is BodyStructure {
                mediaDisplayImageView.isHidden = true
                titleTextViewAndSubHeadings.isHidden = false
            }
        }
    }
    
}


extension NotepadVC: UITextViewDelegate {
    //1
    
    func setupWordCountLabel(_ textView: UITextView, with manager: NotepadManager){
        if textView == self.titleTextView {
            titleLengthWordCount.text = textView.getLabelText(maximum: 20)
            
            if textView.wordCount() > 20 {
                titleLengthWordCount.textColor = .red
            }else {
                titleLengthWordCount.textColor = .darkGray
            }
            
        }else if textView == self.bodyTextView {
            
            var maximum = 0
            
            if let mediaStructure = manager.mode.1 {
                
                if mediaStructure is BodyStructureProtocol {
                    maximum = 300
                }else if mediaStructure is ThreadStructureProtocol {
                    maximum = 120
                }
                
            }else {
                /*
                if manager.workingUnder is InstanceProfileVC {
                    
                    maximum = 300
                }else if manager.workingUnder is ThreadListVC || manager.workingUnder is UserListVC {
                    //thread or instance
                    maximum = 120
                }
                */
            }
            
            if maximum == 300 {
                if textView.wordCount() > maximum {
                    bodyLengthWordCount.textColor = .red
                }else {
                    bodyLengthWordCount.textColor = .darkGray
                }
            }else if maximum == 120 {
                if textView.wordCount() > maximum {
                    bodyLengthWordCount.textColor = .red
                }else {
                    bodyLengthWordCount.textColor = .darkGray
                }
            }
            
            bodyLengthWordCount.text = textView.getLabelText(maximum: maximum)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        guard let manager = manager else {
            return //error handle
        }
        setupWordCountLabel(textView, with: manager)
    }
}

