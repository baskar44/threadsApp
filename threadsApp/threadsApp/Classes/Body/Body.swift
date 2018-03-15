//
//  Body.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 12/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import CoreData
import Firebase



class Body: MediaChild {
    
    private var coreRef: DatabaseReference?
    
    typealias body = (Body?, Feedback)
    
    class func get(bodyId: String, context: NSManagedObjectContext, completion: @escaping (body, Error?) -> Void) {
        let strings = Constants.sharedInstance
        
        let request: NSFetchRequest<Body> = Body.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", bodyId)
        
        do {
            let bodies = try context.fetch(request)
            let count = bodies.count
    
            if count > 0 && count < 2 {
                completion((bodies.first, .successful), nil)
                return
            }else {
                if count > 1 {
                    for body in bodies {
                        context.delete(body)
                    }
                }
            }
            
            let newBody = Body(context: context)
            newBody.setValue(bodyId, forKey: strings._id)
            newBody.connectCore(context: context, completion: { (feedback, error) in
                if feedback == .successful {
                    completion((newBody, .successful), nil)
                }else {
                    if let error = error {
                        completion((nil, .failedWithErr), error)
                    }else {
                        completion((nil, .failed), nil)
                    }
                }
                
                return
            })
        }catch {
            completion((nil, .failedWhileInitializingObject), nil)
            return
        }
    }
    
    func createStructure() -> BodyStructure? {
        
        guard let id = id, let createdDate = createdDate, let bodyTitle = bodyTitle, let bodyText = bodyText, let creator = creator, let parent = parent else {
            return nil
        }
        
        let visibility = self.visibility
        
        let createdDateString = ThreadsData.getCurrentDateString(date: createdDate)
      
        let about = self.about ?? Constants.sharedInstance._emptyString
        
        guard let creatorStructure = creator.createStructure(), let parentStructure = parent.createStructure() else {
            return nil
        }
        
        let bodyStructure = BodyStructure(id: id, bodyText: bodyText, bodyTitle: bodyTitle, createdDate: createdDate, createdDateString: createdDateString, creatorStructure: creatorStructure, parentStructure: parentStructure, visibility: visibility, about: about)
    
        return bodyStructure
    }

    func connectCore(context: NSManagedObjectContext, completion: @escaping (Feedback, Error?) -> Void){
        
        guard let bodyId = id else {
            completion(.failedWhileAttemptingToSetId, nil)
            return
        }
        
        let strings = Constants.sharedInstance
        
        coreReference?.removeAllObservers()
        coreReference = database.child(strings._Body).child(bodyId)
        
        coreReference?.observe(.value, with: { (snapshot) in
            if let core = snapshot.value as? NSDictionary {
                
                guard let bodyText = core[strings._bodyText] as? String, let createdDateString = core[strings._createdDate] as? String, let parentKey = core[strings._parentKey] as? String, let createdBy = core[strings._createdBy] as? String, let visibility = core[strings._visibility] else {
                    return
                }
                
                guard let createdDate = ThreadsData.getDate(for: createdDateString) else {
                    completion(.failedToCreateCreatedDateString, nil)
                    return
                }
                
                let bodyTitle = core[strings._bodyTitle] as? String ?? strings._emptyString
                
                self.setValue(bodyText, forKey: strings._bodyText)
                self.setValue(createdDate, forKey: strings._createdDate)
                self.setValue(bodyTitle, forKey: strings._bodyTitle)
                self.setValue(visibility, forKey: strings._visibility)
                
                User.get(userId: createdBy, context: context, strings: strings, completion: { (user, error) in
                    
                    let feedback = user.1
                    
                    if feedback == .successful && error == nil {
                        if let creator = user.0 {
                            self.setValue(creator, forKey: self.s_._creator)
                            
                            Thread_.get(threadId: parentKey, context: context, completion: { (thread, error) in
                                let feedback = thread.1
                                
                                if feedback == .successful && error == nil {
                                    if let parent = thread.0 {
                                        self.setValue(parent, forKey: self.s_._parent)
                                        self.saveToContext(context: context, onCompletion: { (didSave, error) in
                                            completion(feedback, error)
                                            return
                                        })
                                    }
                                }else {
                                    completion(feedback, error)
                                    return
                                }
                            })
                        }else {
                            completion(feedback, error)
                            return
                        }
                    }else {
                       completion(feedback, error)
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
