//
//  threadsAppUITests.swift
//  threadsAppUITests
//
//  Created by Gururaj Baskaran on 11/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import XCTest


//check if it exists
//check if it is enabled
//force tap


class threadsAppUITests: XCTestCase {
    
    
    let app = XCUIApplication()
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        
        app.launch()
        sleep(5)
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testIfLoginVCLoads(){
        //1 check if nav bar loaded
        //2 check if table view loaded
        //3 check if buttons on nav bar loaded
        //4 check if all textfields are enabled
        
        //Login VC: Navigation Bar
        let loginVC_navigationBar = app.navigationBars.matching(identifier: "LoginVC").firstMatch
        loginVC_navigationBar.check(message: "nav bar is not hittable/enabled/does not exists (login vc)")
        
        //Login VC: Table view
        let loginVC_tableView = app.tables.matching(identifier: "LoginVC").firstMatch
        loginVC_tableView.check(message: "table view is not hittable/enabled/does not exists (login vc)")
        
        //Login VC: Bar Button Items in Navigation Bar
        let loginVC_registerButton = loginVC_navigationBar.buttons["Register"].firstMatch
        let loginVC_forgotPasswordButton = loginVC_navigationBar.buttons["Forgot Password"].firstMatch
        loginVC_registerButton.check(message: "Failed to load register button on nav bar (login vc).")
        loginVC_forgotPasswordButton.check(message: "Failed to load forgot password button on nav bar (login vc).")
        
        //Login VC: Text Fields in Table View
        let loginVC_email_textField = loginVC_tableView.cells.containing(.staticText, identifier:"Email").children(matching: .textField).element.firstMatch
        let loginVC_password_textField = loginVC_tableView.cells.containing(.staticText, identifier:"Password").children(matching: .textField).element.firstMatch
        
        loginVC_email_textField.check(message: "email text field is not hittable/enabled/does not exists (login vc)")
        loginVC_password_textField.check(message: "password text field is not hittable/enabled/does not exists (login vc)")
        
        //Login VC: Buttons in Table View
        let loginVC_loginButton = loginVC_tableView/*@START_MENU_TOKEN@*/.buttons["Log in"]/*[[".cells.buttons[\"Log in\"]",".buttons[\"Log in\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        loginVC_loginButton.check(message: "Login button failed.")
    }
    
    func testIfRegisterVCLoads(){
        //1 test if register screen properly loads.
        //2 check if table view loads.
        //3 check if buttons have loaded (create and cancel)
        //3 check if all textfields are enabled.
        
        testIfLoginVCLoads()
        //No checks related to Login VC required, because testIfLoginVCLoads() is already activated and completed...
        
        //Login VC: Navigation Bar
        let loginVC_navigationBar = app.navigationBars["LoginVC"].firstMatch
        
        //Login VC: Register Button
        loginVC_navigationBar.buttons["Register"].firstMatch.forceTap()
        
        //Tests required from here on...
        //Register VC: Navigation Bar
        let registerVC_navigationBar = app.navigationBars.matching(identifier: "Register").firstMatch
        registerVC_navigationBar.check(message: "nav bar is not hittable/enabled or does not exist (register vc).")
    
        //Register VC: Bar Button items in navigation bar
        let registerVC_createButton = registerVC_navigationBar.buttons["Create"].firstMatch
        registerVC_createButton.check(message: "create button is not hittable/enabled or does not exist (register vc).")
        
        let registerVC_cancelButton = registerVC_navigationBar.buttons["Cancel"].firstMatch
        registerVC_cancelButton.check(message: "cancel button is not hittable/enabled or does not exist (register vc) (register vc).")
        
        //Register VC: table view
        let registerVC_tableView = app.tables.matching(identifier: "RegisterTV").firstMatch
        registerVC_tableView.check(message:  "table view is not hittable/enabled or does not exist(register vc).")
        
        //Register VC: Text fields inside table view
        let registerVC_email_textField = registerVC_tableView.cells.containing(.staticText, identifier:"Email").children(matching: .textField).element.firstMatch
        let registerVC_password_textField = registerVC_tableView.cells.containing(.staticText, identifier:"Password").children(matching: .textField).element.firstMatch
        let registerVC_confirmPassword_textField = registerVC_tableView.cells.containing(.staticText, identifier:"Confirm Password").children(matching: .textField).element.firstMatch
        let registerVC_username_textField = registerVC_tableView.cells.containing(.staticText, identifier:"Username").children(matching: .textField).element.firstMatch
        
        registerVC_email_textField.check(message: "email textfield is not hittable/enabled or does not exist (register vc).")
        registerVC_password_textField.check(message: "password textfield is not hittable/enabled or does not exist (register vc).")
        registerVC_confirmPassword_textField.check(message: "confirm password textfield is not hittable/enabled or does not exist (register vc).")
        registerVC_username_textField.check(message: "username textfield is not hittable/enabled or does not exist (register vc).")
        //Process
        registerVC_cancelButton.forceTap()
        
    }
    
    func testLoginVCProcessWithWrongDetails(){
        testIfLoginVCLoads()
        //No checks required, because testIfLoginVCLoads() is already activated and completed...
        
        //Login button in table view
        let loginButton = app.tables/*@START_MENU_TOKEN@*/.buttons["Log in"]/*[[".cells.buttons[\"Log in\"]",".buttons[\"Log in\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        loginButton.forceTap()
        
        //Alert - check required...
        let alert = app.alerts["Invalid User Credentials"].firstMatch
        alert.check(message: "alert is not hittable/enabled or does not exist (login vc).")

        let alert_cancelButton = alert.buttons["Cancel"].firstMatch
        alert_cancelButton.check(message: "alert cancel button is not hittable/enabled or does not exist (login vc)")
    
        //Process
        alert_cancelButton.forceTap()
    }
    
    func testIfLoginWorksWithDummy(){
        testIfLoginVCLoads()
        //No checks required, because testIfLoginVCLoads() is already activated and completed...
        
        //Table view for LoginVC
        let loginVC_tableView = app.tables.matching(identifier: "LoginVC").firstMatch
        
        //Text fields in table view for Login VC
        let email_textField = loginVC_tableView.cells.containing(.staticText, identifier:"Email").children(matching: .textField).element.firstMatch
        let password_textField = loginVC_tableView.cells.containing(.staticText, identifier:"Password").children(matching: .textField).element.firstMatch
        
        //Login Button in table view for Login VC
        let loginButton = loginVC_tableView/*@START_MENU_TOKEN@*/.buttons["Log in"]/*[[".cells.buttons[\"Log in\"]",".buttons[\"Log in\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        
        //Process
        email_textField.forceTap()
        email_textField.typeText("baskar44@gmail.com")
        
        password_textField.forceTap()
        password_textField.typeText("soda1990")
        
        loginButton.forceTap()
        
    }
   
    //Use case: User signs out.
    func testIfUserProfileVCLoadsFromLoginVC(){
        
        testIfLoginWorksWithDummy()
        
        //UserProfileVC: Navigation Bar
        let userProfileVC_navBar = app.navigationBars.matching(identifier: "User_Profile").firstMatch
        userProfileVC_navBar.check(message: "nav bar is not hittable (user profile vc)")
        
        //UserProfileVC: Sign out Bar Button Item on Navigation Bar
        let userProfileVC_signOutButton = userProfileVC_navBar.buttons["Sign out"].firstMatch
        userProfileVC_signOutButton.check(message: "sign out button is not hittable (user profile vc)")
        
        //UserProfileVC: Table View
        let userProfileVC_tableView = app.tables.matching(identifier: "User_Profile").firstMatch
        userProfileVC_tableView.check(message: "table view is not hittable (user profile vc)")

        //Process
        userProfileVC_signOutButton.forceTap()
    }
   
    
}

enum TestType: String {
    case isHittable = "is not hittable."
    case isEnabled  = "is not enabled."
    case isSelected = "is not selected."
    case exists = "does not exist."
}


extension XCUIElement {
    func forceTap() {
        if self.isHittable {
            self.tap()
        } else {
            let vector = CGVector(dx: 0.0, dy: 0.0)
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: vector)
            coordinate.tap()
        }
    }
    
    private func checkIfFaulty(testType: TestType, message: String){
        
        var expression: Bool?
        
        switch testType {
        case .exists:
            expression = self.exists
            break
        case .isEnabled:
            expression = self.isEnabled
            break
        case .isHittable:
            expression = self.isHittable
            break
        case .isSelected:
            expression = self.isSelected
            break
        }
        
        if let expression = expression {
            XCTAssert(expression, message)
        }else {
            XCTFail("FAILED: Could not get expression for FAILED: \(identifier)")
        }
    }
    
    func check(message: String){
        if waitForExistence(timeout: 5)  {
            if elementType == .textView || elementType == .textField {
                if !self.isHittable {
                    self.forceTap()
                    checkIfFaulty(testType: .isEnabled, message: message)
                }
            }else {
                checkIfFaulty(testType: .isHittable, message: message)
                checkIfFaulty(testType: .isEnabled, message: message)
            }
        }
        
        checkIfFaulty(testType: .exists, message: message)
    }
}
