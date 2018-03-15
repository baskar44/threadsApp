//
//  ThreadStructureProtocol.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 27/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import UIKit
import CoreData
import Firebase

protocol ThreadStructureProtocol: MediaStructureProtocol {
    
    var creatorStructure: UserStructureProtocol {get}
    var id: String {get}
    var createdDate: Date {get}
    var title: String {get}
    
    func observe(_ observe: Observe, type: ObserveType, context: NSManagedObjectContext, completion: @escaping (Feedback, Error?) -> Void)
    
    func removePhoto(photoStructure: PhotoStructure, completion: @escaping (Feedback, Error?) -> Void)
    func removeBody(bodyStructure: BodyStructureProtocol, completion: @escaping (Feedback, Error?) -> Void)
    func isReadyForRemove(mediaType: ThreadStructure.MediaChildType, completion: @escaping (Bool) -> Void)
}

enum LogAction {
    case remove
    case add
}

extension ThreadStructureProtocol {
    //when thread adds OR removes: body/photo/audio/video
    
    func getLogRelatedItemValuesAndId(_ sections:[ThreadStructure.ThreadSection], strings: Constants) -> [String: ([String:Any], String)] {
        
      
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
                    strings._createdBy: creatorStructure.id,
                    strings._targetThread: self.id,
                    strings._visibility: visibility]
                    as [String:Any]
                
                itemValuesAndIds.updateValue((itemValues, id), forKey: forKey)
            }
        }
        
        return itemValuesAndIds
        
        
    }
    
    func getLogRelatedItemValuesAndId(_ action:ThreadStructure.ThreadAction, mediaChildType: ThreadStructure.MediaChildType, mediaChildId: String, strings: Constants) -> [String: ([String:Any], String)]{
        //update of body/photo/video/audio
        var target = strings._emptyString
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
        }
        
        switch mediaChildType {
        case .audio:
            target = strings._targetAudio
            break
        case .body:
            target = strings._targetBody
            break
        case .film:
            target = strings._targetVideo
            break
        case .photo:
            target = strings._targetPhoto
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
                    strings._createdBy: creatorStructure.id,
                    target: self.id,
                    strings._visibility: visibility]
                    as [String:Any]
                
                itemValuesAndIds.updateValue((itemValues, id), forKey: forKey)
            }
        }
        
        return itemValuesAndIds
    }
    
    func getMessage(_ action: ThreadStructure.ThreadAction, type: ItemType, strings: Constants) -> String {
        
        var headerText: String = strings._emptyString
        
        if type == .journal {
            headerText = strings._You
        }else {
            headerText = "\(creatorStructure.username) has"
        }
        
        var message = strings._emptyString
        
        switch action {
        case .add:
            message = "\(headerText) added:"
            break
        case .remove:
            message = "\(headerText) removed:"
            break
        }
        
        return message
    }
    
    func getMessage(_ sections: [ThreadStructure.ThreadSection], type: ItemType, strings: Constants) -> String {
        
        var updated: [ThreadStructure.ThreadSection] = []
        var headerText: String = strings._emptyString
        
        if type == .journal {
            headerText = strings._You
        }else {
            headerText = "\(creatorStructure.username) has"
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
}
