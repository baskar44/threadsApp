//
//  threadsApp_TextView.swift
//  threadsAppUnitTests
//
//  Created by Gururaj Baskaran on 26/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import XCTest

class threadsApp_TextView: XCTestCase {
    
    var emptyTextView: UITextView!
    var filledTextView: UITextView!
    
    override func setUp() {
        super.setUp()
        emptyTextView = UITextView()
        filledTextView = UITextView()
        filledTextView.text = "Not empty"
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testCheckIfEmpty() {
        
         let textViews: [UITextView] = [emptyTextView, filledTextView]
         
         for textView in textViews {
            if textView == emptyTextView {
                XCTAssert(textView.checkIfEmpty())
            }else if textView == filledTextView {
                XCTAssertFalse(textView.checkIfEmpty())
            }
         }
        
    }
    
    func testCheckIfBelowWordCount(){
        let textViews: [UITextView] = [emptyTextView, filledTextView]
        let limits = [0, 1, 2, 3]
        
        for textView in textViews {
            for limit in limits {
                if textView == emptyTextView {
                    let result = textView.checkIfBelowWordCount(limit: limit)
                    
                    switch limit {
                    case 0:
                        XCTAssert(result)
                        break
                    case 1:
                        XCTAssert(result)
                        break
                    case 2:
                        XCTAssert(result)
                        break
                    case 3:
                        XCTAssert(result)
                        break
                    default:
                        break
                    }
                   
                }else if textView == filledTextView {
                    let result = textView.checkIfBelowWordCount(limit: limit)
                    
                    switch limit {
                    case 0:
                        XCTAssertFalse(result)
                        break
                    case 1:
                        XCTAssertFalse(result)
                        break
                    case 2:
                        XCTAssert(result)
                        break
                    case 3:
                        XCTAssert(result)
                    default:
                        break
                    }
                }
            }
            
        }
    }
    
    func testGetLabelText(){
        
        let textViews: [UITextView] = [emptyTextView, filledTextView]
        let maximumNumberOfWordsInList = [0, 100, 200]
        
        for textView in textViews {
            for noOfWords in maximumNumberOfWordsInList {
                let result = textView.getLabelText(maximum: noOfWords)
                XCTAssertEqual(result, "\(textView.wordCount())/\(noOfWords)")
            }
        }
    }
    
    func testWordCount(){
        let textViews: [UITextView] = [emptyTextView, filledTextView]
        
        for textView in textViews {
            
            let wordCount = textView.wordCount()
            
            if textView == emptyTextView {
                XCTAssertEqual(wordCount, 0)
            }else if textView == filledTextView {
                XCTAssertEqual(wordCount, 2)
            }
        }
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
    
}
