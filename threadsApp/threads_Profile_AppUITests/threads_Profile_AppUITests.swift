//
//  threads_Profile_AppUITests.swift
//  threads_Profile_AppUITests
//
//  Created by Gururaj Baskaran on 12/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import XCTest

/*
enum UserListType: String {
    case instances = "Instances"
    case moderating = "Moderating"
    case following = "Following"
    case followers = "Followers"
    case journal = "Journal"
}

enum TestType: String {
    case isHittable = "is not hittable."
    case isEnabled  = "is not enabled."
    case isSelected = "is not selected."
    case exists = "does not exist."
}

class threads_Profile_AppUITests: XCTestCase {
    
    let app = XCUIApplication()
    let messageCore = "failed while checking isHittable, isEnabled or exists."
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
   
    enum UserProfileElement {
        case navigationBar
        case tableView
        case next
        case back
        case signOutButton
        case done
    }
    
    func testIfUserProfileVCLoads(userProfileElements: [UserProfileElement]? = nil)  -> [XCUIElement]? {
        //1 test if nav bar loaded
        //2 test if table loaded
        let accessibilityIdentifier = "User_Profile"
        let messageCore = "failed while checking isHittable, isEnabled or exists."
        
        var returnElements: [XCUIElement] = []
        
        //UserProfileVC: Navigation Bar
        let userProfileVC_navBar = app.navigationBars.matching(identifier: accessibilityIdentifier).firstMatch
        userProfileVC_navBar.check(message: "\(accessibilityIdentifier) VC Navigation Bar \(messageCore)")
        
        //UserProfileVC: Bar Button Items in Navigation Bar
        let userProfileVC_signOutButton = userProfileVC_navBar.buttons["Sign out"].firstMatch
        userProfileVC_signOutButton.check(message: "\(accessibilityIdentifier) VC Navigation Bar \(messageCore)")
        
        //UserProfileVC: Table View
        let userProfileVC_tableView = app.tables.matching(identifier: accessibilityIdentifier).firstMatch
        userProfileVC_tableView.check(message: "\(accessibilityIdentifier) VC Table View \(messageCore)")
        
        //Returning...
        if let userProfileElements = userProfileElements {
            
            for element in userProfileElements  {
                switch element {
                    
                case .navigationBar:
                    returnElements.append(userProfileVC_navBar)
                case .tableView:
                    returnElements.append(userProfileVC_tableView)
                case .signOutButton:
                    returnElements.append(userProfileVC_signOutButton)
                default:
                    break
                }
                
                return returnElements
            }
        }
        
        return nil
    }
    
    /*
    func testIfEditUserLoads() {
        //This test ensure the navigation bar, table view and all the required cells and the children within them are working as intended
        
        //EditUserVC: Navigation Bar
        
        let accessibilityIdentifier = "EditUser"
        let messageCore = "failed while checking isHittable, isEnabled or exists."
        
        if let userProfileVC_table = testIfUserProfileVCLoads(userProfileElements: [.tableView])?.first  {
            let editOption = userProfileVC_table.staticTexts["Edit"].firstMatch
            //editOption.check(message: )
            editOption.forceTap()
            
            //EditUserVC: Navigation Bar
            let editUserProfileVC_navigationBar = app.navigationBars["EditUser"].firstMatch
            editUserProfileVC_navigationBar.check(message: "\(accessibilityIdentifier) VC Navigation Bar \(messageCore)")
            
            //EditUserVC: Table View
            let editUserProfileVC_table = app.tables["EditUser"].firstMatch
            editUserProfileVC_table.check(message: "\(accessibilityIdentifier) VC Table View \(messageCore)")
            
            //EditUserVC: Bar Button Items
            let editUserProfileVC_saveButton = editUserProfileVC_navigationBar.buttons["Save"].firstMatch
            editUserProfileVC_saveButton.check(message: "\(accessibilityIdentifier) VC Save button \(messageCore)")
            
            let editUserProfileVC_backButton = editUserProfileVC_navigationBar.buttons["Back"].firstMatch
            editUserProfileVC_backButton.check(message: "\(accessibilityIdentifier) VC Back button \(messageCore)")
            
            //EditUserVC: Table View Cells
            let editUserProfileVC_username_cell = editUserProfileVC_table.cells.containing(.staticText, identifier:"Username").firstMatch
            editUserProfileVC_username_cell.check(message: "\(accessibilityIdentifier) VC Username cell \(messageCore)")
            
            let editUserProfileVC_fullname_cell = editUserProfileVC_table.cells.containing(.staticText, identifier:"Full name").firstMatch
             editUserProfileVC_fullname_cell.check(message: "\(accessibilityIdentifier) VC Full name cell \(messageCore)")
            
            let editUserProfileVC_bio_cell = editUserProfileVC_table.cells.containing(.staticText, identifier:"Bio").firstMatch
            editUserProfileVC_bio_cell.check(message: "\(accessibilityIdentifier) VC bio cell \(messageCore)")
            
            let editUserProfileVC_public_cell = editUserProfileVC_table.cells.containing(.staticText, identifier:"Public").firstMatch
            editUserProfileVC_public_cell.check(message: "\(accessibilityIdentifier) VC public cell \(messageCore)")
            
            let editUserProfileVC_changePasswordOption = editUserProfileVC_table.staticTexts["Change password"].firstMatch
            editUserProfileVC_changePasswordOption.check(message: "\(accessibilityIdentifier) VC change password cell \(messageCore)")
            
            //EditUserVC: Text Fields in Table View
            let editUserProfileVC_username_textField = editUserProfileVC_username_cell.children(matching: .textField).element.firstMatch
            
            editUserProfileVC_username_textField.typeText("4")
           
            editUserProfileVC_username_textField.check(message: "\(accessibilityIdentifier) VC Username text field \(messageCore)")
            
            let editUserProfileVC_fullname_textField = editUserProfileVC_fullname_cell.children(matching: .textField).element.firstMatch
            editUserProfileVC_fullname_textField.check(message: "\(accessibilityIdentifier) VC fullname text field \(messageCore)")
            
            //EditUserVC: Text Views in Table View
            let editUserProfileVC_bio_textView = editUserProfileVC_bio_cell.children(matching: .textView).element.firstMatch
            editUserProfileVC_bio_textView.check(message: "\(accessibilityIdentifier) VC bio text view \(messageCore)")
            
            //EditUserVC: Switches in Table View
            let editUserProfileVC_public_switch = editUserProfileVC_public_cell.children(matching: .switch).element.firstMatch
            editUserProfileVC_public_switch.check(message: "\(accessibilityIdentifier) VC public switch \(messageCore)")
            
            editUserProfileVC_backButton.forceTap()
        }else {
            let message = "FAILED:- \(accessibilityIdentifier):- testIfSelectModeratorVCLoads() failed ."
            XCTFail(message)
        }
    }
 */
    
    func testIfCreateInstanceLoads(userProfile_table: XCUIElement, selectModeratorsList_navBar: XCUIElement, createInstance_navBar: XCUIElement){
        let createInstanceOption = userProfile_table.staticTexts["Create Instance"].firstMatch
        createInstanceOption.tap()
    }
    
    //Must start test in SelectModeratorsListVC
    func testIfCreateInstanceVCLoads() {
        
        let accessibilityIdentifier = "CreateInstance"
        let messageCore = "failed while checking isHittable, isEnabled or exists."
        
        if let selectModeratorsListVC_returnElements = testIfSelectModeratorVCLoads(get: [.next, .back]) {
            
            let selectModeratorsListVC_nextButton = selectModeratorsListVC_returnElements.first
            let selectModeratorsListVC_backButton = selectModeratorsListVC_returnElements.last
            selectModeratorsListVC_nextButton?.forceTap()
            
            //title textfield, image, about text view, visibilty switch
            
            //CreateInstanceVC: Navigation Bar
            let createInstanceVC_navigationBar = app.navigationBars[accessibilityIdentifier].firstMatch
            createInstanceVC_navigationBar.check(message: "\(accessibilityIdentifier) VC Navigation Bar \(messageCore)")
            
            //CreateInstanceVC: Table View
            let createInstanceVC_table = app.tables[accessibilityIdentifier].firstMatch
            createInstanceVC_table.check(message: "\(accessibilityIdentifier) VC Table \(messageCore)")
            
            //CreateInstanceVC: Bar Button Items in Navigation Bar (Back and Done)
            let createInstanceVC_doneButton = createInstanceVC_navigationBar.buttons["Done"].firstMatch
            createInstanceVC_doneButton.check(message: "\(accessibilityIdentifier) VC Done button \(messageCore)")
            
            let createInstanceVC_backButton = createInstanceVC_navigationBar.buttons.element(boundBy: 0).firstMatch
            createInstanceVC_backButton.check(message: "\(accessibilityIdentifier) VC Back button \(messageCore)")
            
            //CreateInstanceVC: TextFields in Table View
            let createInstanceVC_title_cell = createInstanceVC_table.cells.containing(.staticText, identifier:"Title").firstMatch
            createInstanceVC_title_cell.check(message: "\(accessibilityIdentifier) VC Title cell \(messageCore)")
            
            let createInstanceVC_title_textField = createInstanceVC_title_cell.children(matching: .textField).element.firstMatch
            createInstanceVC_title_textField.check(message: "\(accessibilityIdentifier) VC Title text field \(messageCore)")
            
            //CreateInstanceVC: TextViews in Table View
            let createInstanceVC_about_cell = createInstanceVC_table.cells.containing(.staticText, identifier:"About").firstMatch
            createInstanceVC_about_cell.check(message: "\(accessibilityIdentifier) VC About cell \(messageCore)")
            
            let createInstanceVC_about_textField = createInstanceVC_about_cell.children(matching: .textView).element.firstMatch
            createInstanceVC_about_textField.check(message: "\(accessibilityIdentifier) VC About text view \(messageCore)")
            
            //CreateInstanceVC: Switches in Table View
            let createInstanceVC_visibility_cell = createInstanceVC_table.cells.containing(.staticText, identifier:"Visibility").firstMatch
            createInstanceVC_visibility_cell.check(message: "\(accessibilityIdentifier) VC Visibility cell \(messageCore)")
            
            let createInstanceVC_visibility_switch = createInstanceVC_visibility_cell.children(matching: .switch).element.firstMatch
            createInstanceVC_visibility_switch.check(message: "\(accessibilityIdentifier) VC Visibility switch \(messageCore)")
           
            
            //CreateInstanceVC: Other cells in TableView
            
            
            return
            
        }else {
            let message = "FAILED:- \(accessibilityIdentifier):- testIfSelectModeratorVCLoads() failed ."
            XCTFail(message)
        }
        
        
    }
    
    func testIfSelectModeratorVCLoads(get userProfileElements: [UserProfileElement]? = nil) -> [XCUIElement]? {
        let accessibilityIdentifier = "SelectModeratorsList"
        var returnElements: [XCUIElement] = []
        
        if let userProfile_table = testIfUserProfileVCLoads(userProfileElements: [.tableView])?.first {
            let messageCore = "failed while checking isHittable, isEnabled or exists."
            let staticText = "Create Instance"
            let option = userProfile_table.staticTexts[staticText].firstMatch
            option.check(message: "\(staticText):- \(messageCore)")
            option.tap()
            
            //SelectModeratorsListVC: Navigation Bar
            let selectModeratorsListVC_navigationBar = app.navigationBars[accessibilityIdentifier].firstMatch
            selectModeratorsListVC_navigationBar.check(message: "\(accessibilityIdentifier) VC Navigation Bar \(messageCore)")
            
            //SelectModeratorsListVC: Table View
            let selectModeratorsListVC_table = app.tables[accessibilityIdentifier].firstMatch
            selectModeratorsListVC_table.check(message: "\(accessibilityIdentifier) VC Table \(messageCore)")
        
            //SelectModeratorsListVC: Collection View
            let selectModeratorsListVC_collection = app.collectionViews["SelectModeratorsList"].firstMatch
            selectModeratorsListVC_collection.check(message: "\(accessibilityIdentifier) VC Table \(messageCore)")
            
            //SelectModeratorsListVC: Bar Button Items in Navigation Bar
            let selectModeratorsListVC_nextButton = selectModeratorsListVC_navigationBar.buttons["Next"].firstMatch
            selectModeratorsListVC_nextButton.check(message: "\(accessibilityIdentifier) VC Next button \(messageCore)")
            
            let selectModeratorsListVC_backButton = selectModeratorsListVC_navigationBar.buttons.element(boundBy: 0).firstMatch
            selectModeratorsListVC_backButton.check(message: "\(accessibilityIdentifier) VC Back button \(messageCore)")
            
            let tableCellsCount = selectModeratorsListVC_table.cells.count
            if tableCellsCount > 0 {
                for i in 0...(tableCellsCount - 1) {
                    let cell = selectModeratorsListVC_table.cells.element(boundBy: i)
                    cell.check(message: "\(accessibilityIdentifier) VC Cell no: \(i) \(messageCore)")
                    cell.tap()
                    if selectModeratorsListVC_collection.cells.count == 1 {
                        cell.tap()
                        if selectModeratorsListVC_collection.cells.count != 0 {
                            XCTFail("Failed: number of cells in table does not match collection")
                        }
                    }else {
                        XCTFail("Failed: number of cells in table does not match collection")
                    }
                }
            }
            
            if let userProfileElements = userProfileElements {
                
                for element in userProfileElements {
                    switch element {
                    case .navigationBar:
                        returnElements.append(selectModeratorsListVC_navigationBar)
                    case .next:
                        
                        returnElements.append(selectModeratorsListVC_nextButton)
                    case .tableView:
                        returnElements.append(selectModeratorsListVC_table)
                    case .back:
                        returnElements.append(selectModeratorsListVC_backButton)
                    default:
                        break
                    }
                }
                
                return returnElements
            }else {
                selectModeratorsListVC_backButton.forceTap()
                return nil
            }
            
        }else {
            let message = "FAILED:- \(accessibilityIdentifier):- testIfUserProfileVCLoads() failed ."
            XCTFail(message)
        }
        
        return nil
    }
    
    func testUserProfile(list type: UserListType){
        let messageCore = "failed while checking isHittable, isEnabled or exists."
        
        if let userProfile_table = testIfUserProfileVCLoads(userProfileElements: [.tableView])?.first {
            let option = userProfile_table.staticTexts[type.rawValue].firstMatch
            option.check(message: "\(type.rawValue):- \(messageCore)")
            option.tap()
            
            let profileListVC_navigationBar = app.navigationBars["ProfileList"].firstMatch
            profileListVC_navigationBar.check(message: "Profile List VC Navigation Bar \(messageCore)")
            
            let profileListVC_table = app.tables["ProfileList"].firstMatch
            profileListVC_table.check(message: "Profile List VC Table \(messageCore)")
        
            if type == .instances || type == .moderating {
                let profileListVC_dateSegment = profileListVC_navigationBar.buttons["Date"].firstMatch
                profileListVC_dateSegment.check(message: "Profile List VC Date Segment \(messageCore)")
                
                let profileListVC_alphabeticalSegment = profileListVC_navigationBar.buttons["Alphabetical"].firstMatch
                profileListVC_alphabeticalSegment.check(message: "Profile List VC Alphabetical Segment \(messageCore)")
                
            }else if type == .followers {
                let profileListVC_followersSegment = profileListVC_navigationBar.buttons["Followers"].firstMatch
                profileListVC_followersSegment.check(message: "Profile List VC Followers Segment \(messageCore)")
                
                let profileListVC_requestedSegment = profileListVC_navigationBar.buttons["Requested"].firstMatch
                profileListVC_requestedSegment.check(message: "Profile List VC Requested Segment \(messageCore)")
                
            }else if type == .following {
                let profileListVC_followingSegment = profileListVC_navigationBar.buttons["Following"].firstMatch
                profileListVC_followingSegment.check(message: "Profile List VC Following Segment \(messageCore)")
                
                let profileListVC_pendingSegment = profileListVC_navigationBar.buttons["Pending"].firstMatch
                profileListVC_pendingSegment.check(message: "Profile List VC Pending Segment \(messageCore)")
                
            }
    
            profileListVC_table.swipeDown()
            
            app.searchFields["Search"].tap()
            app/*@START_MENU_TOKEN@*/.otherElements["PopoverDismissRegion"]/*[[".otherElements[\"dismiss popup\"]",".otherElements[\"PopoverDismissRegion\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            
            let profileListVC_backButton = profileListVC_navigationBar.buttons.element(boundBy: 0).firstMatch
            profileListVC_backButton.check(message: "Profile List VC Back button \(messageCore)")
            profileListVC_backButton.tap()
            
            return
        }
        
        let message = "FAILED:- \(type.rawValue) testIfUserProfileVCLoads() failed ."
        XCTFail(message)
    }
    
    //This method tests the lists (instances, moderating, following, followers and journal) with the user profile vc being the starting vc.
    func testIfAllUserListLoads(){
        let lists: [UserListType] = [.instances, .moderating, .following, .followers, .journal]
        for list in lists {
            testUserProfile(list: list)
        }
        
    }
    
    
    
    func testIfInstanceProfileVCLoads(){
        //1 load user profile and get table
        //2 force tap create instance
        
        testIfCreateInstanceVCLoads()
        
        if let createInstanceVC_doneButton = createSampleInstance(get: [.done])?.first {
            createInstanceVC_doneButton.forceTap()
            
            if let userProfileVC_table = testIfUserProfileVCLoads(userProfileElements: [.tableView])?.first {
                testUserProfile(list: .instances)
                
                let instances_Option = userProfileVC_table.staticTexts["Instances"].firstMatch
                instances_Option.forceTap()
                
                let profileListVC_navigationBar = app.navigationBars["ProfileList"].firstMatch
                let profileListVC_table = app.tables["ProfileList"].firstMatch
                let profileListVC_backButton = profileListVC_navigationBar.buttons.element(boundBy: 0).firstMatch
                profileListVC_backButton.check(message: "Profile List VC Back Button \(messageCore)")
                
                
                let sampleInstanceOption = profileListVC_table.cells.containing(.staticText, identifier:"Sample Instance").firstMatch
                
                sampleInstanceOption.forceTap()
                //no we go into Instance Profile TV because its an instance
                
                let accessibilityIdentifier = "ThreadProfileVC"
            
                //InstanceProfileVC: Navigation Bar
            
                let instanceProfileVC_navBar = app.navigationBars.matching(identifier: accessibilityIdentifier).firstMatch
                instanceProfileVC_navBar.check(message: "\(accessibilityIdentifier) VC Navigation Bar \(messageCore)")
                
                //InstanceProfileVC: Table
                let instanceProfileVC_table = app.tables.matching(identifier: accessibilityIdentifier).firstMatch
                instanceProfileVC_table.check(message: "\(accessibilityIdentifier) VC Table \(messageCore)")
                
                //InstanceProfileVC: Bar Button Items in Navigation Bar (share and bookmark)
                let instanceProfileVC_shareButton = instanceProfileVC_navBar.buttons.matching(identifier: "ShareState").firstMatch
                instanceProfileVC_shareButton.check(message: "\(accessibilityIdentifier) ShareState \(messageCore)")
                
                let instanceProfileVC_bookmarkButton = instanceProfileVC_navBar.buttons.matching(identifier: "BookmarkState").firstMatch
                instanceProfileVC_bookmarkButton.check(message: "\(accessibilityIdentifier) BookmarkState \(messageCore)")
                
                //InstanceProfileVC: First Cell (which is title)
                let instanceProfileVC_title_cell = instanceProfileVC_table.cells.element(boundBy: 0).firstMatch
                instanceProfileVC_title_cell.check(message: "\(accessibilityIdentifier) Title Cell \(messageCore)")
                
                //InstanceProfileVC: Second Cell (which is image)
                let instanceProfileVC_instanceImage_cell = instanceProfileVC_table.cells.element(boundBy: 1).firstMatch
                instanceProfileVC_instanceImage_cell.check(message: "\(accessibilityIdentifier) Instance Image Cell \(messageCore)")
                
                //InstanceProfileVC: About TextView
                let instanceProfileVC_about_cell = instanceProfileVC_table.cells.containing(.staticText, identifier: "About").firstMatch
                instanceProfileVC_about_cell.check(message: "\(accessibilityIdentifier) Instance About Cell \(messageCore)")
                
                let instanceProfileVC_about_textView = instanceProfileVC_about_cell.children(matching: .textView).firstMatch
                instanceProfileVC_about_textView.check(message: "\(accessibilityIdentifier) Instance About Cell \(messageCore)")
                
                //InstanceProfileVC: Delete Cell
                let instanceProfileVC_delete_cell = instanceProfileVC_table.cells.containing(.staticText, identifier: "Delete").firstMatch
                instanceProfileVC_delete_cell.check(message: "\(accessibilityIdentifier) Instance Delete Cell \(messageCore)")
              
                instanceProfileVC_delete_cell.forceTap()
                
                let deleteInstanceSheet = app.sheets["Delete Instance?"].firstMatch
                deleteInstanceSheet.check(message: "Delete Instance Sheet \(messageCore)")
                
                let deleteInstanceSheet_yesButton = deleteInstanceSheet.buttons["Yes"].firstMatch
                deleteInstanceSheet_yesButton.check(message: "Delete Instance Sheet Yes Button \(messageCore)")
                
                deleteInstanceSheet_yesButton.forceTap()
                profileListVC_backButton.forceTap()
                
            }
            
        }
    }
    
    
    
    func createSampleInstance(get userProfileElements: [UserProfileElement]? = nil) -> [XCUIElement]? {
    
        let accessibilityIdentifier = "CreateInstance"
        
        //No checks required
        
        //CreateInstance: Navigation Bar
        let createInstanceVC_navigationBar = app.navigationBars[accessibilityIdentifier].firstMatch
        
        //CreateInstanceVC: Table View
        let createInstanceVC_table = app.tables[accessibilityIdentifier].firstMatch
        
        //CreateInstanceVC: Bar Button Items in Navigation Bar (Back and Done)
        let createInstanceVC_doneButton = createInstanceVC_navigationBar.buttons["Done"].firstMatch
    
        //CreateInstanceVC: TextFields in Table View
        let createInstanceVC_title_textField = createInstanceVC_table.cells.containing(.staticText, identifier:"Title").children(matching: .textField).element.firstMatch
        
        createInstanceVC_title_textField.forceTap()
        createInstanceVC_title_textField.typeText("Sample Instance")
        
        //CreateInstanceVC: TextViews in Table View
        let createInstanceVC_about_cell = createInstanceVC_table.cells.containing(.staticText, identifier:"About").children(matching: .textView).element.firstMatch
        createInstanceVC_about_cell.forceTap()
        createInstanceVC_about_cell.typeText("This is a sample instance for testing purposes")
        
        //CreateInstanceVC: Switches in Table View
        let createInstanceVC_visibility_cell = createInstanceVC_table.cells.containing(.staticText, identifier:"Visibility").children(matching: .switch).element.firstMatch
        createInstanceVC_visibility_cell.forceTap()
        createInstanceVC_visibility_cell.forceTap()
        
        guard userProfileElements != nil else {
            return nil
        }
        
        var returnElements: [XCUIElement] = []
        
        for element in userProfileElements! {
            switch element {
            case .done:
                returnElements.append(createInstanceVC_doneButton)
                break
            default:
                break
            }
        }
        
        return returnElements
    }
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
*/
