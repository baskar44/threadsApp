//
//  UserStructureProtocol.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 27/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit
import Firebase
import CoreData

protocol UserStructureProtocol: ObjectStructureProtocol {
    var bio: String {get}
    var username: String {get}
    var fullname: String {get}
    var profileImageURL: String {get}
    
    func checkIfFollowing(userId: String, completion: @escaping (Bool) -> Void)
    func checkIfPending(userId: String, completion: @escaping (Bool) -> Void)
    func checkIfRequested(userId: String, completion: @escaping (Bool) -> Void)
    
    func unfollow(selectedUserStructure: UserStructureProtocol, completion: @escaping (Feedback, Error?) -> Void)
    func follow(selectedUserStructure: UserStructureProtocol, completion: @escaping (Feedback, Error?) -> Void)
    func cancelPending(selectedUserStructure: UserStructureProtocol, completion: @escaping (Feedback, Error?) -> Void)
    func acceptPending(selectedUserStructure: UserStructureProtocol, completion: @escaping (Feedback, Error?) -> Void)
    func withdrawRequest(selectedUserStructure: UserStructureProtocol, completion: @escaping (Feedback, Error?) -> Void)
    
    func addThread(threadTemplate: ThreadTemplate, completion: @escaping (Feedback, Error?) -> Void)
    func removeThread(selectedThreadStructure: ThreadStructureProtocol, completion: @escaping (Feedback, Error?) -> Void)
    
    func updateProfileImage(with image: UIImage, completion: @escaping (Bool, Error?) -> Void)
    func removeProfileImage(completion: @escaping (Bool, Error?) -> Void)
    func edit(editInfo: [String:Any]) -> Bool
   
    func removeShare(mediaStructure: MediaStructureProtocol, completion: @escaping (Feedback, Error?) -> Void)
    func share(mediaStructure: MediaStructureProtocol, completion: @escaping (Feedback, Error?) -> Void)
    func removeBookmark(mediaStructure: MediaStructureProtocol, completion: @escaping (Feedback, Error?) -> Void)
    func bookmark(mediaStructure: MediaStructureProtocol, completion: @escaping (Feedback, Error?) -> Void)
    
    func getBookmarkState(for mediaStructure: MediaStructureProtocol, completion: @escaping (UserStructure.BookmarkState) -> Void)
    func getShareState(for mediaStructure: MediaStructureProtocol, completion: @escaping (UserStructure.ShareState) -> Void)
    
    func observe(_ type: User.ListType, reference: DatabaseReference, action: Action, toFirst: UInt?, context: NSManagedObjectContext, completion: @escaping (Feedback, Error?) -> Void)
}

enum UserSection: String {
    case username = "Username"
    case bio = "Bio"
    case profileImage = "Profile Image"
}

extension UserStructureProtocol {
    
    //update
    func getLogRelatedItemValuesAndId(_ sections: [UserSection], strings: Constants) -> [String: ([String:Any], String)]{
        //update of body/photo/video/audio
        let itemTypes: [ItemType] = [.feed, .journal]
        
        var itemValuesAndIds: [String: ([String:Any], String)] = [:]
        
        for itemType in itemTypes {
            let itemPath = getItemPath(itemType)
            let id = Database.database().reference().child(itemPath).childByAutoId().key
            let createdDate = Date()
            let createdDateString = ThreadsData.getCurrentDateString(date: createdDate)
            
            var forKey: String?
            
            if itemType == .feed {
                forKey = strings._FeedItem
            }else if itemType == .journal {
                forKey = strings._JournalItem
            }
            
            if let forKey = forKey {
                
                let message = getMessage(sections, type: itemType, strings: strings)
                
                let itemValues = [
                    strings._createdDate:createdDateString,
                    strings._message: message,
                    strings._createdBy: self.id,
                    strings._targetUser: self.id,
                    strings._visibility: visibility]
                    as [String:Any]
                
                itemValuesAndIds.updateValue((itemValues, id), forKey: forKey)
            }
        }
        
        return itemValuesAndIds
    }
    
    func getMessage(_ sections: [UserSection], type: ItemType, strings: Constants) -> String {
        
        var updated: [UserSection] = []
        var headerText: String = strings._emptyString
        
        if type == .journal {
            headerText = strings._You
        }else if type == .feed {
            headerText = "\(username) has"
        }
        
        for section in sections {
            updated.append(section)
        }
        
        var message = strings._emptyString
        if updated.count == 1 {
            
            if let text = updated.first?.rawValue {
                message = "\(headerText) updated the \(text) of:"
            }
            
        }else if updated.count == 2 {
            
            if let text = updated.first?.rawValue, let moreText = updated.last?.rawValue {
                message = "\(headerText) updated the \(text) and \(moreText) of:"
            }
            
        }else if updated.count > 2 {
            if let text = updated.first?.rawValue {
                message = "\(headerText) updated the \(text) and other attributes of:"
            }
        }
        
        return message
    }
    
