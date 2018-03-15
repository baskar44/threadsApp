//
//  PhotoTemplate.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 1/3/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import Firebase
import CoreData

struct PhotoStructure: PhotoStructureProtocol {
    
    var title: String = Constants.sharedInstance._emptyString
    private var _id: String
    private var _imageURL: String
    private var _about: String
    private var _createdDate: Date
    private var _parentStructure: ThreadStructureProtocol
    private var _creatorStructure: UserStructureProtocol
    private var _visibility: Bool
    
    var createdDateString: String
    var visibility: Bool {
        return _visibility
    }
    
    var id: String {
        return _id
    }
    
    var imageURL: String {
        return _imageURL
    }
    
    var about: String {
        return _about
    }
    
    var createdDate: Date {
        return _createdDate
    }
    
    var parentStructure: ThreadStructureProtocol {
        return _parentStructure
    }
    
    var creatorStructure: UserStructureProtocol {
        return _creatorStructure
    }
    
    var strings: Constants
    var context: NSManagedObjectContext?
    var ref: DatabaseReference
    
    init(id: String, imageURL: String, about: String, createdDate: Date, visibility: Bool, parentStructure: ThreadStructureProtocol, creatorStructure: UserStructureProtocol) {
        _id = id
        _imageURL = imageURL
        _about = about
        _createdDate = createdDate
        _parentStructure = parentStructure
        _creatorStructure = creatorStructure
        _visibility = visibility
        createdDateString = ThreadsData.getCurrentDateString(date: createdDate)
        strings = Constants.sharedInstance
        context = ThreadsData.sharedInstance.container?.viewContext
        ref = Database.database().reference().child(Constants.sharedInstance._Photo).child(id)
    }
    
    func updateVisibility(isVisible: Bool) -> Bool {
        Database.database().reference().child(Constants.sharedInstance._Photo).child(id).child(Constants.sharedInstance._visibility).setValue(isVisible)
        
        return true
        
    }
    
    func getMessage(_ type: ItemType) -> String {
        var headerText: String = strings._emptyString
        
        if type == .journal {
            headerText = strings._You
        }else {
            headerText = "\(creatorStructure.username) has"
        }
        
        return "\(headerText) updated the content of:"
        
    }

    //can update visibility and about but not the image itself
    func performUpdate(itemValuesAndId: ([String:Any], String), type: ItemType, context: NSManagedObjectContext, completion: @escaping (Feedback, Error?) -> Void){
        
        User.get(userId: creatorStructure.id, context: context, strings: strings) { (user, error) in
            if let user = user.0 {
                let itemPath = self.getItemPath(type)

                let itemRef = Database.database().reference().child(itemPath).child(itemValuesAndId.1)
                
                itemRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let core = snapshot.value as? NSDictionary {
                        if let _ = core[self.strings._targetThread] as? String, let _ = core[self.strings._targetAudio] as? String, let _ = core[self.strings._targetBody] as? String, let _ = core[self.strings._targetVideo] as? String {
                            
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
    
    
    func updateAbout(text: String, isVisible: Bool, completion: @escaping (Feedback, Error?) -> Void) {
   
        guard let context = context else {
            completion(.failedWhileGettingContext, nil)
            return
        }
        
        let dictionary = getLogRelatedItemValuesAndId(sections: [.content], strings: strings)
        
        guard let journalItemValues = dictionary[strings._JournalItem], let feedItemValues = dictionary[strings._FeedItem] else {
            completion(.failedToGetLog, nil)
            return
        }
        
        performUpdate(itemValuesAndId: journalItemValues, type: .journal, context: context, completion: { (feedback, error) in
            if feedback == .successful {
                
                if isVisible {
                    self.performUpdate(itemValuesAndId: feedItemValues, type: .feed, context: context) { (feedback, error) in
                        if feedback == .successful {
                            self.ref.child(self.strings._about).setValue(text)
                            completion(.successful, nil)
                            
                        }else {
                            completion(feedback, error)
                            
                        }
                        
                        return
                    }
                }else {
                    self.ref.child(self.strings._about).setValue(text)
                    completion(.successful, nil)
                    return
                }
                
            }else {
                completion(feedback, error)
                return
            }
        })
        
    }
}

//remove later
struct PhotoTemplate {
    
    private var _id: String
    var id: String {
        return _id
    }
    
    private var _image: UIImage
    var image: UIImage {
        return _image
    }
    
    private var _about: String
    var about: String {
        return _about
    }
    
    private var _parentKey: String
    var parentKey: String {
        return _parentKey
    }
    
    private var _createdBy: String
    var createdBy: String {
        return _createdBy
    }
    
    private var _createdDate: Date
    var createdDate: Date {
        return _createdDate
    }
    
    private var _visibility: Bool
    var visibility: Bool {
        return _visibility
    }
    
    init(id: String, image: UIImage, parentKey: String, createdDate: Date, createdBy: String, about: String, visibility: Bool) {
        _id = id
        _image = image
        _parentKey = parentKey
        _createdBy = createdBy
        _createdDate = createdDate
        _about = about
        _visibility = visibility
    }
    
    
}
