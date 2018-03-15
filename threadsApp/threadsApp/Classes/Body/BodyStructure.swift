//
//  BodyStructure.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 6/3/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import Firebase
import CoreData

enum ItemType {
    case journal
    case feed
}


struct BodyStructure: BodyStructureProtocol {
   
    
    private var _about:String
    var about: String {
        return _about
    }
    
    private var _id: String
    var id: String {
        return _id
    }
    
    private var _bodyText: String
    var content: String {
        return _bodyText
    }
    
    private var _bodyTitle: String
    var title: String {
        return _bodyTitle
    }
    
    private var _createdDate: Date
    var createdDate: Date {
        return _createdDate
    }
    
    private var _creatorStructure: UserStructureProtocol
    var creatorStructure: UserStructureProtocol {
        return _creatorStructure
    }
    
    private var _parentStructure: ThreadStructureProtocol
    var parentStructure: ThreadStructureProtocol {
        return _parentStructure
    }
    
    private var _visibility: Bool
    var visibility: Bool {
        return _visibility
    }
    
    private var _createdDateString: String
    var createdDateString: String {
        return _createdDateString
    }
    
    private var ref: DatabaseReference
    private var context: NSManagedObjectContext?
    private var strings: Constants
    
    init(id: String, bodyText: String, bodyTitle: String, createdDate:Date, createdDateString: String, creatorStructure: UserStructureProtocol, parentStructure: ThreadStructureProtocol, visibility: Bool, about: String) {
        _about = about
        _id = id
        _bodyText = bodyText
        _bodyTitle = bodyTitle
        _createdDate = createdDate
        _creatorStructure = creatorStructure
        _parentStructure = parentStructure
        _createdDateString = createdDateString
        _visibility = visibility
        ref = Database.database().reference().child(Constants.sharedInstance._Body).child(id)
        context = ThreadsData.sharedInstance.container?.viewContext
        strings = Constants.sharedInstance
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
                        if let _ = core[self.strings._targetThread] as? String, let _ = core[self.strings._targetAudio] as? String, let _ = core[self.strings._targetPhoto] as? String, let _ = core[self.strings._targetVideo] as? String {
                            
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
    
    func update(_ sections: [MediaChildSection], title: String, content: String, isVisible: Bool, completion: @escaping (Feedback, Error?) -> Void){
        
        guard let context = context else {
            completion(.failedWhileGettingContext, nil)
            return
        }
        
        //get feed and journal dicts
        
        let dictionary = getLogRelatedItemValuesAndId(sections: sections, strings: strings)
        
        guard let journalItemValues = dictionary[strings._JournalItem], let feedItemValues = dictionary[strings._FeedItem] else {
            completion(.failedToGetLog, nil)
            return
        }
        
        performUpdate(itemValuesAndId: journalItemValues, type: .journal, context: context, completion: { (feedback, error) in
            if feedback == .successful {
                
                if isVisible {
                    self.performUpdate(itemValuesAndId: feedItemValues, type: .feed, context: context) { (feedback, error) in
                        if feedback == .successful {
                            
                            for section in sections {
                                if section == .title {
                                    self.ref.child(Constants.sharedInstance._bodyTitle).setValue(title)
                                }else if section == .content {
                                    self.ref.child(Constants.sharedInstance._bodyText).setValue(content)
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
                            self.ref.child(Constants.sharedInstance._bodyTitle).setValue(title)
                        }else if section == .content {
                            self.ref.child(Constants.sharedInstance._bodyText).setValue(content)
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
    
    func updateVisibility(_ isVisible: Bool) -> Bool {
        ref.child(Constants.sharedInstance._visibility).setValue(isVisible)
        return true
    }
  
}
