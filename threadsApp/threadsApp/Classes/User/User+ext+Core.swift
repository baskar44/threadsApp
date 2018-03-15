//
//  User+ext+Core.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 18/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import CoreData
import Firebase

extension User {
    //Function: Connects the core attributes for a functioning USER.
 
    func connectCore(context: NSManagedObjectContext, strings: Constants, completion: @escaping (Feedback, Error?) -> Void){
        
        guard let userId = id else {
            completion(.failedWhileAttemptingToSetId, nil)
            return
        }
        
        coreReference?.removeAllObservers()
        coreReference = database.child(strings._User).child(userId)
        
        coreReference?.observe(.value, with: { (snapshot) in
            guard let core = snapshot.value as? NSDictionary else {
                completion(.failedWhileCallingBackend, nil)
                return
            }
            
            guard let username = core[strings._username] as? String, let visibility = core[strings._visibility] as? Bool, let createdDateString = core[strings._createdDate] as? String else {
                completion(.failedToGetTheRequiredAttributes, nil)
                return
            }
            
            guard let createdDate = ThreadsData.getDate(for: createdDateString) else {
                completion(.failedToCreateCreatedDateString, nil)
                return
            }
    
            let bio = core[strings._bio] as? String ?? strings._emptyString
            let fullname = core[strings._fullname] as? String ?? strings._emptyString
            let profileImageName = core[strings._profileImage] as? String ?? strings._emptyString
            
            self.setValue(username, forKey: strings._username)
            self.setValue(visibility, forKey: strings._visibility)
            self.setValue(createdDate, forKey: strings._createdDate)
            self.setValue(bio, forKey: strings._bio)
            self.setValue(fullname, forKey: strings._fullname)
            
            if profileImageName != strings._emptyString {
                let storage = Storage.storage().reference().child(strings._Images)
                storage.child(profileImageName.makeIntoJpegString()).downloadURL(completion: { (url, error) in
                    if let url = url {
                        let absoluteString = url.absoluteString
                        self.setValue(absoluteString, forKey: strings._profileImageURL)
                        ThreadsData.sharedInstance.loadImageUsingCacheWithURLString(imageURL: absoluteString, onCompletion: { (image, error) in })
                    }else {
                        self.setValue(strings._emptyString, forKey: strings._profileImageURL)
                    }

                    
                    self.saveToContext(context: context, onCompletion: { (didSaveToContext, error) in
                        completion(.successful, error)
                        if !didSaveToContext {
                            return
                        }
                    })
                })
            }else {
                self.setValue(strings._emptyString, forKey: strings._profileImageURL)
                self.saveToContext(context: context, onCompletion: { (didSaveToContext, error) in
                    completion(.successful, error)
                    if !didSaveToContext {
                        return
                    }
                })
            }
        }, withCancel: { (error) in
            completion(.failedWhileObserving, error)
            return
        })
    }
}

extension String {
    
    func makeIntoJpegString() -> String {
        return "\(self).jpeg"
    }
}
