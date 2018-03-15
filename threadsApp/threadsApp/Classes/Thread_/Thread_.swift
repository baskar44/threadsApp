//
//  Instance.swift
//  Instance_
//
//  Created by Gururaj Baskaran on 31/10/17.
//  Copyright © 2017 Gururaj Baskaran. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class Thread_: Media {
    
    typealias thread = (Thread_?, Feedback)
    
    class func get(threadId: String, context: NSManagedObjectContext, completion: @escaping (thread, Error?) -> Void) {
    let strings = Constants.sharedInstance
        
        let request: NSFetchRequest<Thread_> = Thread_.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", threadId)
        
        do {
            let threads = try context.fetch(request)
            let count = threads.count
            
            if count > 0 && count < 2 {
                let thread = threads.first
                completion((thread, .successful), nil)
                return
            }else {
                if count > 1 {
                    //error in db. there should not be more than 1 item with the same id.
                    //remove all objects with this id
                    for thread in threads {
                        context.delete(thread)
                    }
                }
                
                let newThread = Thread_(context: context)
                newThread.setValue(threadId, forKey: strings._id)
                
                //connect core, creator, parent and profile image
                newThread.connectCore(context: context, strings: strings, completion: { (feedback, error) in
                    if feedback == .successful {
                        completion((newThread, feedback), nil)
                    }else {
                        completion((nil, feedback), nil)
                    }
                })
            }
        }catch {
            completion((nil, .failedWhileInitializingObject),nil)
            return
        }
    }
    
    //comments
    func createStructure() -> ThreadStructure? {
        guard let id = id, let createdDate = createdDate, let title = title, let about = about, let creator = creator else {
            //error handle
            return nil
        }
        
        guard let creatorStructure = creator.createStructure() else {
            //error handle
            return nil
        }
        
        let visibility = self.visibility
        
        let threadStructure = ThreadStructure(id: id, title: title, visibility: visibility, createdDate: createdDate, about: about, creatorStructure: creatorStructure)
        
        return threadStructure
    }
}

