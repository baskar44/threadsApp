    //
//  User+ext+Arrays.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 18/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import CoreData
import Firebase

enum Action {
    case add
    case remove
}

extension User {
 
    func initiate(action: Action, in type: ListType, objectId: String, context: NSManagedObjectContext, strings: Constants, completion: @escaping (Feedback, Error?) -> Void){
        
        if type == .followers || type == .following || type == .requested || type == .pending {
            
            var forKey: String?
            
            switch type {
            case .followers:
                forKey = strings._followers
                break
            case .following:
                forKey = strings._following
                break
            case .requested:
                forKey = strings._requested
                break
            case .pending:
                forKey = strings._pending
                break
            default:
                break
            }
            
            if let forKey = forKey {
                User.get(userId: objectId, context: context, strings: strings) { (user, error) in
                    let feedback = user.1
                    if feedback == .successful {
                        if let user = user.0 {
                          
                            
                            switch action {
                            case .add:
                                self.mutableSetValue(forKey: forKey).add(user)
                                break
                            case .remove:
                                
                                self.mutableSetValue(forKey: forKey).remove(user)
                                break
                            }
                            
                            self.saveToContext(context: context, onCompletion: { (didSave, error) in
                                if didSave && error == nil {
                                    completion(.successful, nil)
                                }else {
                                    completion(.failedWhileSavingToContext, error)
                                }
                                return
                            })
                            
                        }else {
                            if let error = error {
                                completion(.failedWithErr, error)
                            }else {
                                completion(.failed, nil)
                            }
                            
                            return
                        }
                    }
                }
            }else {
                completion(.failedToGetForKey, nil)
                return
            }
            
        }else if type == .journal {
            //todo later
            
        }else if type == .feed {
            //todo later
            FeedItem.get(feedItemId: objectId, strings: strings, context: context, completion: { (feedItem, error) in
                let feedback = feedItem.1
                if feedback == .successful, let feedItem = feedItem.0 {
                    feedItem.setValue(self, forKey: strings._borrowedBy)
                   
                    self.saveToContext(context: context, onCompletion: { (didSave, error) in
                        if didSave && error == nil {
                            completion(.successful, nil)
                        }else {
                            completion(.failedWhileSavingToContext, error)
                        }
                        return
                    })
                    
                }else {
                    completion(feedback, error)
                    return
                }
            })
            
        }else {
            
            
            ///media
            //audio - bmaudio, sharedaudio, createdaudio
            
            //video = bmvideo, sharedvideo, createdvideo
            
            //body = bmbody, sharedbody, createdbody
            
            //thread = bmthread, sharedthread, createdthread
            
            if type == .bookmarkedAudio || type == .sharedAudio || type == .createdAudio {
                //todo
            }
            
            if type == .bookmarkedVideo || type == .sharedVideo || type == .createdVideo {
                //todo
            }
            
            if type == .bookmarkedThreads || type == .sharedThreads || type == .createdThreads {
                //todo
                
                Thread_.get(threadId: objectId, context: context, completion: { (thread, error) in
                    let feedback = thread.1
                    
                    if feedback == .successful && error == nil {
                        if let thread = thread.0 {
                            
                            switch action {
                            case .add:
                                self.mutableSetValue(forKey: strings._media).add(thread)
                                break
                            case .remove:
                                self.mutableSetValue(forKey: strings._media).remove(thread)
                                break
                            }
                            
                            self.saveToContext(context: context, onCompletion: { (didSave, error) in
                                if didSave && error == nil {
                                    completion(.successful, nil)
                                }else {
                                    completion(.failedWhileSavingToContext, error)
                                }
                                return
                            })
                            
                        }else {
                            if let error = error {
                                completion(.failedWithErr, error)
                            }else {
                                completion(.failed, nil)
                            }
                            return
                        }
                    }else {
                        completion(feedback, error)
                        return
                    }
                })
            }
            
            if type == .bookmarkedBody || type == .sharedBody || type == .createdBody {
                //todo
                Body.get(bodyId: objectId, context: context, completion: { (body, error) in
                    let feedback = body.1
                    
                    if feedback == .successful && error == nil {
                        if let body = body.0 {
                            
                            switch action {
                            case .add:
                                self.mutableSetValue(forKey: strings._media).add(body)
                                break
                            case .remove:
                                self.mutableSetValue(forKey: strings._media).remove(body)
                                break
                            }
                            
                            self.saveToContext(context: context, onCompletion: { (didSave, error) in
                                if didSave && error == nil {
                                    completion(.successful, nil)
                                }else {
                                    completion(.failedWhileSavingToContext, error)
                                }
                                return
                            })
                        }else {
                            if let error = error {
                                completion(.failedWithErr, error)
                            }else {
                                completion(.failed, nil)
                            }
                            return
                        }
                    }else {
                        completion(feedback, error)
                        return
                    }
                })
            }
            
            if type == .bookmarkedPhotos || type == .sharedPhotos || type == .createdPhotos {
                //todo
                
                Photo.get(photoId: objectId, context: context, completion: { (photo, error) in
                   
                    
                    //todo
                    if let photo = photo {
                        switch action {
                        case .add:
                            self.mutableSetValue(forKey: strings._media).add(photo)
                            break
                        case .remove:
                            self.mutableSetValue(forKey: strings._media).remove(photo)
                            break
                        }
                        
                        self.saveToContext(context: context, onCompletion: { (didSave, error) in
                            if didSave && error == nil {
                                completion(.successful, nil)
                            }else {
                                completion(.failedWhileSavingToContext, error)
                            }
                            return
                        })
                    }else {
                        
                    }
                })
            }
        }
    }
}
    
