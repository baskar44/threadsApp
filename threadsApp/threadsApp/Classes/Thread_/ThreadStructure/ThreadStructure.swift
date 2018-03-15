//
//  ThreadStructure.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 2/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import Firebase
import CoreData

enum ObserveType {
    case remove
    case added
}

enum Observe {
    case audio
    case bodies
    case photos
    case videos
}

struct ThreadStructure: ThreadStructureProtocol {
   

    private var _id: String
    var id: String {
        return _id
    }
    
    private var _title: String
    var title: String {
        return _title
    }
    
    private var _createdDate: Date
    var createdDate: Date {
        return _createdDate
    }
    
    private var _createdDateString: String
    var createdDateString: String {
        return _createdDateString
    }
    
    private var _visibility: Bool
    var visibility: Bool {
        return _visibility
    }
    
    private var _about: String
    var about: String {
        return _about
    }
    
    private var _creatorStructure: UserStructureProtocol
    var creatorStructure: UserStructureProtocol {
        return _creatorStructure
    }
    
    private var _databaseReference: DatabaseReference
    var databaseReference: DatabaseReference {
        return _databaseReference
    }

    private var _strings: Constants
    var strings: Constants {
        return _strings
    }
    
    var audioReference: DatabaseReference
    var photosReference: DatabaseReference
    var videosReference: DatabaseReference
    var bodiesReference: DatabaseReference
    var coreReference: DatabaseReference
    
    private var context: NSManagedObjectContext?
    
    init(id: String, title:String, visibility: Bool, createdDate: Date, about: String, creatorStructure: UserStructureProtocol) {
        
        _id = id
        _title = title
        _visibility = visibility
        _createdDate = createdDate
        _creatorStructure = creatorStructure
        _about = about
        _databaseReference = Database.database().reference()
        
        let createdDateString = ThreadsData.getCurrentDateString(date: createdDate)
        _createdDateString = createdDateString
        _strings = Constants.sharedInstance
        
        audioReference = Database.database().reference().child(Constants.sharedInstance._Audio).child(id)
        photosReference = Database.database().reference().child(Constants.sharedInstance._Photos).child(id)
        videosReference = Database.database().reference().child(Constants.sharedInstance._Videos).child(id)
        bodiesReference = Database.database().reference().child(Constants.sharedInstance._Bodies).child(id)
        coreReference = Database.database().reference().child(Constants.sharedInstance._Thread_).child(id)
        
        context = ThreadsData.sharedInstance.container?.viewContext
    }
    
    //Core related
    enum ThreadSection: String {
        case about = "About"
        case title = "Title"
    }
    
    enum ThreadAction {
        case add
        case remove
    }
    
    func updateVisibility(_ isVisible: Bool) -> Bool {
        coreReference.child(self.strings._visibility).setValue(isVisible)
        return true
    }
    
