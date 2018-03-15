//
//  LoginAssistant.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 6/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import Firebase
import UIKit


struct LoginAssistant: LoginAssistantProtocol {
    
    private var _email: UITextField
    var email: UITextField {
        return _email
    }
    
    private var _password: UITextField
    var password: UITextField {
        return _password
    }
    
    private var _strings: Constants
    var strings: Constants {
        return _strings
    }
    
    init(email: UITextField, password: UITextField) {
        _email = email
        _password = password
        _strings = Constants.sharedInstance
    }
    
    func login(completion: @escaping (LoginVC.LoginVCFailedType?) -> Void) {
        
        guard let email = email.text, let password = password.text else {
            completion(.requiredFieldsDoesNotExist)
            return
        }
        
        if email == strings._emptyString || password == strings._emptyString {
            completion(.requiredFieldsIncomplete)
        }else {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    completion(.loginFailedWithError)
                }else {
                    if user != nil {
                        
                        completion(nil)
                    }else {
                        completion(.loginFailedWithoutError)
                    }
                    
                    return
                }
            }
        }
    }
}

struct MockLoginAssistant: LoginAssistantProtocol {
    
    internal enum Expectation {
        case requiredFieldsIncomplete
        case requiredFieldsDoesNotExist
        case loginFailedWithError
        case loginFailedWithoutError
    }
    
    private var _expectation: Expectation
    var expectation: Expectation {
        return _expectation
    }
    
    init(expectation: Expectation) {
        _expectation = expectation
    }
    
    func login(completion: @escaping (LoginVC.LoginVCFailedType?) -> Void) {
        switch expectation {
        case .requiredFieldsIncomplete:
            completion(.requiredFieldsIncomplete)
            return
        case .loginFailedWithError:
            completion(.loginFailedWithError)
            return
        case .loginFailedWithoutError:
            completion(.loginFailedWithoutError)
            return
        case .requiredFieldsDoesNotExist:
            completion(.requiredFieldsDoesNotExist)
            return
        }
        
        completion(nil)
        return
    }
}

protocol LoginAssistantProtocol {
    func login(completion: @escaping (LoginVC.LoginVCFailedType?) -> Void)
}
