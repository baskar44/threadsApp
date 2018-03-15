//
//  threadsAppUnitTestsForLoginVC.swift
//  threadsAppUnitTests
//
//  Created by Gururaj Baskaran on 5/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import XCTest
import CoreData

@testable import threadsApp


class threadsAppUnitTestsForLoginVC: XCTestCase {
    
    private var _loginVC: LoginVC!
    var loginVC: LoginVC! {
        return _loginVC
    }
    
    override func setUp() {
        super.setUp()
        _loginVC = LoginVC()
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
    
    func test_run(){
      
        
        let navigationController_a: UINavigationController? = nil
        let navigationController_b: UINavigationController? = UINavigationController()
        
        let navigationControllers: [UINavigationController?] = [navigationController_a, navigationController_b]
        
        let tabBarController: UITabBarController? = UITabBarController()
        
        for navigationController in navigationControllers {
            
            let tableView = UITableView()
            
            
            let result = loginVC.run(navigationController: navigationController, tableView: tableView, tabBarController: tabBarController)
            
            if navigationController == nil {
                XCTAssertEqual(result, .failedToLoadNavigationController)
            }else {
                XCTAssertEqual(result, nil)
            }
        }
        
        let tableView_a: UITableView? = nil
        let tableView_b: UITableView? = UITableView()
        
        let tableViews: [UITableView?] = [tableView_a, tableView_b]
        
        for tableView in tableViews {
            let navigationController = UINavigationController()
            
            let result = loginVC.run(navigationController: navigationController, tableView: tableView, tabBarController: tabBarController)
            
            if tableView == nil {
                XCTAssertEqual(result, .failedToLoadTableView)
            }else {
                XCTAssertEqual(result, nil)
            }
        }
    }
    
    func testHandleLogin() {
        let mockLoginAssistant_a = MockLoginAssistant(expectation: .loginFailedWithError)
        let mockLoginAssistant_b = MockLoginAssistant(expectation: .loginFailedWithoutError)
        let mockLoginAssistant_d = MockLoginAssistant(expectation: .requiredFieldsIncomplete)
        let mockLoginAssistant_e = MockLoginAssistant(expectation: .requiredFieldsDoesNotExist)
        
        let assistants: [MockLoginAssistant] = [mockLoginAssistant_a, mockLoginAssistant_b, mockLoginAssistant_d, mockLoginAssistant_e]
        
        for assistant in assistants {
            loginVC.handleLogin(with: assistant, completion: { (failedType) in
                if assistant.expectation == .loginFailedWithError {
                    XCTAssertEqual(failedType, .loginFailedWithError)
                }else if assistant.expectation == .loginFailedWithoutError {
                    XCTAssertEqual(failedType, .loginFailedWithoutError)
                }else if assistant.expectation == .requiredFieldsIncomplete {
                    XCTAssertEqual(failedType, .requiredFieldsIncomplete)
                }else if assistant.expectation == .requiredFieldsDoesNotExist {
                    XCTAssertEqual(failedType, .requiredFieldsDoesNotExist)
                }
            })
        }
        
       
    }
    
}
