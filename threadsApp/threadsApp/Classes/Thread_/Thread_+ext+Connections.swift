//
//  Instance+ext+Connections.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 21/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import CoreData
import Firebase

extension Thread_ {
    
    func connectCore(context:NSManagedObjectContext, strings: Constants, completion: @escaping (Feedback, Error?) -> Void){
        
        guard let id = self.id else {
            return
        }
        
        coreReference = database.child(strings._Thread_).child(id)
        
        coreReference?.observe(.value, with: { (snapshot) in
            
            guard let core = snapshot.value as? NSDictionary else {
                completion(.failedWhileConnectingCore, nil)
                return
            }
            
            guard let title = core[strings._title] as? String, let createdDateString = core[strings._createdDate] as? String, let visibility = core[strings._visibility] as? Bool, let createdBy = core[strings._createdBy] as? String else {
                return
            }
            
            guard let createdDate = ThreadsData.getDate(for: createdDateString) else {
                return
            }
            
            let about = core[strings._about] as? String ?? strings._emptyString
            
            self.setValue(title, forKey: strings._title)
            self.setValue(createdDate, forKey: strings._createdDate)
            self.setValue(visibility, forKey: strings._visibility)
            self.setValue(about, forKey: strings._about)

            User.get(userId: createdBy, context: context, strings: strings, completion: { (user, error) in
                
                let feedback = user.1
                
                if feedback == .successful {
                    if let creator = user.0 {
                        self.setValue(creator, forKey: strings._creator)
                        self.saveToContext(context: context, onCompletion: { (didSave, error) in
                            if didSave {
                                completion(.successful, nil)
                            }else {
                                completion(.failedWhileSavingToContext, error)
                            }
                            return
                        })
                    }
                }else {
                    completion(feedback, error)
                    return
                }
            })
            
        }, withCancel: { (error) in
            completion(.failedWhileObserving, error)
            return
        })
    }
}
