//
//  threadsApp_WelcomeVC.swift
//  threadsAppUnitTests
//
//  Created by Gururaj Baskaran on 19/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import XCTest

@testable import threadsApp

class threadsApp_WelcomeVC: XCTestCase {
    
    var welcomeVC: WelcomeVC!
    
    override func setUp() {
        super.setUp()
        welcomeVC = WelcomeVC()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        welcomeVC = WelcomeVC()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSetupTabBarController() {
        
        let a: UITabBarController? = UITabBarController()
        let b: UITabBarController? = nil
        
        let tabBarControllers: [UITabBarController?] = [a,b]
        
        for tabBarController in tabBarControllers {
            let result = welcomeVC.setupTabBarController(tabBarController: tabBarController)
            
            if tabBarController == nil {
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
            let result = welcomeVC.setupTabBar(tabBar: tabBar)
            
            if tabBar == nil {
                XCTAssert(result)
            }else {
                XCTAssertFalse(result)
            }
        }
    }
    
    func testSetupTableView() {
        
        let a: UITableView? = UITableView()
        let b: UITableView? = nil
        
        let tableViews: [UITableView?] = [a,b]
        
        for tableView in tableViews {
            let result = welcomeVC.setupTableView(tableView: tableView)
            
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
            let result = welcomeVC.setupCollectionView(collectionView: collectionView)
            
            if collectionView == nil {
                XCTAssert(result)
            }else {
                XCTAssertFalse(result)
            }
        }
    }
    
    func testSetupNavigationItem(){

        let a: UINavigationItem? = UINavigationItem()
        let b: UINavigationItem? = nil
        
        let navigationItems: [UINavigationItem?] = [a,b]
        
        for navigationItem in navigationItems {
            let result = welcomeVC.setupNavigationItem(navigationItem: navigationItem)
            
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
            let result = welcomeVC.setupNavigationBar(navigationBar: navigationBar)
            
            if navigationBar == nil {
                XCTAssertFalse(result)
            }else {
                XCTAssert(result)
            }
        }
    }
    
    
    func testSetupNavigationController(){
 
        
        let a: UINavigationController? = UINavigationController()
        let b: UINavigationController? = nil
        
        let navigationControllers: [UINavigationController?] = [a,b]
        
        for navigationController in navigationControllers {
            let result = welcomeVC.setupNavigationController(navigationController: navigationController)
            
            if navigationController == nil {
                XCTAssertFalse(result)
            }else {
                XCTAssert(result)
            }
        }
    }
    
    func testGetAuthenticationAssistant(){
        let clearAssistant = MockClearAssistant(expectedFeedback: .clearCompleted)
        
        welcomeVC?.getAuthenticationAssistant(clearAssistant: clearAssistant, completion: { (assistant) in
            if clearAssistant.expectedFeedback == .clearCompleted {
                XCTAssertNotNil(assistant)
            }else {
                XCTAssertNil(assistant)
            }
        })
    }
    
    func testLaunchLoginVC(){
        
        let navigationController: UINavigationController? = UINavigationController()
        let navigationControllerNil: UINavigationController? = nil
        
        let controllers: [UINavigationController?] = [navigationController, navigationControllerNil]
        
        for controller in controllers {
            let didLaunch = welcomeVC?.launchLoginVC(navigationController: controller)
            
            XCTAssertNotNil(didLaunch)
            
            if controller == nil {
                XCTAssertFalse(didLaunch!)
            }else {
                XCTAssert(didLaunch!)
            }
        }
    }
    
    func testDidSetCurrentUser(){
        
        let currentDate = Date()
        let dummyUserStructure = UserStructure(id: "Dummy", createdDate: currentDate, createdDateString: "Dummy", visibility: true, username: "Dummy", fullname: "Dummy", bio: "Dummy", profileImageURL: "Dummy")
        
        
        let dummyNilUserStructure: UserStructure? = nil
        
        let structures: [UserStructure?] = [dummyUserStructure, dummyNilUserStructure]
        
        for structure in structures {
            
            let didSet = welcomeVC?.didSetCurrentUser(currentUserStructure: structure)
            
            XCTAssertNotNil(didSet)
            
            if structure == nil {
                XCTAssertFalse(didSet!)
            }else {
                XCTAssert(didSet!)
            }
        }
    }
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
