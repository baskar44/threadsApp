//
//  MediaChildStructureProtocol.swift
//  threadsApp
//
//  Created by Gururaj Baskaran on 27/2/18.
//  Copyright © 2018 Gururaj Baskaran. All rights reserved.
//

import Foundation
import Firebase

protocol MediaChildStructureProtocol: MediaStructureProtocol {
    var parentStructure: ThreadStructureProtocol {get}
}


enum MediaChildSection: String {
    case title = "Title"
    case content = "Content"
}

extension MediaChildStructureProtocol {
    
    func getMessage(_ sections: [MediaChildSection], type: ItemType, strings: Constants) -> String {
        
        var updated: [MediaChildSection] = []
        var headerText: String = strings._emptyString
        
        if type == .journal {
            headerText = strings._You
        }else if type == .feed {
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
    
    //for media child updates
    func getLogRelatedItemValuesAndId(sections: [MediaChildSection], strings: Constants) -> [String: ([String:Any], String)]{
        //update of body/photo/video/audio
        var target = strings._emptyString
        let itemTypes: [ItemType] = [.feed, .journal]
        
        var itemValuesAndIds: [String: ([String:Any], String)] = [:]
        
        //adding to both journal and feed
        if self is BodyStructureProtocol {
            target = strings._targetBody
        }else if self is PhotoStructureProtocol {
            target = strings._targetPhoto
        }else if self is AudioStructure { //make it a protocol later
            target = strings._targetAudio
        }else if self is FilmStructure { //make it a protocol later
            target = strings._targetVideo
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
                
                let message = getMessage(sections, type: itemType, strings: strings)
                
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
}
