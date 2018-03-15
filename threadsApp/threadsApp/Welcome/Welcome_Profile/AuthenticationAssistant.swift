//
//  AuthenticationAssistant.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 6/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import CoreData
import Firebase

protocol AuthenticationAssistantProtocol {
    func setupHandle(completion: @escaping (AuthenticationAssistant.Feedback, User?, Error?) -> Void)
}

class MockAuthenticationAssistant: AuthenticationAssistantProtocol {
    
    private var _expectedFeedback: AuthenticationAssistant.Feedback
    var expectedFeedback: AuthenticationAssistant.Feedback {
        return _expectedFeedback
    }

    private var _user: User?
    var user: User? {
        return _user
    }
    
    private var _error: Error?
    var error: Error? {
        return _error
    }
    
    init(expectedFeedback: AuthenticationAssistant.Feedback, user: User? = nil, error: Error? = nil) {
        _expectedFeedback = expectedFeedback
        _user = user
        _error = error
    }
    
    func setupHandle(completion: @escaping (AuthenticationAssistant.Feedback, User?, Error?) -> Void) {
        completion(expectedFeedback, user, error)
        return
    }
}

class AuthenticationAssistant: AuthenticationAssistantProtocol {
    
    internal enum Feedback {
        case foundNoActiveUser
        case foundActiveUser
        case noActiveUser
        case foundNoActiveUserWithErr
    }
    
    private var _handle: AuthStateDidChangeListenerHandle?
    var handle: AuthStateDidChangeListenerHandle? {
        return _handle
    }
    
    //test later
    func setupHandle(completion: @escaping (AuthenticationAssistant.Feedback, User?, Error?) -> Void){
        
        _handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            
            if user != nil {
                
                if let userId = user?.uid, let context = ThreadsData.sharedInstance.container?.viewContext {
                    
                    User.get(userId: userId, context: context, strings: Constants.sharedInstance, completion: { (user, error) in
                        
                        if let user = user.0 {
                            
                            completion(.foundActiveUser, user, error)
                        }else {
                            if let error = error {
                                completion(.foundNoActiveUserWithErr, nil, error)
                            }else {
                                completion(.foundNoActiveUser,  nil, error)
                            }
                            return
                        }
                    })
                }
                
            }else {
                completion(.noActiveUser, nil, nil)
                return
            }
        })
    }
}