    func performUpdate(itemValuesAndId: ([String:Any], String), type: ItemType, context: NSManagedObjectContext, completion: @escaping (Feedback, Error?) -> Void){
        
        User.get(userId: creatorStructure.id, context: context, strings: strings) { (user, error) in
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
                    Database.database().reference().child(listPath).child(self.creatorStructure.id).child(itemValuesAndId.1).setValue(true)
                    
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
    
    func update(_ sections: [ThreadSection], title: String, content: String, isVisible: Bool, completion: @escaping (Feedback, Error?) -> Void){
        
        guard let context = context else {
            completion(.failedWhileSavingToContext, nil)
            return
        }
        
        let dictionary = getLogRelatedItemValuesAndId(sections, strings: strings)
        
        guard let journalItemValues = dictionary[strings._JournalItem], let feedItemValues = dictionary[strings._FeedItem] else {
            completion(.failedToGetLog, nil)
            return
        }
        
        self.performUpdate(itemValuesAndId: journalItemValues, type: .journal, context: context, completion: { (feedback, error) in
            if feedback == .successful {
                
                if isVisible {
                    self.performUpdate(itemValuesAndId: feedItemValues, type: .feed, context: context) { (feedback, error) in
                        if feedback == .successful {
                            for section in sections {
                                if section == .title {
                                    self.coreReference.child(Constants.sharedInstance._title).setValue(title)
                                }else if section == .about {
                                    self.coreReference.child(Constants.sharedInstance._about).setValue(content)
                                }
                            }
                            
                            completion(.successful, nil)
                        }else {
                            completion(feedback, error)
                        }
                        
                        return
                    }
                }else {
                    for section in sections {
                        if section == .title {
                            self.coreReference.child(Constants.sharedInstance._title).setValue(title)
                        }else if section == .about {
                            self.coreReference.child(Constants.sharedInstance._about).setValue(content)
                        }
                    }
                    
                    completion(.successful, nil)
                    return
                }
            }else {
                completion(feedback, error)
                return
            }
        })
    }
    
    
    //Children related
    //MARK:- Body
    func observeAddedBodies(_ thread: Thread_, context: NSManagedObjectContext, completion: @escaping (Feedback, Error?) -> Void){
        bodiesReference.observe(.childAdded, with: { (snapshot) in
            let bodyId = snapshot.key
            thread.addToBodies(bodyId: bodyId, context: context, strings: self.strings, completion: { (feedback, error) in
                completion(feedback, error)
            })
        }) { (error) in
            completion(.failedWhileObserving, error)
            return
        }
    }
    
    private func observeRemovalOfBodies(_ thread: Thread_, context: NSManagedObjectContext, completion: @escaping (Feedback, Error?) -> Void){
        bodiesReference.observe(.childRemoved, with: { (snapshot) in
            let bodyId = snapshot.key
            thread.removeFromBodies(bodyId: bodyId, context: context, strings: self.strings, completion: { (feedback, error) in
                completion(feedback, error)
            })
        }) { (error) in
            completion(.failedWhileObserving, error)
            return
        }
    }
    
    func addBody(with bodyTemplate: BodyTemplateProtocol, completion: @escaping (Feedback, Error?) -> Void) {

        guard let context = context else {
            completion(.failedWhileGettingContext, nil)
            return
        }
        
        let createdDateString = ThreadsData.getCurrentDateString(date: bodyTemplate.createdDate)
        
        let bodyInfo = [ self.strings._bodyText:bodyTemplate.bodyText,
                         self.strings._createdBy:bodyTemplate.createdBy,
                         self.strings._createdDate: createdDateString,
                         self.strings._bodyTitle: bodyTemplate.bodyTitle,
                         self.strings._parentKey:bodyTemplate.parentKey,
                         self.strings._visibility: bodyTemplate.visibility] as [String:Any]
        
        
        let dictionary = getLogRelatedItemValuesAndId(.add, mediaChildType: .body, mediaChildId: bodyTemplate.id, strings: strings)
        
        guard let feedItemValuesAndId = dictionary[strings._FeedItem], let journalItemValuesAndId = dictionary[strings._JournalItem] else {
            completion(.failedToGetLog, nil)
            return
        }

        self.performUpdate(itemValuesAndId: journalItemValuesAndId, type: .journal, context: context, completion: { (feedback, error) in
            if feedback == .successful {
                
                if bodyTemplate.visibility {
                    self.performUpdate(itemValuesAndId: feedItemValuesAndId, type: .feed, context: context) { (feedback, error) in
                        if feedback == .successful {
                            self.databaseReference.child(self.strings._Body).child(bodyTemplate.id).updateChildValues(bodyInfo)
                            self.databaseReference.child(self.strings._Bodies).child(self.id).child(bodyTemplate.id).setValue(true)
                            completion(.successful, nil)
                        }else {
                            completion(feedback, error)
                        }
                        
                        return
                    }
                }else {
                    self.databaseReference.child(self.strings._Body).child(bodyTemplate.id).updateChildValues(bodyInfo)
                    self.databaseReference.child(self.strings._Bodies).child(self.id).child(bodyTemplate.id).setValue(true)
                    
                    completion(.successful, nil)
                    return
                }
            }else {
                completion(feedback, error)
                return
            }
        })
    }
    
    func removeBody(bodyStructure: BodyStructureProtocol, completion: @escaping (Feedback, Error?) -> Void) {
       
        guard let context = context else {
            completion(.failedWhileGettingContext, nil)
            return
        }
        
        let dictionary = getLogRelatedItemValuesAndId(.remove, mediaChildType: .body, mediaChildId: bodyStructure.id, strings: strings)
        
        guard let journalItemValuesAndId = dictionary[strings._JournalItem] else {
            completion(.failedToGetLog, nil)
            return
        }
        
        performUpdate(itemValuesAndId: journalItemValuesAndId, type: .journal, context: context) { (feedback, error) in
            if feedback == .successful {
                self.databaseReference.child(Constants.sharedInstance._Bodies).child(self.id).child(bodyStructure.id).removeValue()
                self.databaseReference.child(Constants.sharedInstance._Body).child(bodyStructure.id).removeValue()
                
                completion(.successful, nil)
            }else {
                completion(feedback, error)
                return
            }
        }
    }
    
    //MARK:- Audio
    private func observeAddedAudio(_ thread: Thread_, context: NSManagedObjectContext, completion: @escaping (Feedback, Error?) -> Void){
        audioReference.observe(.childAdded, with: { (snapshot) in
            let audioItemId = snapshot.key
            thread.addToAudio(audioId: audioItemId, context: context, strings: self.strings, completion: { (didAdd, error) in
                completion(didAdd,error)
            })
            
        }, withCancel: { (error) in
            completion(.failedWhileObserving, error)
            return
        })
    }
    
    private func observeRemovalOfAudio(_ thread: Thread_, context: NSManagedObjectContext, completion: @escaping (Feedback, Error?) -> Void) {
        audioReference.observe(.childRemoved, with: { (snapshot) in
            let audioItemId = snapshot.key
            thread.removeFromAudio(audioId: audioItemId, context: context, strings: self.strings, completion: { (didRemove, error) in
                completion(didRemove,error)
            })
            
        }, withCancel: { (error) in
            completion(.failedWhileObserving, error)
            return
        })
    }
    
    func removeAudio(id selected: String) -> Bool {
        //need to add to journal
        databaseReference.child(Constants.sharedInstance._Audio).child(id).child(selected).removeValue()
        databaseReference.child(Constants.sharedInstance._AudioItem).child(selected).removeValue()
        return true
    }
    
    //MARK:- Videos
    private func observeAddedVideo(_ thread: Thread_, context: NSManagedObjectContext, completion: @escaping (Feedback, Error?) -> Void){
        videosReference.observe(.childAdded, with: { (snapshot) in
            let videoItemId = snapshot.key
            thread.addToVideos(videoId: videoItemId, context: context, strings: self.strings, completion: { (didAdd, error) in
                completion(didAdd, error)
            })
            
        }, withCancel: { (error) in
            completion(.failedWhileObserving, error)
            return
        })
    }
    
    
    private func observeRemovalOfVideos(_ thread: Thread_, context: NSManagedObjectContext, completion: @escaping (Feedback, Error?) -> Void){
        videosReference.observe(.childRemoved, with: { (snapshot) in
            let videoItemId = snapshot.key
            thread.removeFromVideos(videoId: videoItemId, context: context, strings: self.strings, completion: { (feedback, error) in
                completion(feedback, error)
            })
            
        }, withCancel: { (error) in
            completion(.failedWhileObserving, error)
            return
        })
    }
    
    func removeVideo(id selected: String) -> Bool {
        //need to add to journal
        databaseReference.child(Constants.sharedInstance._Film).child(id).child(selected).removeValue()
        databaseReference.child(Constants.sharedInstance._Video).child(selected).removeValue()
        return true
    }
    //
    
    //MARK: - Photo related
    private func observeAddedPhoto(_ thread: Thread_, context: NSManagedObjectContext, completion: @escaping (Feedback, Error?) -> Void){
        photosReference.observe(.childAdded, with: { (snapshot) in
            let photoId = snapshot.key
            
            thread.addToPhotos(photoId: photoId, context: context, strings: self.strings, completion: { (didAdd, error) in
                completion(didAdd, error)
            })
            
        }, withCancel: { (error) in
            completion(.failedWhileObserving, error)
            return
        })
    }
    
    
    private func observeRemovalOfPhotos(_ thread: Thread_, context: NSManagedObjectContext, completion: @escaping (Feedback, Error?) -> Void){
        photosReference.observe(.childRemoved, with: { (snapshot) in
            let photoId = snapshot.key
            
            thread.removeFromPhotos(photoId: photoId, context: context, strings: self.strings, completion: { (didRemove, error) in
                completion(didRemove, error)
            })
            
        }, withCancel: { (error) in
            completion(.failedWhileObserving, error)
            return
        })
    }
    
    func addPhoto(with photoTemplate: PhotoTemplate, completion: @escaping (Feedback, Error?) -> Void){

        guard let context = context else {
            completion(.failedWhileSavingToContext, nil)
            return
        }
        
        let imageName = NSUUID().uuidString
        let storage = Storage.storage().reference().child(strings._Images).child("\(imageName).jpeg")
        
        let createdDateString = ThreadsData.getCurrentDateString(date: photoTemplate.createdDate)
        
        if let uploadData = UIImageJPEGRepresentation(photoTemplate.image, 0.3) {
            
            storage.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    completion(.failedToAdd, error)
                }else {
                    
                    let photoInfo = [self.strings._about:photoTemplate.about,
                                     self.strings._createdBy:photoTemplate.createdBy,
                                     self.strings._createdDate: createdDateString,
                                     self.strings._imageName: imageName,
                                     self.strings._parentKey:photoTemplate.parentKey,
                                     self.strings._visibility: photoTemplate.visibility]
                    as [String:Any]
                   
                    let dictionary = self.getLogRelatedItemValuesAndId(.add, mediaChildType: .photo, mediaChildId: photoTemplate.id, strings: self.strings)
                    
                    guard let feedItemValuesAndId = dictionary[self.strings._FeedItem], let journalItemValuesAndId = dictionary[self.strings._JournalItem] else {
                        completion(.failedToGetLog, nil)
                        return
                    }
                    
                    
                    self.performUpdate(itemValuesAndId: journalItemValuesAndId, type: .journal, context: context) { (feedback, error) in
                        if feedback == .successful {
                            
                            
                            self.performUpdate(itemValuesAndId: feedItemValuesAndId, type: .feed, context: context, completion: { (feedback, error) in
                                
                                if feedback == .successful {
                                    self.databaseReference.child(self.strings._Photo).child(photoTemplate.id).updateChildValues(photoInfo)
                                    self.databaseReference.child(self.strings._Photos).child(self.id).child(photoTemplate.id).setValue(true)
                                   
                                    completion(.successful, nil)
                                }else {
                                    completion(feedback, error)
                                }
                                return
                            })
                        }else {
                            completion(feedback, error)
                            return
                        }
                    }
                }
                
            }).resume()
        }
    }
    
    func removePhoto(photoStructure: PhotoStructure, completion: @escaping (Feedback, Error?) -> Void) {
        //need to add to journal
        
        guard let context = context else{
            completion(.failedWhileSavingToContext, nil)
            return
        }
        
        let dictionary = getLogRelatedItemValuesAndId(.remove, mediaChildType: .photo, mediaChildId: photoStructure.id, strings: strings)
        
        guard let journalItemValuesAndId = dictionary[strings._JournalItem] else {
            completion(.failedToGetLog, nil)
            return
        }
        
        performUpdate(itemValuesAndId: journalItemValuesAndId, type: .journal, context: context) { (feedback, error) in
            if feedback == .successful {
                self.databaseReference.child(Constants.sharedInstance._Photos).child(self.id).child(photoStructure.id).removeValue()
                self.databaseReference.child(Constants.sharedInstance._Photo).child(photoStructure.id).removeValue()
                
                completion(.successful, nil)
            }else {
                completion(feedback, error)
            }
            
            return
        }
    }
    
    //MARK:- Observe
    func observe(_ observe: Observe, type: ObserveType, context: NSManagedObjectContext, completion: @escaping (Feedback, Error?) -> Void){
        Thread_.get(threadId: id, context: context) { (thread, error) in
            
            let feedback = thread.1
            
            if feedback == .successful {
                if let thread = thread.0 {
                    
                    switch type {
                    case .added:
                        switch observe {
                        case .audio:
                            self.observeAddedAudio(thread, context: context, completion: { (didObserve, error) in
                                completion(feedback, error)
                            })
                            break
                        case .bodies:
                            self.observeAddedBodies(thread, context: context, completion: { (didObserve, error) in
                                completion(feedback, error)
                            })
                            break
                        case .photos:
                            self.observeAddedPhoto(thread, context: context, completion: { (didObserve, error) in
                                completion(feedback, error)
                            })
                            break
                        case .videos:
                            self.observeAddedVideo(thread, context: context, completion: { (didObserve, error) in
                                completion(feedback, error)
                            })
                            break
                        }
                        
                        break
                    case .remove:
                        
                        switch observe {
                        case .audio:
                            self.observeRemovalOfAudio(thread, context: context, completion: { (didObserve, error) in
                                completion(feedback, error)
                            })
                            break
                        case .bodies:
                            self.observeRemovalOfBodies(thread, context: context, completion: { (didObserve, error) in
                                completion(feedback, error)
                            })
                            break
                        case .photos:
                            self.observeRemovalOfPhotos(thread, context: context, completion: { (didObserve, error) in
                                completion(feedback, error)
                            })
                            break
                        case .videos:
                            self.observeRemovalOfVideos(thread, context: context, completion: { (didObserve, error) in
                                completion(feedback, error)
                            })
                            break
                        }
                        break
                    }
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
    }
}