    //add and remove of thread
    func getLogRelatedItemValuesAndId(_ action:UserStructure.UserAction, mediaChildId: String, strings: Constants) -> [String: ([String:Any], String)]{
        //update of body/photo/video/audio
        var itemTypes: [ItemType] = []
        
        var itemValuesAndIds: [String: ([String:Any], String)] = [:]
        
        switch action {
        case .add:
            //both feed and journal
            itemTypes.append(.journal)
            itemTypes.append(.feed)
            break
        case .remove:
            //only journal
            itemTypes.append(.journal)
            break
        default:
            break
        }
        
        for itemType in itemTypes {
            let itemPath = getItemPath(itemType)
            let id = Database.database().reference().child(itemPath).childByAutoId().key
            let createdDate = Date()
            let createdDateString = ThreadsData.getCurrentDateString(date: createdDate)
            
            var forKey: String?
            
            if itemType == .feed {
                forKey = strings._FeedItem
            }else if itemType == .journal {
                forKey = strings._JournalItem
            }
            
            if let forKey = forKey {
                
                let message = getMessage(action, type: itemType, strings: strings)
                
                let itemValues = [
                    strings._createdDate:createdDateString,
                    strings._message: message,
                    strings._createdBy: self.id,
                    strings._targetThread: mediaChildId,
                    strings._visibility: visibility]
                    as [String:Any]
                
                itemValuesAndIds.updateValue((itemValues, id), forKey: forKey)
            }
        }
        
        return itemValuesAndIds
    }
    
    
    func getLogRelatedItemValuesAndId(_ action:UserStructure.UserAction, object: ObjectStructureProtocol, strings: Constants) -> [String: ([String:Any], String)]{
        //update of body/photo/video/audio
        var itemTypes: [ItemType] = []
        
        var itemValuesAndIds: [String: ([String:Any], String)] = [:]
        
        var target: String?
        
        if object is ThreadStructureProtocol {
            target = strings._targetThread
        }else if object is BodyStructureProtocol {
            target = strings._targetBody
        }else if object is PhotoStructureProtocol {
            target = strings._targetPhoto
        }else if object is AudioStructure {
            target = strings._targetAudio
        }else if object is FilmStructure {
            target = strings._targetVideo
        }else if object is UserStructureProtocol {
            target = strings._targetUser
        }
        
        if let target = target {
            switch action {
            case .add:
                //both feed and journal
                itemTypes.append(.journal)
                itemTypes.append(.feed)
                break
            case .remove:
                //only journal
                itemTypes.append(.journal)
                break
            case .share:
                itemTypes.append(.journal)
                itemTypes.append(.feed)
                break
            case .bookmark:
                itemTypes.append(.journal)
                break
            case .removeShare:
                itemTypes.append(.journal)
                break
            case .removeBookmark:
                itemTypes.append(.journal)
                break
            case .follow:
                itemTypes.append(.journal)
                break
            case .request:
                itemTypes.append(.journal)
                break
            case .unFollow:
                itemTypes.append(.journal)
                break
            case .cancelPending:
                itemTypes.append(.journal)
                break
            case .acceptPending:
                itemTypes.append(.journal)
                break
                
            case .withdrawRequest:
                itemTypes.append(.journal)
                break
            }
            
            for itemType in itemTypes {
                let itemPath = getItemPath(itemType)
                let id = Database.database().reference().child(itemPath).childByAutoId().key
                let createdDate = Date()
                let createdDateString = ThreadsData.getCurrentDateString(date: createdDate)
                
                var forKey: String?
                
                if itemType == .feed {
                    forKey = strings._FeedItem
                }else if itemType == .journal {
                    forKey = strings._JournalItem
                }
                
                if let forKey = forKey {
                    
                    let message = getMessage(action, type: itemType, strings: strings)
                    
                    let itemValues = [
                        strings._createdDate:createdDateString,
                        strings._message: message,
                        strings._createdBy: self.id,
                        target: object.id,
                        strings._visibility: visibility]
                        as [String:Any]
                    
                    itemValuesAndIds.updateValue((itemValues, id), forKey: forKey)
                }
            }
        }
        
        return itemValuesAndIds
    }
    
    func getMessage(_ action: UserStructure.UserAction, type: ItemType, strings: Constants) -> String {
        
        var headerText: String = strings._emptyString
        
        if type == .journal {
            headerText = strings._You
        }else {
            headerText = "\(username) has"
        }
        
        if action == .acceptPending {
            headerText = "\(username) has"
        }
        
        var message = strings._emptyString
        
        switch action {
        case .add:
            message = "\(headerText) added:"
            break
        case .remove:
            message = "\(headerText) removed:"
            break
        case .share:
            message = "\(headerText) shared:"
            break
        case .bookmark:
            message = "\(headerText) bookmarked:"
            break
        case .removeShare:
            message = "\(headerText) stopped sharing:"
            break
        case .removeBookmark:
            message = "\(headerText) stopped bookmarking:"
            break
        case .follow:
            message = "\(headerText) started following:"
            break
        case .request:
            message = "\(headerText) requested to follow:"
            break
        case .unFollow:
            message = "\(headerText) stopped following:"
            break
        case .cancelPending:
            message = "\(headerText) declined follow request from:"
            break
        case .acceptPending:
            message = "\(headerText) started following:"
            break
        case .withdrawRequest:
            message = "\(headerText) withdrew follow request from:"
            break
        }
        
        return message
    }
}
