//
//  threadsApp_CreateMediaVC.swift
//  threadsAppUnitTests
//
//  Created by Gururaj Baskaran on 22/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import XCTest

@testable import threadsApp

class threadsApp_CreateMediaVC: XCTestCase {
   
    /*
    var notepadVC: NotepadVC!
    
    var userStructure: UserStructure!
    var threadStructure: ThreadStructure!
    var instanceStructure: InstanceStructure!
    var bodyStructure: BodyStructure!
    var textViewTypes: [TextViewType] = [TextViewType.content, TextViewType.title]
    var textViews: [UITextView]!
    
    var possibleModes: [CreateMediaVC.NotepadMode]!
    var possibileWorkingUnderViewControllers: [ViewController]!

    
    let editModes = [true, false]
    
    let dummy_300 = "Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy"
    
    let dummy_120 = "Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy"
    
    let dummy_20 = "Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy Dummy"
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        userStructure = UserStructure(id: "Dummy", createdDate: Date(), createdDateString: "Dummy", visibility: true, username: "Dummy", fullname: "Dummy", bio: "Dummy", profileImageURL: "Dummy")
        
        threadStructure = ThreadStructure(id: "Dummy", createdDate: Date(), visibility: true, title: "Dummy", creatorStructure: userStructure, about: "Dummy", profileImageURL: "Dummy")
        
        bodyStructure = BodyStructure(id: "Dummy", bodyText: "Dummy", bodyTitle: "Dummy", createdDate: Date(), createdDateString: "Dummy", creatorStructure: userStructure, parentStructure: instanceStructure, visibility: true)
    
     
        let textView_a = UITextView() //empty
        textView_a.text = Constants.sharedInstance._emptyString
        let textView_b = UITextView() // 120
        textView_b.text = dummy_120
        let textView_c = UITextView() // 300
        textView_c.text = dummy_300
        let textView_d = UITextView() // 20
        textView_d.text = dummy_20
        
        textViews = [textView_a, textView_b, textView_c, textView_d]
        
        possibleModes = [(true, bodyStructure), (true, instanceStructure), (true, threadStructure), (false, nil)]

        let threadProfileManager = ThreadProfileManager(selectedThreadStructure: threadStructure, employedBy: userStructure)
        
        let threadProfile = ThreadProfileVC(manager: threadProfileManager)

        let listManager = UserListManager(userListType: .feed, employedBy: userStructure, selectedUserStructure: userStructure)
        let userList = UserListVC(manager: listManager)

        
        let manager = NotepadManager(mode: (false, nil), employedBy: userStructure, workingUnder: ThreadProfileVC(), selectedMedia: nil)
        
        notepadVC = NotepadVC(manager: manager)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCheckIfChangesHaveBeenMade(){
        var count = 0
        
        for mode in possibleModes {
            for workingUnder in possibileWorkingUnderViewControllers {
                let manager = NotepadManager(mode: mode, employedBy: userStructure, workingUnder: workingUnder)
                
                let createMediaVC = CreateMediaVC(manager: manager)
                
                let emptyTextView = UITextView()
                let filledTextView = UITextView()
                filledTextView.text = "Dummy"
             
                
                let textViews: [UITextView] = [emptyTextView, filledTextView]
                let isVisibleValues: [Bool] = [true, false]
                
                for titleTextView in textViews {
                    
                    for contentTextView in textViews {
                        
                        for isVisible in isVisibleValues {
                            
                            let result = createMediaVC.checkIfChangesHaveBeenMade(with: manager, titleTextView: titleTextView, contentTextView: contentTextView, isVisible: isVisible)
                            
                            //print("mark: initial: \(manager.initialTitle, manager.initialContent)")
                            //initial values will be empty - default isVisible = true
                            
                            if mode.1 == nil {
                                print("mark: initial: \(manager.initialTitle, manager.initialContent, result)")
                                if titleTextView == emptyTextView && contentTextView == emptyTextView {
                                    XCTAssertFalse(result)
                                }else {
                                    XCTAssert(result)
                                }
                                
                                
                            }else {
                                if titleTextView == filledTextView && contentTextView == filledTextView && isVisible == true {
                                    XCTAssertFalse(result)
                                }else {
                                    XCTAssert(result)
                                }
                            }
                            
                          
                        }
                      
                    }
                }
            }
        }
    }
    
    
    func testCheckIfRequiredTextViewsAreBelowWordCount() {
        
        var count = 0
        
        for mode in possibleModes {
            for workingUnder in possibileWorkingUnderViewControllers {
                let manager = NotepadManager(mode: mode, employedBy: userStructure, workingUnder: workingUnder)
                
                let createMediaVC = CreateMediaVC(manager: manager)
                
                let emptyTextView = UITextView()
                let filledTextView = UITextView()
                let halfFilledTextView = UITextView()
                filledTextView.text = dummy_300
                halfFilledTextView.text = dummy_120
                
                let textViews: [UITextView] = [emptyTextView, filledTextView, halfFilledTextView]
                
                for titleTextView in textViews {
                    
                    for contentTextView in textViews {
                        let result = createMediaVC.checkIfRequiredTextViewsAreBelowWordCount(with: manager, titleTextView: titleTextView, contentTextView: contentTextView)
                        count = count + 1
                        print("mark: count = \(count)")
                        if manager.mode.1 is BodyStructure {
                            if titleTextView == emptyTextView && contentTextView == emptyTextView {
                                XCTAssert(result)
                            }else if titleTextView == emptyTextView && contentTextView == filledTextView {
                                XCTAssert(result)
                            }else if titleTextView == emptyTextView && contentTextView == halfFilledTextView {
                                XCTAssert(result)
                            }
                            
                            if titleTextView == filledTextView && contentTextView == emptyTextView {
                                XCTAssertFalse(result)
                            }else if titleTextView == filledTextView && contentTextView == filledTextView {
                                XCTAssertFalse(result)
                            }else if titleTextView == filledTextView && contentTextView == halfFilledTextView {
                                XCTAssertFalse(result)
                            }
                            
                            if titleTextView == halfFilledTextView && contentTextView == emptyTextView {
                                XCTAssertFalse(result)
                            }else if titleTextView == halfFilledTextView && contentTextView == filledTextView {
                                XCTAssertFalse(result)
                            }else if titleTextView == halfFilledTextView && contentTextView == halfFilledTextView {
                                XCTAssertFalse(result)
                            }
                            
                            if titleTextView == emptyTextView && contentTextView == emptyTextView {
                                XCTAssert(result)
                            }else if titleTextView == filledTextView && contentTextView == emptyTextView {
                                XCTAssertFalse(result)
                            }else if titleTextView == halfFilledTextView && contentTextView == emptyTextView {
                                XCTAssertFalse(result)
                            }
                            
                            if titleTextView == emptyTextView && contentTextView == filledTextView {
                                XCTAssert(result)
                            }else if titleTextView == filledTextView && contentTextView == filledTextView {
                                XCTAssertFalse(result)
                            }else if titleTextView == halfFilledTextView && contentTextView == filledTextView {
                                XCTAssertFalse(result)
                            }
                            
                            if titleTextView == emptyTextView && contentTextView == halfFilledTextView {
                                XCTAssert(result)
                            }else if titleTextView == filledTextView && contentTextView == halfFilledTextView {
                                XCTAssertFalse(result)
                            }else if titleTextView == halfFilledTextView && contentTextView == halfFilledTextView {
                                XCTAssertFalse(result)
                            }
                         
                        }else if manager.mode.1 is InstanceStructure || manager.mode.1 is ThreadStructure {
                            if titleTextView == emptyTextView && contentTextView == emptyTextView {
                                XCTAssert(result)
                            }else if titleTextView == emptyTextView && contentTextView == filledTextView {
                                XCTAssertFalse(result)
                            }else if titleTextView == emptyTextView && contentTextView == halfFilledTextView {
                                XCTAssert(result)
                            }
                            
                            if titleTextView == filledTextView && contentTextView == emptyTextView {
                                XCTAssertFalse(result)
                            }else if titleTextView == filledTextView && contentTextView == filledTextView {
                                XCTAssertFalse(result)
                            }else if titleTextView == filledTextView && contentTextView == halfFilledTextView {
                                XCTAssertFalse(result)
                            }
                            
                            if titleTextView == halfFilledTextView && contentTextView == emptyTextView {
                                XCTAssertFalse(result)
                            }else if titleTextView == halfFilledTextView && contentTextView == filledTextView {
                                XCTAssertFalse(result)
                            }else if titleTextView == halfFilledTextView && contentTextView == halfFilledTextView {
                                XCTAssertFalse(result)
                            }
                            
                            if titleTextView == emptyTextView && contentTextView == emptyTextView {
                                XCTAssert(result)
                            }else if titleTextView == filledTextView && contentTextView == emptyTextView {
                                XCTAssertFalse(result)
                            }else if titleTextView == halfFilledTextView && contentTextView == emptyTextView {
                                XCTAssertFalse(result)
                            }
                            
                            if titleTextView == emptyTextView && contentTextView == filledTextView {
                                XCTAssertFalse(result)
                            }else if titleTextView == filledTextView && contentTextView == filledTextView {
                                XCTAssertFalse(result)
                            }else if titleTextView == halfFilledTextView && contentTextView == filledTextView {
                                XCTAssertFalse(result)
                            }
                            
                            if titleTextView == emptyTextView && contentTextView == halfFilledTextView {
                                XCTAssert(result)
                            }else if titleTextView == filledTextView && contentTextView == halfFilledTextView {
                                XCTAssertFalse(result)
                            }else if titleTextView == halfFilledTextView && contentTextView == halfFilledTextView {
                                XCTAssertFalse(result)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func testCheckIfRequiredTextViewsAreEmpty() {
        
        for mode in possibleModes {
            for workingUnder in possibileWorkingUnderViewControllers {
                let manager = NotepadManager(mode: mode, employedBy: userStructure, workingUnder: workingUnder)
                
                let createMediaVC = CreateMediaVC(manager: manager)
                
                let emptyTextView = UITextView()
                let filledTextView = UITextView()
                filledTextView.text = "Filled"
                
                
                let textViews: [UITextView] = [emptyTextView, filledTextView]
                
                for titleTextView in textViews {
                    
                    for contentTextView in textViews {
                        
                        let result = createMediaVC.checkIfRequiredTextViewsAreEmpty(with: manager, titleTextView: titleTextView, bodyTextView: contentTextView)
                        
                        if manager.mode.0 {
                            if manager.mode.1 is BodyStructure {
                                if contentTextView == emptyTextView {
                                    XCTAssert(result)
                                }else {
                                    XCTAssertFalse(result)
                                }
                                
                            }else if manager.mode.1 is InstanceStructure || manager.mode.1 is ThreadStructure {
                                if titleTextView == emptyTextView {
                                    XCTAssert(result)
                                }else {
                                    XCTAssertFalse(result)
                                }
                            }
                        }else {
                            if manager.workingUnder is InstanceProfileVC {
                                if contentTextView == emptyTextView {
                                    XCTAssert(result)
                                }else {
                                    XCTAssertFalse(result)
                                }
                                
                            }else if manager.workingUnder is ThreadListVC || manager.workingUnder is UserListVC {
                                if titleTextView == emptyTextView {
                                    XCTAssert(result)
                                }else {
                                    XCTAssertFalse(result)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //Must have tests
    func testSetupNavigationController(){
        
        let a: UINavigationController? = UINavigationController()
        let b: UINavigationController? = nil
        
        let navigationControllers: [UINavigationController?] = [a,b]
        
        for navigationController in navigationControllers {
            let result = createMediaVC.setupNavigationController(navigationController: navigationController)
            
            if navigationController == nil {
                XCTAssertFalse(result)
            }else {
                XCTAssert(result)
            }
        }
    }
    
    func testSetupNavigationItem(){
        
        let a: UINavigationItem? = UINavigationItem()
        let b: UINavigationItem? = nil
        
        let navigationItems: [UINavigationItem?] = [a,b]
        
        for navigationItem in navigationItems {
            let result = createMediaVC.setupNavigationItem(navigationItem: navigationItem)
            
            if navigationItem == nil {
                XCTAssertFalse(result)
            }else {
                XCTAssert(result)
            }
        }
    }
    
    func testSetupNavigationBar(){
        
        let a: UINavigationBar? = UINavigationBar()
        let b: UINavigationBar? = nil
        
        let navigationBars: [UINavigationBar?] = [a,b]
        
        for navigationBar in navigationBars {
            let result = createMediaVC.setupNavigationBar(navigationBar: navigationBar)
            
            if navigationBar == nil {
                XCTAssertFalse(result)
            }else {
                XCTAssert(result)
            }
        }
    }
    
    func testSetupTableView() {
        
        let a: UITableView? = UITableView()
        let b: UITableView? = nil
        
        let tableViews: [UITableView?] = [a,b]
        
        for tableView in tableViews {
            let result = createMediaVC.setupTableView(tableView: tableView)
            
            if tableView == nil {
                XCTAssert(result)
            }else {
                XCTAssertFalse(result)
            }
        }
    }
    
    func testSetupCollectionView() {
        
        let layout = UICollectionViewLayout()
        let a = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        let b: UICollectionView? = nil
        
        let collectionViews: [UICollectionView?] = [a,b]
        
        for collectionView in collectionViews {
            let result = createMediaVC.setupCollectionView(collectionView: collectionView)
            
            if collectionView == nil {
                XCTAssert(result)
            }else {
                XCTAssertFalse(result)
            }
        }
    }
    
    func testSetupTabBar() {
        
        let a: UITabBar? = UITabBar()
        let b: UITabBar? = nil
        
        let tabBars: [UITabBar?] = [a,b]
        
        for tabBar in tabBars {
            let result = createMediaVC.setupTabBar(tabBar: tabBar)
            
            if tabBar == nil {
                XCTAssertFalse(result)
            }else {
                XCTAssert(result)
            }
        }
    }
    
    func testSetupTabBarController() {
        
        let a: UITabBarController? = UITabBarController()
        let b: UITabBarController? = nil
        
        let tabBarControllers: [UITabBarController?] = [a,b]
        
        for tabBarController in tabBarControllers {
            let result = createMediaVC.setupTabBarController(tabBarController: tabBarController)
            
            if tabBarController == nil {
                XCTAssertFalse(result)
            }else {
                XCTAssert(result)
            }
        }
    }
 
    */
}
