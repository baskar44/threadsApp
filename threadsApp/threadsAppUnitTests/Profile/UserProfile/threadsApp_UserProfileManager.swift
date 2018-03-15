//
//  threadsApp_UserProfileManager.swift
//  threadsAppUnitTests
//
//  Created by Gururaj Baskaran on 27/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import XCTest

@testable import threadsApp

class threadsApp_UserProfileManager: XCTestCase {
    
    var userProfileManager: UserProfileManager!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let userStructure = UserStructure(id: "Dummy", createdDate: Date(), createdDateString: "Dummy", visibility: true, username: "Dummy", fullname: "Dummy", bio: "Dummy", profileImageURL: "Dummy")
        
        userProfileManager = UserProfileManager(employedBy: userStructure, selectedUserStructure: userStructure)
        
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
    
    func testGetUserAccessLevel(){
        
        
        
    }
    
    
    
    
}
