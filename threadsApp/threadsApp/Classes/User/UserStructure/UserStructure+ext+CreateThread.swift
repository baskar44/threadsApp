//
//  User+ext+Create_Object.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 26/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import Firebase
import CoreData

extension UserStructure {
    
    func performUpdate(itemValuesAndId: ([String:Any], String), type: ItemType, context: NSManagedObjectContext, completion: @escaping (Feedback, Error?) -> Void){
        
        User.get(userId: self.id, context: context, strings: strings) { (user, error) in
            if let user = user.0 {
                
                let itemPath = self.getItemPath(type)
                
                //b adding feedItem to firebase
                let itemRef = Database.database().reference().child(itemPath).child(itemValuesAndId.1)
                
                //c check if feedItem already exists/and if exists if it has other targets other than body
                itemRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let core = snapshot.value as? NSDictionary {
                        if let _ = core[self.strings._targetBody] as? String, let _ = core[self.strings._targetAudio] as? String, let _ = core[self.strings._targetPhoto] as? String, let _ = core[self.strings._targetVideo] as? String {
                            
                            //completion
                            completion(.targetAlreadyExists, nil)
                            return
                        }
                    }
                    
                    itemRef.setValue(itemValuesAndId.0)
                    
                    let listPath = self.getListPath(type)
                    Database.database().reference().child(listPath).child(self.id).child(itemValuesAndId.1).setValue(true)
                    
                    if type == .feed {
                        //d adding feedItem to the feed of all followers
                        if let allFollowers = user.followers?.allObjects {
                            for follower in allFollowers {
                                if let follower = follower as? User {
                                    if let id = follower.id  {
                                        //adding to the feed of all followers
                                        Database.database().reference().child(listPath).child(id).child(itemValuesAndId.1).setValue(true)
                                    }
                                }
                            }
                        }
                    }
                    
                    completion(.successful, nil)
                })
                
            }else {
                if let error = error {
                    //completion
                    completion(.failedToRetrieveCreatorWithErr, error)
                }else {
                    //completion
                    completion(.failedToRetrieveCreator, nil)
                }
                
                return
            }
        }
    }
    
    func addThread(threadTemplate: ThreadTemplate, completion: @escaping (Feedback, Error?) -> Void){
        
        let strings = Constants.sharedInstance
        
        let createdDateString = ThreadsData.getCurrentDateString(date: threadTemplate.createdDate)
        
        let info = [strings._title: threadTemplate.title,
                    strings._createdDate: createdDateString,
                    strings._visibility: threadTemplate.visibility,
                    strings._createdBy: threadTemplate.createdBy,
                    strings._about: threadTemplate.about] as [String:Any]
        
        guard let context = context else {
            completion(.failedWhileGettingContext, nil)
            return
        }
        
        let dictionary = self.getLogRelatedItemValuesAndId(.add, mediaChildId: threadTemplate.id, strings: self.strings)
        
        guard let journalItemValues = dictionary[self.strings._JournalItem], let feedItemValues = dictionary[self.strings._FeedItem] else {
            completion(.failedToGetLog, nil)
            return
        }
        
        self.performUpdate(itemValuesAndId: journalItemValues, type: .journal, context: context) { (feedback, error) in
             if feedback == .successful {
                self.performUpdate(itemValuesAndId: feedItemValues, type: .feed, context: context, completion: { (feedback, error) in
                    
                    if feedback == .successful {
                        self.database.child(strings._Thread_).child(threadTemplate.id).updateChildValues(info)
                    self.database.child(strings._Threads).child(threadTemplate.createdBy).child(threadTemplate.id).setValue(true)
                        completion(.successful, nil)
                    }else {
                        completion(.failedToAdd, error)
                    }
                    return
                })
             }else {
                completion(.failedToAdd, error)
                return
            }
        }
    }
    
    func removeThread(selectedThreadStructure: ThreadStructureProtocol, completion: @escaping (Feedback, Error?) -> Void) {
        
        guard let context = context else {
            completion(.failedWhileSavingToContext, nil)
            return
        }
        
        selectedThreadStructure.isReadyForRemove(mediaType: .body) { (isReady) in
            if isReady {
                
                selectedThreadStructure.isReadyForRemove(mediaType: .photo) { (isReady) in
                    if isReady {
                        
                        selectedThreadStructure.isReadyForRemove(mediaType: .audio) { (isReady) in
                            if isReady {
                                
                                selectedThreadStructure.isReadyForRemove(mediaType: .film) { (isReady) in
                                    if isReady {
                                       
                                        
                                        let dictionary = self.getLogRelatedItemValuesAndId(.remove, mediaChildId: selectedThreadStructure.id, strings: self.strings)
                                        
                                        guard let journalItemValues = dictionary[self.strings._JournalItem] else {
                                            completion(.failedToGetLog, nil)
                                            return
                                        }
                                        
                                        self.performUpdate(itemValuesAndId: journalItemValues, type: .journal, context: context, completion: { (feedback, error) in
                                            if feedback == .successful {
                                                self.database.child(Constants.sharedInstance._Threads).child(self.id).child(selectedThreadStructure.id).removeValue()
                                                self.database.child(Constants.sharedInstance._Thread_).child(selectedThreadStructure.id).removeValue()
                        
                                            }
                                            
                                            completion(feedback, error)
                                            return
                                        })
                                        
                                    }else {
                                        completion(.threadHasExistingChildren, nil)
                                    }
                                }
        
                            }else {
                                completion(.threadHasExistingChildren, nil)
                            }
                        }
                        
                    }else {
                        completion(.threadHasExistingChildren, nil)
                    }
                }
                
            }else {
                completion(.threadHasExistingChildren, nil)
            }
        }
    }
}

