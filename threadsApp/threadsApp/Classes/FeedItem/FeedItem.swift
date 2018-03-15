//
//  FeedItem.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 5/3/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import CoreData
import Firebase

class FeedItem: Object {
    
    private var coreRef: DatabaseReference?
    
    typealias feedItem = (FeedItem?, Feedback)
    
    class func get(feedItemId: String, strings: Constants, context: NSManagedObjectContext, completion: @escaping (feedItem, Error?) -> Void) {
        
        let request: NSFetchRequest<FeedItem> = FeedItem.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", feedItemId)
        
        do {
            let feedItems = try context.fetch(request)
            let count = feedItems.count
            
            if count > 0 && count < 2 {
                completion((feedItems.first, .successful), nil)
                return
            }else {
                if count > 1 {
                    for feedItem in feedItems {
                        context.delete(feedItem)
                    }
                }
            }
            
            let newFeedItem = FeedItem(context: context)
            newFeedItem.setValue(feedItemId, forKey: strings._id)
            newFeedItem.connectCore(context: context, strings: strings, completion: { (feedback, error) in
                if feedback == .successful {
                    completion((newFeedItem, .successful), nil)
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
            completion((nil, .failedWhileFetchingObjects), nil)
            return
        }
    }
 
    func connectCore(context: NSManagedObjectContext, strings: Constants, completion: @escaping (Feedback, Error?) -> Void){
        
        guard let feedItemId = id else {
            completion(.failedWhileAttemptingToSetId, nil)
            return
        }
    
        coreReference?.removeAllObservers()
        coreReference = database.child(strings._FeedItem).child(feedItemId)
        
        coreReference?.observe(.value, with: { (snapshot) in
            if let core = snapshot.value as? NSDictionary {
                
                guard let createdBy = core[strings._createdBy] as? String, let message = core[strings._message] as? String, let createdDateString = core[strings._createdDate] as? String else {
                    return
                }
                
                guard let createdDate = ThreadsData.getDate(for: createdDateString) else {
                    completion(.failedToCreateCreatedDateString, nil)
                    return
                }
                
                self.setValue(message, forKey: strings._message)
                self.setValue(createdDate, forKey: strings._createdDate)
                
                var noOfTargets = 0 //cannot pass 1
                
                self.connectCreator(createdBy: createdBy, context: context, strings: strings, completion: { (didConnect, error) in
                    if didConnect {
                        
                        if let targetKey = core[strings._targetThread] as? String {
                            //thread
                            noOfTargets = noOfTargets + 1
                            
                            Thread_.get(threadId: targetKey, context: context, completion: { (thread, error) in
                                if let thread = thread.0 {
                                    if noOfTargets == 1 {
                                        
                                        self.setValue(thread, forKey: strings._target)
                                        self.saveToContext(context: context, onCompletion: { (didSave, error) in
                                            if didSave && error == nil {
                                                completion(.successful, nil)
                                            }else {
                                                completion(.failedWhileSavingToContext, error)
                                            }
                                            return
                                        })
                                    }else if noOfTargets > 1 {
                                        completion(.failedWhileConnectingCore, nil)
                                        return
                                    }
                                }
                                
                            })
                            
                        }else if let targetKey = core[strings._targetBody] as? String {
                            //body
                            noOfTargets = noOfTargets + 1
                            Body.get(bodyId: targetKey, context: context, completion: { (body, error) in
                                if let body = body.0 {
                                    
                                    
                                    
                                    self.setValue(body, forKey: strings._target)
                                    self.saveToContext(context: context, onCompletion: { (didSave, error) in
                                        if didSave && error == nil {
                                            completion(.successful, nil)
                                        }else {
                                            completion(.failedWhileSavingToContext, error)
                                        }
                                        return
                                    })
                                }else if noOfTargets > 1 {
                                    completion(.failedWhileConnectingCore, nil)
                                    return
                                }
                            })
                        }else if let targetKey = core[strings._targetPhoto] as? String {
                            //photo
                            noOfTargets = noOfTargets + 1
                            
                            Photo.get(photoId: targetKey, context: context, completion: { (photo, error) in
                                if let photo = photo {
                                    if noOfTargets == 1 {
                                        self.setValue(photo, forKey: strings._target)
                                        self.saveToContext(context: context, onCompletion: { (didSave, error) in
                                            if didSave && error == nil {
                                                completion(.successful, nil)
                                            }else {
                                                completion(.failedWhileSavingToContext, error)
                                            }
                                            return
                                        })
                                    }else if noOfTargets > 1 {
                                        completion(.failedWhileConnectingCore, nil)
                                        return
                                    }
                                    
                                }
                            })
                        }else if let targetKey = core[strings._targetVideo] as? String {
                            //video
                            noOfTargets = noOfTargets + 1
                            
                            Film.get(filmId: targetKey, context: context, completion: { (film, error) in
                                if let film = film {
                                    if noOfTargets == 1 {
                                        self.setValue(film, forKey: strings._target)
                                        self.saveToContext(context: context, onCompletion: { (didSave, error) in
                                            if didSave && error == nil {
                                                completion(.successful, nil)
                                            }else {
                                                completion(.failedWhileSavingToContext, error)
                                            }
                                            return
                                        })
                                    }else if noOfTargets > 1 {
                                        completion(.failedWhileConnectingCore, nil)
                                        return
                                    }
                                    
                                }
                            })
                        }else if let targetKey = core[strings._targetAudio] as? String {
                            //audio
                            noOfTargets = noOfTargets + 1
                            
                            Audio.get(audioId: targetKey, context: context, completion: { (audio, error) in
                                if let audio = audio {
                                    if noOfTargets == 1 {
                                        self.setValue(audio, forKey: strings._target)
                                        self.saveToContext(context: context, onCompletion: { (didSave, error) in
                                            if didSave && error == nil {
                                                completion(.successful, nil)
                                            }else {
                                                completion(.failedWhileSavingToContext, error)
                                            }
                                            return
                                        })
                                    }else if noOfTargets > 1 {
                                        completion(.failedWhileConnectingCore, nil)
                                        return
                                    }
                                }
                            })
                        }
                    }
                })
            }
        }, withCancel: { (error) in
            completion(.failedWhileObserving, error)
            return
        })
    }
    
    func connectCreator(createdBy: String, context: NSManagedObjectContext, strings: Constants, completion: @escaping (Bool, Error?) -> Void){
        User.get(userId: createdBy, context: context, strings: strings, completion: { (creator, error) in
            if let creator = creator.0 {
                self.setValue(creator, forKey: strings._creator)
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
    
}
