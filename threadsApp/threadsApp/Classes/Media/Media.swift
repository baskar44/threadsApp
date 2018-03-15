//
//  Media.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 12/12/17.
//  Copyright © 2017 Gururaj Baskaran. All rights reserved.
//


import CoreData
import Firebase


class Media: Object {
    
    /*
    
    func connectCreator(context:NSManagedObjectContext, onCompletion: @escaping (Bool, Error?) -> Void){
        
        guard let threadId = id else {
            onCompletion(false, nil)
            return
        }
        
        var path: String?
        
        if self is Thread_{
            path = s_._Thread_
        }else if self is Photo {
            path = s_._Photo
        }else if self is Film {
            path = s_._Film
        }else if self is Audio {
            path = s_._Audio
        }
        
        guard let pathString = path else {
            onCompletion(false, nil)
            return
        }
        
        creatorReference?.removeAllObservers()
        creatorReference = nil
        creatorReference = database.child(pathString).child(threadId).child(s_._createdBy)
        
        creatorReference?.observeSingleEvent(of: .value, with: { (snapshot) in
            if let createdBy = snapshot.value as? String {
                
                User.get(userId: createdBy, context: context, completion: { (creator, error) in
                    if let creator = creator {
                        self.setValue(creator, forKey: self.s_._creator)
                        
                        self.saveToContext(context: context, onCompletion: { (didSaveToContext, error) in
                            onCompletion(didSaveToContext, error)
                        })
                    }
                    
                    if let error = error {
                        onCompletion(false, error)
                    }else {
                        onCompletion(false, nil)
                    }
                    
                    return
                })
                
            }
        }) { (error) in
            onCompletion(false, error)
            return
        }
    }
    */
}
