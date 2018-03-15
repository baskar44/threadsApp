//
//  Photo+ext+Connections.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 25/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import CoreData
import Firebase

extension Photo {
 
    func connectCore(context: NSManagedObjectContext, completion: @escaping (Bool, Error?) -> Void){
        
        guard let photoId = id else {
            completion(false, nil)
            return
        }
        
        coreReference?.removeAllObservers()
        coreReference = database.child(s_._Photo).child(photoId)
        
        coreReference?.observe(.value, with: { (snapshot) in
            if let core = snapshot.value as? NSDictionary {
                
                guard let imageName = core[self.s_._imageName] as? String, let createdDateString = core[self.s_._createdDate] as? String, let parentKey = core[self.s_._parentKey] as? String, let createdBy = core[self.s_._createdBy] as? String, let visibility = core[self.s_._visibility] as? Bool else{
                    return
                }
                
                guard let createdDate = ThreadsData.getDate(for: createdDateString) else {
                    completion(false, nil)
                    return
                }
                
                let about = core[self.s_._about] as? String
                
                self.setValue(createdDate, forKey: self.s_._createdDate)
                self.setValue(about, forKey: self.s_._about)
                self.setValue(visibility, forKey: self.s_._visibility)
                
                User.get(userId: createdBy, context: context, strings: self.s_, completion: { (creator, error) in
                    if let creator = creator.0 {
                        self.setValue(creator, forKey: self.s_._creator)
                        
                        Thread_.get(threadId: parentKey, context: context, completion: { (parent, error) in
                            if let parent = parent.0 {
                                
                                self.setValue(parent, forKey: self.s_._parent)
                                
                                let storage = Storage.storage().reference().child("Images")
                                storage.child("\(imageName).jpeg").downloadURL(completion: { (url, error) in
                                    if let url = url {
                                        
                                        let absoluteString = url.absoluteString
                                        
                                        self.setValue(absoluteString, forKey: self.s_._imageURL)
                                        
                                         ThreadsData.sharedInstance.loadImageUsingCacheWithURLString(imageURL: absoluteString, onCompletion: { (image, error) in })
                                        
                                        self.saveToContext(context: context, onCompletion: { (didSave, error) in
                                            completion(didSave, error)
                                        })
                                    }else {
                                        self.saveToContext(context: context, onCompletion: { (didSave, error) in
                                            completion(didSave, error)
                                        })
                                    }
                                    
                                    if let error = error {
                                        completion(false, error)
                                        return
                                    }
                                })
                            }
                            
                            if let error = error {
                                completion(false, error)
                                return
                            }
                        })
                    }
                    
                    if let error = error {
                        completion(false, error)
                        return
                    }
                })
            }
        }, withCancel: { (error) in
            completion(false, error)
            return
        })
    }
}
