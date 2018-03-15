//
//  User.swift
//  Instance_
//
//  Created by Gururaj Baskaran on 30/10/17.
//  Copyright © 2017 Gururaj Baskaran. All rights reserved.
//
     

     
import CoreData
import Firebase

enum Feedback {
    case successful
    case failed
    case failedWithErr
    case failedWhileInitializingObject
    case failedWhileFetchingObjects
    case failedWhileAttemptingToSetId
    case failedWhileCallingBackend
    case failedToGetTheRequiredAttributes
    case failedToCreateCreatedDateString
    case failedWhileSavingToContext
    case failedWhileObserving
    case failedWhileGettingContext
    case failedWhileConnectingCore
    case failedToGetForKey
    case failedToGetDatabaseReference
    case failedToGetLimitUInt
    case failedWhileGettingTotalNumberOfObjects
    case failedToRetrieveCreatorWithErr
    case failedToRetrieveCreator
    case failedToGetLog
    case targetAlreadyExists
    case threadHasExistingChildren
    case failedToAdd
    case failedToRemove
    case failedWithChangingBookmarkState
    case failedWithChangingShareState
    case failedWhileChangingSocialState
    case cancelled
    case failedWhileGettingFRC
}

class User: Object {
    
    enum ListType: String {
        case sharedThreads = "Shared Threads"
        case sharedPhotos = "Shared Photos"
        case sharedVideo = "Shared Video"
        case sharedAudio = "Shared Audio"
        case sharedBody = "Shared Body"
        case bookmarkedThreads = "Bookmarked Threads"
        case bookmarkedPhotos = "Bookmarked Photos"
        case bookmarkedVideo = "Bookmarked Video"
        case bookmarkedAudio = "Bookmarked Audio"
        case bookmarkedBody = "Bookmarked Body"
        case createdThreads = "Created Threads"
        case createdPhotos = "Created Photos"
        case createdVideo = "Created Video"
        case createdAudio = "Created Audio"
        case createdBody = "Created Body"
        case following = "Following"
        case followers = "Followers"
        case journal = "Journal"
        case feed = "Feed"
        case requested = "Requested"
        case pending = "Pending"
    }
    
    
    
    //Firebase Database References - remove later
    var followingReference: DatabaseReference?
    var followersReference: DatabaseReference?
    var pendingReference: DatabaseReference?
    var requestedReference: DatabaseReference?
    var threadsReference: DatabaseReference?
    var moderatingReference: DatabaseReference?
    var profileImageReference: DatabaseReference?
   
    typealias user = (User?, Feedback)
    
    //Class Function: Gets the USER for the given userId
    class func get(userId: String, context: NSManagedObjectContext, strings: Constants, completion: @escaping (user, Error?) -> Void) {
        
        let request: NSFetchRequest<User> = fetchRequest()
        request.predicate = NSPredicate(format: strings._ifId, userId)
        context.perform {
            do {
                let userObjects = try context.fetch(request)
                
                if userObjects.count > 0 && userObjects.count < 2 {
                    guard let userObject = userObjects.first else {
                        completion((nil, .failedWhileInitializingObject), nil)
                        return
                    }
                    
                    completion((userObject, .successful), nil)
                    return
                }else {
                    
                    //to ensure only one user with the given id exists
                    if userObjects.count > 1 {
                        //error in db. there should not be more than 1 item with the same id.
                        //remove all objects with this id
                        for userObject in userObjects {
                            context.delete(userObject)
                        }
                    }
                    
                    let newUser = User(context: context)
                    newUser.setValue(userId, forKey: strings._id)
                    newUser.connectCore(context: context, strings: strings, completion: { (feedback, error) in
                        if feedback == .successful {
                            
                            completion((newUser, feedback), nil)
                        }else {
                            
                            if let error = error {
                                completion((nil, feedback), error)
                            }else {
                                completion((nil, feedback), nil)
                            }
                        }
                        
                        return
                    })
                }
            }catch {
                completion((nil, .failedWhileFetchingObjects), error)
                return
            }
        }
    }
    
    func createStructure() -> UserStructure? {
        guard let id = id, let createdDate = createdDate, let fullname = fullname, let bio = bio, let username = username, let profileImageURL = profileImageURL else {
            return nil
        }
        
        let visibility = self.visibility
        let createdDateString = ThreadsData.getCurrentDateString(date: createdDate)
        let userStructure = UserStructure(id: id, createdDate: createdDate, createdDateString: createdDateString, visibility: visibility, username: username, fullname: fullname, bio: bio, profileImageURL: profileImageURL)
        
        return userStructure
    }
    
   
}


