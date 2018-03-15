//
//  Journal.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 1/3/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import Foundation
import Firebase
import CoreData

struct JournalStructure {
    var id: String
    var createdDate: Date
    var createdDateString: String
    var creatorStructure: UserStructure
    var text: String
}

class Journal: Object {
    
    private var coreRef: DatabaseReference?
    
    class func get(journalId: String, context: NSManagedObjectContext, completion: @escaping (Journal?, Error?) -> Void) {
        let strings = Constants.sharedInstance
        
        let request: NSFetchRequest<Journal> = Journal.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", journalId)
        
        do {
            let journals = try context.fetch(request)
            let count = journals.count
        
            if count > 0 && count < 2 {
                completion(journals.first, nil)
                return
            }else {
                if count > 1 {
                    for journal in journals {
                        context.delete(journal)
                    }
                }
            }
            
            let newJournal = Journal(context: context)
            newJournal.setValue(journalId, forKey: strings._id)
            newJournal.connectCore(context: context, completion: { (didConnectCore, error) in
                if didConnectCore {
                    completion(newJournal, nil)
                }else {
                    if let error = error {
                        completion(nil, error)
                        return
                    }else {
                        completion(nil, nil)
                        return
                    }
                }
            })
        }catch {
            completion(nil, error)
            return
        }
    }
    
    func createStructure() -> JournalStructure? {
    
        guard let id = id, let createdDate = createdDate, let text = text, let creator = creator else {
            return nil
        }
        
        let createdDateString = ThreadsData.getCurrentDateString(date: createdDate)
        
        guard let creatorStructure = creator.createStructure() else {
            return nil
        }
        
        let journalStructure = JournalStructure(id: id, createdDate: createdDate, createdDateString: createdDateString, creatorStructure: creatorStructure, text: text)
        
        return journalStructure
    }
    
    func connectCore(context: NSManagedObjectContext, completion: @escaping (Bool, Error?) -> Void){
        
        guard let journalId = id else {
            completion(false, nil)
            return
        }
        
        let strings = Constants.sharedInstance
        
        coreReference?.removeAllObservers()
        coreReference = database.child(strings._Journal).child(journalId)
        
        coreReference?.observe(.value, with: { (snapshot) in
            if let core = snapshot.value as? NSDictionary {
                
                guard let text = core[strings._text] as? String, let createdDateString = core[strings._createdDate] as? String, let createdBy = core[strings._createdBy] as? String else {
                    return
                }
                
                guard let createdDate = ThreadsData.getDate(for: createdDateString) else {
                    completion(false, nil)
                    return
                }
                
                self.setValue(text, forKey: strings._text)
                self.setValue(createdDate, forKey: strings._createdDate)
                
                User.get(userId: createdBy, context: context, strings: strings, completion: { (creator, error) in
                    if let creator = creator.0 {
                        self.setValue(creator, forKey: self.s_._creator)
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
        }, withCancel: { (error) in
            completion(false, error)
            return
        })
    }
}
