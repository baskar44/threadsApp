//
//  UITextView+ext.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 2/11/17.
//  Copyright © 2017 Gururaj Baskaran. All rights reserved.
//

import UIKit

enum TextViewType {
    case content
    case title
}

extension UITextView {
    
    func setTo(textViewType: TextViewType){
        switch textViewType {
        case .content:
            textColor = .black
            font = UIFont.boldSystemFont(ofSize: 18)
            break
        case .title:
            textColor = .black
            font = UIFont.systemFont(ofSize: 18)
            break
        }
    }
    
    //Tested 26/2/2018
    public func checkIfEmpty() -> Bool {
        if self.text == Constants.sharedInstance._emptyString {
            return true
        }else {
            return false
        }
    }
    
    //Tested 26/2/2018
    public func checkIfBelowWordCount(limit: Int) -> Bool {
        if self.wordCount() <= limit {
            return true
        }else {
            return false
        }
    }
    
    //Tested 26/2/2018
    public func getLabelText(maximum noOfWords: Int) -> String {
        return "\(self.wordCount())/\(noOfWords)"
        
    }
    
    
    //Tested 26/2/2018
    public func wordCount() -> Int {
        let words = text.components(separatedBy: NSCharacterSet.whitespaces)
        var wordDictionary: [String: Int] = [:]
        
        for word in words {
            if word != Constants.sharedInstance._emptyString {
                if let count = wordDictionary[word] {
                    wordDictionary[word] = count + 1
                }else {
                    wordDictionary[word] = 1
                }
            }
        }
        
        var textWordCount: Int = 0
        
        for key in wordDictionary.keys {
            if key.last != nil {
                if let noOfOccurrences = wordDictionary[key] {
                    textWordCount =  textWordCount + noOfOccurrences
                }
            }
        }
      
        return textWordCount
    }
    
    
}
