//
//  threadsApp_UserProfileVC.swift
//  threadsAppUnitTests
//
//  Created by Gururaj Baskaran on 20/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import XCTest

@testable import threadsApp

class threadsApp_UserProfileVC: XCTestCase {
    
    var userProfileVC: ProfileVC!
    
    override func setUp() {
        super.setUp()
        
        let userStructure = UserStructure(id: "Dummy", createdDate: Date(), createdDateString: "Dummy", visibility: true, username: "Dummy", fullname: "Dummy", bio: "Dummy", profileImageURL: "Dummy")
        
        let manager = UserProfileManager(employedBy: userStructure, selectedUserStructure: userStructure)
        userProfileVC = ProfileVC(manager: manager)
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
            let result = userProfileVC.setupNavigationController(navigationController: navigationController)
            
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
            let result = userProfileVC.setupNavigationItem(navigationItem: navigationItem)
            
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
            let result = userProfileVC.setupNavigationBar(navigationBar: navigationBar)
            
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
            let result = userProfileVC.setupTableView(tableView: tableView)
            
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
            let result = userProfileVC.setupCollectionView(collectionView: collectionView)
            
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
            let result = userProfileVC.setupTabBar(tabBar: tabBar)
            
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
            let result = userProfileVC.setupTabBarController(tabBarController: tabBarController)
            
            if tabBarController == nil {
                XCTAssertFalse(result)
            }else {
                XCTAssert(result)
            }
        }
    }
    
    
    //////////
    /*
    func testGetProfileImageViewHeight(){
        
        let a: String? = "DummyURL"
        let b: String? = nil
        
        let urls: [String?] = [a,b]
        
        for url in urls {
           let height = userProfileVC.getProfileImageViewHeight(imageURL: url)
            if url == nil {
                XCTAssertEqual(height, 0)
            }else {
                XCTAssertEqual(height, 120)
            }
        }
    }
    */
    //redo
    /*
    func testGetFollowStateButtonHeight() {
        
        let a: ViewController.UserAccessLevel = .blocked
        let b: ViewController.UserAccessLevel = .current
        let c: ViewController.UserAccessLevel = .failed
        let d: ViewController.UserAccessLevel = .full
        let e: ViewController.UserAccessLevel = .noAccess
        
        let accessLevels = [a,b,c,d,e]
        
        for accessLevel in accessLevels {
            
            guard let manager = userProfileVC.manager else {
                return
            }
            
            userProfileVC.getFollowStateButtonHeight(manager: manager, completion: { (height) in
                if accessLevel == .current || accessLevel == .failed {
                    print("mark: height: \(height)")
                    XCTAssertEqual(height, 0.0)
                }else {
                    XCTAssertEqual(height, 30.0)
                }
            })
        }
    }
    
    func testGetTableViewDisplay() {
        let a: ViewController.UserAccessLevel = .blocked
        let b: ViewController.UserAccessLevel = .current
        let c: ViewController.UserAccessLevel = .failed
        let d: ViewController.UserAccessLevel = .full
        let e: ViewController.UserAccessLevel = .noAccess
        
        let accessLevels = [a,b,c,d,e]
        
        for accessLevel in accessLevels {
            
            guard let manager = userProfileVC.manager else {
                return
            }
            
            userProfileVC.getTableViewDisplay(with: manager, completion: { (tableViewDisplay) in
               
                let sectionCount = tableViewDisplay.count
                
                switch accessLevel {
                case .current:
                    let resultShouldBe: [[ProfileVC.TableViewRowDisplay]] = [[.feed],[.threads, .moderating],[.followers, .following], [.sharing], [.journal], [.edit, .signOut]]
                    
                    for i in 0...(sectionCount - 1) {
                        XCTAssertEqual(tableViewDisplay[i], resultShouldBe[i])
                    }
                    break
                case .full:
                    let resultShouldBe: [[ProfileVC.TableViewRowDisplay]] = [[.feed],[.threads, .moderating],[.followers, .following], [.sharing], [.report, .block]]
                    
                    for i in 0...(sectionCount - 1) {
                        XCTAssertEqual(tableViewDisplay[i], resultShouldBe[i])
                    }
                    break
                case .noAccess:
                    let resultShouldBe: [[ProfileVC.TableViewRowDisplay]] = [[.noAccess], [.report, .block]]
                    
                    for i in 0...(sectionCount - 1) {
                        XCTAssertEqual(tableViewDisplay[i], resultShouldBe[i])
                    }
                    break
                default:
                    break
                }
            })
        }
    }
    */
}
