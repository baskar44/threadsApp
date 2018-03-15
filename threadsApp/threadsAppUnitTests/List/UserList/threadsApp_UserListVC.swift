//
//  threadsApp_UserListVC.swift
//  threadsAppUnitTests
//
//  Created by Gururaj Baskaran on 20/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import XCTest

@testable import threadsApp

class threadsApp_UserListVC: XCTestCase {
    
    var userListVC: UserListVC!
    
    override func setUp() {
        super.setUp()
        userListVC = UserListVC()
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
    
    //Must have tests
    func testSetupNavigationController(){
        
        let a: UINavigationController? = UINavigationController()
        let b: UINavigationController? = nil
        
        let navigationControllers: [UINavigationController?] = [a,b]
        
        for navigationController in navigationControllers {
            let result = userListVC.setupNavigationController(navigationController: navigationController)
            
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
            let result = userListVC.setupNavigationItem(navigationItem: navigationItem)
            
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
            let result = userListVC.setupNavigationBar(navigationBar: navigationBar)
            
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
            let result = userListVC.setupTableView(tableView: tableView)
            
            if tableView == nil {
                XCTAssertFalse(result)
            }else {
                XCTAssert(result)
            }
        }
    }
    
    func testSetupCollectionView() {
        
        let layout = UICollectionViewLayout()
        let a = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        let b: UICollectionView? = nil
        
        let collectionViews: [UICollectionView?] = [a,b]
        
        for collectionView in collectionViews {
            let result = userListVC.setupCollectionView(collectionView: collectionView)
            
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
            let result = userListVC.setupTabBar(tabBar: tabBar)
            
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
            let result = userListVC.setupTabBarController(tabBarController: tabBarController)
            
            if tabBarController == nil {
                XCTAssertFalse(result)
            }else {
                XCTAssert(result)
            }
        }
    }
    
}
