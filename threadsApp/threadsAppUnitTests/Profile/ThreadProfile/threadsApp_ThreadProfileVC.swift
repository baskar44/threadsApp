//
//  threadsApp_ThreadProfileVC.swift
//  threadsAppUnitTests
//
//  Created by Gururaj Baskaran on 20/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import XCTest

@testable import threadsApp

class threadsApp_ThreadProfileVC: XCTestCase {
    
    var threadProfileVC: ThreadProfileVC!
    
    override func setUp() {
        super.setUp()
        threadProfileVC = ThreadProfileVC()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
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
            let result = threadProfileVC.setupNavigationController(navigationController: navigationController)
            
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
            let result = threadProfileVC.setupNavigationItem(navigationItem: navigationItem)
            
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
            let result = threadProfileVC.setupNavigationBar(navigationBar: navigationBar)
            
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
            let result = threadProfileVC.setupTableView(tableView: tableView)
            
            if tableView == nil {
                XCTAssertFalse(result)
            }else {
                XCTAssert(result)
            }
        }
    }
    
    func testSetupTabBar() {
        
        let a: UITabBar? = UITabBar()
        let b: UITabBar? = nil
        
        let tabBars: [UITabBar?] = [a,b]
        
        for tabBar in tabBars {
            let result = threadProfileVC.setupTabBar(tabBar: tabBar)
            
            if tabBar == nil {
                XCTAssertFalse(result)
            }else {
                XCTAssert(result)
            }
        }
    }
    
    func testSetupCollectionView() {
        
        let a: UICollectionView? = UICollectionView()
        let b: UICollectionView? = nil
        
        let collectionViews: [UICollectionView?] = [a,b]
        
        for collectionView in collectionViews {
            let result = threadProfileVC.setupCollectionView(collectionView: collectionView)
            
            if collectionView == nil {
                XCTAssert(result)
            }else {
                XCTAssertFalse(result)
            }
        }
    }
    
    func testSetupTabBarController() {
        
        let a: UITabBarController? = UITabBarController()
        let b: UITabBarController? = nil
        
        let tabBarControllers: [UITabBarController?] = [a,b]
        
        for tabBarController in tabBarControllers {
            let result = threadProfileVC.setupTabBarController(tabBarController: tabBarController)
            
            if tabBarController == nil {
                XCTAssertFalse(result)
            }else {
                XCTAssert(result)
            }
        }
    }
}
