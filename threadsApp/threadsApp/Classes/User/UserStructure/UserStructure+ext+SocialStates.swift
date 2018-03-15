//
//  UserStructure+ext+SocialStates.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 2/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import Firebase

//Follow states
extension UserStructure {
    
    //comments
    func unfollow(selectedUserStructure: UserStructureProtocol, completion: @escaping (Feedback, Error?) -> Void) {
        
        guard let context = context else {
            completion(.failedWhileGettingContext, nil)
            return
        }
        
        let dictionary = getLogRelatedItemValuesAndId(.unFollow, object: selectedUserStructure, strings: strings)
        
        guard let journalItemValues = dictionary[strings._JournalItem] else {
            completion(.failedToGetLog, nil)
            return
        }
        
        self.performUpdate(itemValuesAndId: journalItemValues, type: .journal, context: context) { (feedback, error) in
            if feedback == .successful {
                
                User.get(userId: self.id, context: context, strings: self.strings, completion: { (user, error) in
                    if let currentUser = user.0 {
                        
                        User.get(userId: selectedUserStructure.id, context: context, strings: self.strings, completion: { (user, error) in
                            if let selectedUser = user.0 {
                                currentUser.initiate(action: .remove, in: .following, objectId: selectedUserStructure.id, context: context, strings: self.strings, completion: { (feedback, error) in
                                    
                                    if feedback == .successful && error == nil {
                                        
                                        selectedUser.initiate(action: .remove, in: .followers, objectId: self.id, context: context, strings: self.strings, completion: { (feedback, error) in
                                            
                                            if feedback == .successful && error == nil {
                                                self.database.child(self.strings._Following).child(self.id).child(selectedUserStructure.id).removeValue()
                                                self.database.child(self.strings._Followers).child(selectedUserStructure.id).child(self.id).removeValue()
                                                completion(feedback, error)
                                            }else {
                                                completion(feedback, error)
                                            }
                                            
                                            return
                                            
                                        })
                                        
                                    }else {
                                        completion(feedback, error)
                                        return
                                    }
                                    
                                })
                                
                            }else {
                                completion(.failedWhileChangingSocialState, error)
                                return
                            }
                        })
                        
                    }else {
                        completion(.failedWhileChangingSocialState, error)
                        return
                    }
                })
                
               
            }else {
                completion(feedback, error)
                return
            }
        }
    }
    
    //comments
    func follow(selectedUserStructure: UserStructureProtocol, completion: @escaping (Feedback, Error?) -> Void) {
        
        guard let context = context else {
            completion(.failedWhileGettingContext, nil)
            return
        }
        
        //1 check if user B is visibile
        if selectedUserStructure.visibility {
            //1a if visibile user A can start following B
           
            let dictionary = getLogRelatedItemValuesAndId(.follow, object: selectedUserStructure, strings: strings)
            
            guard let journalItemValues = dictionary[strings._JournalItem] else {
                completion(.failedToGetLog, nil)
                return
            }
            
            self.performUpdate(itemValuesAndId: journalItemValues, type: .journal, context: context) { (feedback, error) in
                if feedback == .successful {
                    self.database.child(self.strings._Following).child(self.id).child(selectedUserStructure.id).setValue(true)
                    self.database.child(self.strings._Followers).child(selectedUserStructure.id).child(self.id).setValue(true)
                    
                    completion(.successful, nil)
                }else {
                    completion(.failedWithChangingShareState, error)
                    return
                }
            }
        }else {
            //1b else
            //2 send request to user B from user A
            let dictionary = getLogRelatedItemValuesAndId(.follow, object: selectedUserStructure, strings: strings)
            
            guard let journalItemValues = dictionary[strings._JournalItem] else {
                completion(.failedToGetLog, nil)
                return
            }
            
            self.performUpdate(itemValuesAndId: journalItemValues, type: .journal, context: context) { (feedback, error) in
                if feedback == .successful {
                    self.database.child(self.strings._Requested).child(self.id).child(selectedUserStructure.id).setValue(true)
                    self.database.child(self.strings._Pending).child(selectedUserStructure.id).child(self.id).setValue(true)
                    
                    completion(.successful, nil)
                }else {
                    completion(.failedWithChangingShareState, error)
                    return
                }
            }
        }
    }
    
    
    //comments
    func cancelPending(selectedUserStructure: UserStructureProtocol, completion: @escaping (Feedback, Error?) -> Void) {
        
        guard let context = context else {
            completion(.failedWhileGettingContext, nil)
            return
        }
        
        let dictionary = getLogRelatedItemValuesAndId(.cancelPending, object: selectedUserStructure, strings: strings)
        
        guard let journalItemValues = dictionary[strings._JournalItem] else {
            completion(.failedToGetLog, nil)
            return
        }
        
        self.performUpdate(itemValuesAndId: journalItemValues, type: .journal, context: context) { (feedback, error) in
            if feedback == .successful {
                
                self.database.child(self.strings._Pending).child(self.id).child(selectedUserStructure.id).removeValue()
                self.database.child(self.strings._Requested).child(selectedUserStructure.id).child(self.id).removeValue()
                
                completion(.successful, nil)
            }else {
                completion(.failedWithChangingShareState, error)
                return
            }
        }
    }
    
    //comments
    func acceptPending(selectedUserStructure: UserStructureProtocol, completion: @escaping (Feedback, Error?) -> Void) {
        
        guard let context = context else {
            completion(.failedWhileGettingContext, nil)
            return
        }
        
        let dictionary = selectedUserStructure.getLogRelatedItemValuesAndId(.acceptPending, object: selectedUserStructure, strings: strings)
        
        guard let journalItemValues = dictionary[strings._JournalItem] else {
            completion(.failedToGetLog, nil)
            return
        }
        
        self.performUpdate(itemValuesAndId: journalItemValues, type: .journal, context: context) { (feedback, error) in
            if feedback == .successful {
                
                //1 remove user B from pending
                self.database.child(self.strings._Pending).child(self.id).child(selectedUserStructure.id).removeValue()
                self.database.child(self.strings._Requested).child(selectedUserStructure.id).child(self.id).removeValue()
                
                //2 add user B to user A's followers list
                self.database.child(self.strings._Followers).child(self.id).child(selectedUserStructure.id).setValue(true)
                self.database.child(self.strings._Following).child(selectedUserStructure.id).child(self.id).setValue(true)
                
                completion(.successful, nil)
            }else {
                completion(.failedWithChangingShareState, error)
                return
            }
        }
        
       
    }
    
    //comments
    func withdrawRequest(selectedUserStructure: UserStructureProtocol, completion: @escaping (Feedback, Error?) -> Void) {
        
        guard let context = context else {
            completion(.failedWhileGettingContext, nil)
            return
        }
        
        let dictionary = getLogRelatedItemValuesAndId(.withdrawRequest, object: selectedUserStructure, strings: strings)
        
        guard let journalItemValues = dictionary[strings._JournalItem] else {
            completion(.failedToGetLog, nil)
            return
        }
        
        self.performUpdate(itemValuesAndId: journalItemValues, type: .journal, context: context) { (feedback, error) in
            if feedback == .successful {
                
                //1 remove user B from user A's requested
                //2 remove user A from user B's pending
                self.database.child(self.strings._Requested).child(self.id).child(selectedUserStructure.id).removeValue()
                self.database.child(self.strings._Pending).child(selectedUserStructure.id).child(self.id).removeValue()
                
                completion(.successful, nil)
            }else {
                completion(.failedWithChangingShareState, error)
                return
            }
        }
        
       
    }
}
