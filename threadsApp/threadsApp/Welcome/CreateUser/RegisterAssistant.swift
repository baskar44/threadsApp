//
//  RegisterAssistant.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 5/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit

struct RegisterAssistant: RegisterAssistantProtocol {
    
    private var _email: UITextField
    var email: UITextField {
        return _email
    }
    
    private var _username: UITextField
    var username: UITextField {
        return _username
    }
    
    private var _password: UITextField
    var password: UITextField {
        return _password
    }
    
    private var _confirmPassword: UITextField
    var confirmPassword: UITextField {
        return _confirmPassword
    }
    
    private var _strings: Constants
    var strings: Constants {
        return _strings
    }
    
    init(email: UITextField, username: UITextField, password: UITextField, confirmPassword: UITextField, strings: Constants) {
        _email = email
        _username = username
        _password = password
        _confirmPassword = confirmPassword
        _strings = strings
    }
    
    func register(completion: @escaping (CreateUserVC.CreateUserFailedType?) -> Void) {
        
        guard let email = email.text, let password = password.text, let confirmPassword = confirmPassword.text, let username = username.text else {
            completion(.failedToLoadTextFieldUI)
            return
        }
        
        if email == strings._emptyString || password == strings._emptyString || confirmPassword == strings._emptyString || username == strings._emptyString {
            completion(.invalidRequiredFields)
            return
            
        }else {
            
            guard password == confirmPassword else {
                completion(.passwordMismatch)
                return
            }
            
            ThreadsData.sharedInstance.register(email: email, password: password, username: username, on: { (didRegister, error) in
                if didRegister {
                    completion(nil)
                }else {
                    completion(.failedToRegister)
                }
                return
            })
        }
    }
}

struct MockRegisterAssistant: RegisterAssistantProtocol {
    
    private var _expectedResponse: CreateUserVC.CreateUserFailedType
    var expectedResponse: CreateUserVC.CreateUserFailedType {
        return _expectedResponse
    }
    
    init(expectedResponse: CreateUserVC.CreateUserFailedType) {
        _expectedResponse = expectedResponse
    }
    
    func register(completion: @escaping (CreateUserVC.CreateUserFailedType?) -> Void) {
        completion(expectedResponse)
    }
}


protocol RegisterAssistantProtocol {
    func register(completion: @escaping (CreateUserVC.CreateUserFailedType?) -> Void)
}

