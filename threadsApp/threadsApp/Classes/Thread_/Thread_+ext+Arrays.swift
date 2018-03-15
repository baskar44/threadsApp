    //
//  Instance+ext+Arrays.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 21/1/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import CoreData
    
extension Thread_ {
    
    func addToBodies(bodyId: String, context: NSManagedObjectContext, strings: Constants, completion: @escaping (Feedback, Error?) -> Void){
        
        Body.get(bodyId: bodyId, context: context, completion: { (body, error) in
            if let body = body.0 {
                
                self.mutableSetValue(forKey: strings._children).add(body)
                
                self.saveToContext(context: context, onCompletion: { (didSave, error) in
                    if !didSave {
                        completion(.failedWhileSavingToContext, error)
                    }
                    
                })
                
            }else {
                if let error = error {
                    completion(.failedWithErr, error)
                }else {
                    completion(.failed, nil)
                }
            }
        })
    }
    
    func removeFromBodies(bodyId: String, context: NSManagedObjectContext, strings: Constants, completion: @escaping (Feedback, Error?) -> Void){
        
        Body.get(bodyId: bodyId, context: context, completion: { (body, error) in
            if let body = body.0 {
                
                self.mutableSetValue(forKey: strings._children).remove(body)
                
                self.saveToContext(context: context, onCompletion: { (didSave, error) in
                    if !didSave {
                        completion(.failedWhileSavingToContext, error)
                    }
                })
                
            }else {
                if let error = error {
                    completion(.failedWithErr, error)
                }else {
                    completion(.failed, nil)
                }
            }
        })
    }
    
    //Audio
    func addToAudio(audioId: String, context: NSManagedObjectContext, strings: Constants, completion: @escaping (Feedback, Error?) -> Void){
        
        Audio.get(audioId: audioId, context: context, completion: { (audio, error) in
            if let audio = audio {
                self.mutableSetValue(forKey: strings._children).add(audio)
                self.saveToContext(context: context, onCompletion: { (didSave, error) in
                    if !didSave {
                        completion(.failedWhileSavingToContext, error)
                    }
                })
                
            }else {
                if let error = error {
                    completion(.failedWithErr, error)
                }else {
                    completion(.failed, nil)
                }
            }
        })
    }
    
    func removeFromAudio(audioId: String, context: NSManagedObjectContext, strings: Constants, completion: @escaping (Feedback, Error?) -> Void){
        
        Audio.get(audioId: audioId, context: context, completion: { (audio, error) in
            if let audio = audio {
                self.mutableSetValue(forKey: strings._children).remove(audio)
                self.saveToContext(context: context, onCompletion: { (didSave, error) in
                    if !didSave {
                        completion(.failedWhileSavingToContext, error)
                    }
                })
                
            }else {
                if let error = error {
                    completion(.failedWithErr, error)
                }else {
                    completion(.failed, nil)
                }
            }
        })
    }
    
    //Photos
    func addToPhotos(photoId: String, context: NSManagedObjectContext, strings: Constants, completion: @escaping (Feedback, Error?) -> Void){
        
        Photo.get(photoId: photoId, context: context, completion: { (photo, error) in
            if let photo = photo {
                self.mutableSetValue(forKey: strings._children).add(photo)
                self.saveToContext(context: context, onCompletion: { (didSave, error) in
                    if !didSave {
                        completion(.failedWhileSavingToContext, error)
                    }
                })
                
            }else {
                if let error = error {
                    completion(.failedWithErr, error)
                }else {
                    completion(.failed, nil)
                }
            }
        })
    }
    
    func removeFromPhotos(photoId: String, context: NSManagedObjectContext, strings: Constants, completion: @escaping (Feedback, Error?) -> Void){
        
        Photo.get(photoId: photoId, context: context, completion: { (photo, error) in
            if let photo = photo {
                
                self.mutableSetValue(forKey: strings._children).remove(photo)
                self.saveToContext(context: context, onCompletion: { (didSave, error) in
                    if !didSave {
                        completion(.failedWhileSavingToContext, error)
                    }
                })
                
            }else {
                if let error = error {
                    completion(.failedWithErr, error)
                }else {
                    completion(.failed, nil)
                }
            }
        })
    }
    
    //Videos
    func addToVideos(videoId: String, context: NSManagedObjectContext, strings: Constants, completion: @escaping (Feedback, Error?) -> Void){
        
        Film.get(filmId: videoId, context: context, completion: { (video, error) in
            if let video = video {
                self.mutableSetValue(forKey: strings._children).add(video)
                self.saveToContext(context: context, onCompletion: { (didSave, error) in
                    if !didSave {
                        completion(.failedWhileSavingToContext, error)
                    }
                })
                
            }else {
                if let error = error {
                    completion(.failedWithErr, error)
                }else {
                    completion(.failed, nil)
                }
            }
        })
    }
    
    func removeFromVideos(videoId: String, context: NSManagedObjectContext, strings: Constants, completion: @escaping (Feedback, Error?) -> Void){
        
        Film.get(filmId: videoId, context: context, completion: { (video, error) in
            if let video = video {
                self.mutableSetValue(forKey: strings._children).remove(video)
                self.saveToContext(context: context, onCompletion: { (didSave, error) in
                    if !didSave {
                        completion(.failedWhileSavingToContext, error)
                    }
                })
                
            }else {
                if let error = error {
                    completion(.failedWithErr, error)
                }else {
                    completion(.failed, nil)
                }
            }
        })
    }
    
    
    
    
    
}
