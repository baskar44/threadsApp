//
//  UserStructure.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 2/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import Firebase
import CoreData

enum UserAccess {
    case current
    case full
    case noAccess
    case moderator
    case blocked
    case failed
}

struct UserStructure: UserStructureProtocol {
   
    
    enum UserAction {
        case add
        case remove
        case share
        case bookmark
        case removeShare
        case removeBookmark
        case follow
        case request
        case unFollow
        case cancelPending
        case acceptPending
        case withdrawRequest
    }

    
    var id:String
    var createdDate:Date
    var createdDateString:String
    var visibility: Bool
    var username: String
    var fullname: String
    var bio: String
    var profileImageURL: String
    var database: DatabaseReference
    
    var strings: Constants
    var context: NSManagedObjectContext?
    
    init(id: String, createdDate: Date, createdDateString: String, visibility: Bool, username: String, fullname: String, bio: String, profileImageURL: String) {
        
        let strings = Constants.sharedInstance
        
        self.id = id
        self.createdDate = createdDate
        self.createdDateString = createdDateString
        self.visibility = visibility
        self.username = username
        self.fullname = fullname
        self.bio = bio
        self.profileImageURL = profileImageURL
        database = Database.database().reference()
        
        self.strings = strings
        context = ThreadsData.sharedInstance.container?.viewContext
    }
    
    //MARK:- Observe
    func observe(_ type: User.ListType, reference: DatabaseReference, action: Action, toFirst: UInt?, context: NSManagedObjectContext, completion: @escaping (Feedback, Error?) -> Void){
        
        User.get(userId: id, context: context, strings: strings) { (user, error) in
        
            let feedback = user.1
    
            if feedback == .successful {
               
                switch action {
                case .add:
                    
                    if let toFirst = toFirst {
                        var completed = 0
                        
                        reference.queryLimited(toFirst: toFirst).observe(.childAdded, with: { (snapshot) in
                            let objectId = snapshot.key
                        
                            user.0?.initiate(action: action, in: type, objectId: objectId, context: context, strings: self.strings, completion: { (feedback, error) in
                                completed = completed + 1
                                
                                if feedback != .successful {
                                    completion(feedback, error)
                                }
                                
                                if completed == toFirst {
                                    completion(.successful, nil)
                                    return
                                }
                            })
                            
                        }, withCancel: { (error) in
                            completion(.failedWhileObserving, error)
                            return
                        })
                    }else {
                        
                        completion(.failedToGetLimitUInt, nil)
                        return
                    }
                    break
                case .remove:
                    reference.observe(.childRemoved, with: { (snapshot) in
                        let objectId = snapshot.key
                        
                        user.0?.initiate(action: action, in: type, objectId: objectId, context: context, strings: self.strings, completion: { (feedback, error) in
                            completion(feedback, error)
                        })
                        
                    }, withCancel: { (error) in
                        completion(.failedWhileObserving, error)
                    })
                    break
                }
            }else {
                completion(feedback, error)
                return
            }
        }
    }
   
}

struct MockUserStructure: UserStructureProtocol {
    func getBookmarkState(for mediaStructure: MediaStructureProtocol, completion: @escaping (UserStructure.BookmarkState) -> Void) {
        
    }
    
    func getShareState(for mediaStructure: MediaStructureProtocol, completion: @escaping (UserStructure.ShareState) -> Void) {
        
    }
    
    func observe(_ type: User.ListType, reference: DatabaseReference, action: Action, toFirst: UInt?, context: NSManagedObjectContext, completion: @escaping (Feedback, Error?) -> Void) {
        
    }
   
    
    func follow(selectedUserStructure: UserStructureProtocol, completion: @escaping (Feedback, Error?) -> Void) {
        
    }
    
    func unfollow(selectedUserStructure: UserStructureProtocol, completion: @escaping (Feedback, Error?) -> Void) {
        
    }
    
    func cancelPending(selectedUserStructure: UserStructureProtocol, completion: @escaping (Feedback, Error?) -> Void) {
        
    }
    
    func acceptPending(selectedUserStructure: UserStructureProtocol, completion: @escaping (Feedback, Error?) -> Void) {
        
    }
    
    func withdrawRequest(selectedUserStructure: UserStructureProtocol, completion: @escaping (Feedback, Error?) -> Void) {
        
    }
    
    
    func removeShare(mediaStructure: MediaStructureProtocol, completion: @escaping (Feedback, Error?) -> Void) {
        
    }
    
    func share(mediaStructure: MediaStructureProtocol, completion: @escaping (Feedback, Error?) -> Void) {
        
    }
    
    func removeBookmark(mediaStructure: MediaStructureProtocol, completion: @escaping (Feedback, Error?) -> Void) {
        
    }
    
    func bookmark(mediaStructure: MediaStructureProtocol, completion: @escaping (Feedback, Error?) -> Void) {
        
    }
    
    func addThread(threadTemplate: ThreadTemplate, completion: @escaping (Feedback, Error?) -> Void) {
        
    }
    
    func removeThread(selectedThreadStructure: ThreadStructureProtocol, completion: @escaping (Feedback, Error?) -> Void) {
        
    }
    
   
    func getBookmarkState(for mediaStructure: MediaStructureProtocol, completion: @escaping (Feedback, UserStructure.BookmarkState) -> Void) {
        
    }
    
    func getShareState(for mediaStructure: MediaStructureProtocol, completion: @escaping (Feedback, UserStructure.ShareState) -> Void) {
        
    }
    
    func updateProfileImage(with image: UIImage, completion: @escaping (Bool, Error?) -> Void) {
        
    }
    
    func removeProfileImage(completion: @escaping (Bool, Error?) -> Void) {
        
    }
    
    func edit(editInfo: [String : Any]) -> Bool {
        return true
    }
   
    private var _id: String
    var id: String {
        return _id
    }
    
    private var _bio: String
    var bio: String {
        return _bio
    }
    
    private var _username: String
    var username: String {
        return _username
    }
    
    private var _fullname: String
    var fullname: String {
        return _fullname
    }
    
    private var _profileImageURL: String
    var profileImageURL: String {
        return _profileImageURL
    }
    
    private var _visibility: Bool
    var visibility: Bool {
        return _visibility
    }
    
    private var _createdDate: Date
    var createdDate: Date {
        return _createdDate
    }
    
    init(id: String, visibility: Bool, bio: String, username: String, fullname: String, profileImageURL: String, createdDate: Date) {
        _id = id
        _visibility = visibility
        _bio = bio
        _username = username
        _fullname = fullname
        _profileImageURL = profileImageURL
        _createdDate = createdDate
    }
    
    func checkIfFollowing(userId: String, completion: @escaping (Bool) -> Void) {
    }
    
    func checkIfPending(userId: String, completion: @escaping (Bool) -> Void) {
    }
    
    func checkIfRequested(userId: String, completion: @escaping (Bool) -> Void) {
    }
}






